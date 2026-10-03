#!/usr/bin/env bash
# Verify every entry in .claude-plugin/marketplace.json resolves for a real,
# unauthenticated user. Run in CI; safe to run locally.
#
# The point is that `claude plugin validate` only checks manifest shape. It does
# not check that `source.ref` exists, so a pin pointing at a nonexistent tag
# validates cleanly and then fails at install time with
# "unable to get password from user" or an unresolvable-ref error.
#
# Every clone here is deliberately credential-free. If this job ran with the
# default GITHUB_TOKEN it could clone a private repo and report success, while
# every actual user got a password prompt. The failure this catches is
# specifically a repo that is not publicly readable.

set -uo pipefail

MANIFEST=".claude-plugin/marketplace.json"
fail=0
warn=0

say()  { printf '%s\n' "$*"; }
bad()  { printf '  ✘ %s\n' "$*"; fail=$((fail + 1)); }
soft() { printf '  ⚠ %s\n' "$*"; warn=$((warn + 1)); }
ok()   { printf '  ✔ %s\n' "$*"; }

# Clone with every credential source disabled. GIT_TERMINAL_PROMPT=0 stops a
# hung password prompt from stalling the job.
anon_clone() {
  local url="$1" ref="$2" dest="$3"
  GIT_TERMINAL_PROMPT=0 GCM_INTERACTIVE=never \
  git -c credential.helper= \
      -c core.askPass= \
      -c http.extraheader= \
      -c protocol.version=2 \
      clone --quiet --depth 1 ${ref:+--branch "$ref"} "$url" "$dest" 2>/dev/null
}

say "== Catalog verification =="
say "manifest: $MANIFEST"
say ""

# --- static checks -------------------------------------------------------
say "-- Entry names (reserved-prefix check) --"
name_errors=$(python3 - "$MANIFEST" <<'PY'
import json, sys
reserved = ("claude-", "anthropic-", "anthropics-", "cc-plugin-")
exact = {"claude", "anthropic", "anthropics", "claude-code", "claude-mods"}
d = json.load(open(sys.argv[1]))
bad = []
for p in d.get("plugins", []):
    n = p.get("name", "")
    if n in exact or n.startswith(reserved):
        bad.append(f"{n} is reserved by Anthropic and can never install")
    if not n:
        bad.append("entry has no name")
if not d.get("name"):
    bad.append("marketplace has no name")
print("\n".join(bad))
PY
)
if [ -n "$name_errors" ]; then
  while IFS= read -r line; do bad "$line"; done <<< "$name_errors"
else
  ok "no reserved or malformed plugin names"
fi
say ""

# --- resolve each entry --------------------------------------------------
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# Fields are separated by 0x1F (unit separator), NOT tab. Tab is an IFS
# whitespace character, so read collapses runs of tabs and every empty field
# shifts the ones after it.
while IFS=$'\x1f' read -r name url ref subpath source_kind; do
  [ -z "$name" ] && continue
  say "-- $name --"
  printf '  url:  %s\n' "$url"
  printf '  ref:  %s\n' "${ref:-<none — tracks default branch>}"

  dest="$tmp/$name"
  if ! anon_clone "$url" "${ref:-}" "$dest"; then
    if [ -n "$ref" ]; then
      bad "ref '$ref' is not clonable anonymously — tag missing, or the repo is private"
    else
      bad "repository is not clonable anonymously — it is private or missing"
    fi
    say ""
    continue
  fi
  ok "clones anonymously"

  root="$dest${subpath:+/$subpath}"
  if [ -n "$subpath" ] && [ ! -d "$root" ]; then
    bad "subdir '$subpath' does not exist in the source repo"
    say ""
    continue
  fi

  mj="$root/.claude-plugin/plugin.json"
  if [ ! -f "$mj" ]; then
    bad "no .claude-plugin/plugin.json at the resolved ref"
    say ""
    continue
  fi
  ok "plugin manifest present"

  read -r pname pversion declared_version <<EOF
$(python3 - "$mj" "$name" "$MANIFEST" <<'PY'
import json, sys
m = json.load(open(sys.argv[1]))
entry = next((p for p in json.load(open(sys.argv[3]))["plugins"] if p["name"] == sys.argv[2]), {})
print(m.get("name", ""), m.get("version", "") or "-", entry.get("version", "-") or "-")
PY
)
EOF

  if [ "$pname" != "$name" ]; then
    bad "plugin name mismatch: catalog says '$name', manifest at this ref says '$pname'"
    say "      (a rename at the source repo must be mirrored in the catalog entry name)"
  else
    ok "plugin name matches catalog entry"
  fi

  if [ "$declared_version" != "-" ]; then
    if [ "$pversion" != "$declared_version" ]; then
      bad "version mismatch: entry declares '$declared_version' but the ref contains '$pversion'"
    else
      ok "declared version '$declared_version' matches the ref"
    fi
  fi

  if [ -z "$ref" ]; then
    soft "unpinned — installs whatever the default branch points at. Pin to a release tag if this should be reproducible."
  fi

  say "  resolved: ${pname:-?} ${pversion:-?}"
  say ""
done < <(python3 - "$MANIFEST" <<'PY'
import json, sys
SEP = "\x1f"
d = json.load(open(sys.argv[1]))
for p in d.get("plugins", []):
    s = p.get("source", {})
    fields = [
        p.get("name", ""),
        s.get("url", ""),
        s.get("ref", ""),
        s.get("path", ""),
        s.get("source", "url"),
    ]
    sys.stdout.write(SEP.join(fields) + "\n")
PY
)

say "== Summary =="
say "  errors: $fail   warnings: $warn"
[ "$fail" -gt 0 ] && exit 1
exit 0