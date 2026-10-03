# KHA Entertainment Marketplace

KHA Entertainment's Claude Code plugin marketplace.

Repository: `KHAEntertainment/marketplace`.
The internal catalog name remains `kha-marketplace`; use that name after `@`
when installing plugins.

## Version pinning

Each entry's `source.ref` pins the plugin to a release tag, so an install
resolves to a known version and does not silently drift.

| Plugin | Pin | Notes |
|---|---|---|
| `view-limits` | *unpinned* | Tracks `main`. No release tags exist yet — see below. |
| `jev` | `v0.1.1` | |
| `enigma` | `enigma--v0.3.2` | |
| `authoring-kit` | `v0.1.0` | |
| `dev-skill` | `v2.1.1` | |

Cutting a release in a source repo does **not** reach users on its own: bump
that entry's `source.ref` in `.claude-plugin/marketplace.json` and merge.

`view-limits` is the one exception and is deliberately left tracking `main`
until it publishes its first release tag. Its catalog pin should be added in the
same PR that creates that tag.

## Plugins

- **view-limits** — check coding-plan credit / rate-limit status across providers
  (MiniMax, Kimi, GLM, DeepSeek, OpenRouter) before dispatching sub-agents.
  Source: `https://github.com/KHAEntertainment/view-limits`.
- **jev** — decide when and how to integrate TypeSafe's Jev decision model: fit test,
  access paths (TypeSafe, OpenRouter, Vercel AI SDK/Gateway, Cloudflare), framework
  choice, harness patterns (tool-call gates, routers, triage), calibration and ops.
  Pairs with TypeSafe's official `typesafe-ai/skills`.
  Source: `https://github.com/KHAEntertainment/jev-skill`.
- **enigma** — local-only MCP secret request/reveal server (CLI + Claude Code plugin):
  request a named secret via a one-time URL; the value is not returned in MCP
  tool responses, but child-process output can expose it (e.g. `enigma run --
  printenv NAME`). `enigma_reveal` discloses it to the human directly;
  `enigma run` injects it into a child process's environment (ADR-001).
  The 0.3.0 release pins repo-level project scope: secrets saved from a
  worktree, symlinked clone path, or submodule need `enigma migrate-scope`
  after upgrade. Pinned to tag `enigma--v0.3.0` via the manifest's
  `source.ref`; the plugin lives at `plugins/enigma/` in the source repo
  (git-subdir source type). Source: `https://github.com/Clarit-AI/enigma.git`.
- **authoring-kit** — author Claude Code skills, hooks, subagents and plugins
  against the live code.claude.com docs instead of stale training data or bundled
  guides. Ships the `claude-code-authoring` skill. Formerly listed as
  `claude-code-dev-kit`, which is a reserved plugin name and could not install.
  Source: `https://github.com/KHAEntertainment/claude-code-dev-kit`.
- **dev-skill** — turns Claude Code into a Tech Lead running an Issue-to-PR SOP:
  requirements, worktrees, delegated workers, QA, review, and retro gates.
  Ships the `/dev` skill. Pinned to tag `v2.1.1` via the manifest's `source.ref`.
  Source: `https://github.com/KHAEntertainment/claude-dev-skill`.

## Install

```sh
claude plugin marketplace add KHAEntertainment/marketplace
claude plugin install view-limits@kha-marketplace
claude plugin install jev@kha-marketplace
claude plugin install enigma@kha-marketplace   # installs enigma--v0.3.0
claude plugin install authoring-kit@kha-marketplace
claude plugin install dev-skill@kha-marketplace      # installs v2.1.1
```

Or, inside a Claude Code session:

```
/plugin marketplace add KHAEntertainment/marketplace
/plugin install view-limits@kha-marketplace
/plugin install jev@kha-marketplace
/plugin install enigma@kha-marketplace
/plugin install authoring-kit@kha-marketplace
/plugin install dev-skill@kha-marketplace
```

## Repository rename and existing contributors

This repository was renamed from `KHAEntertainment/kha-marketplace` to
`KHAEntertainment/marketplace`. The manifest's `name` remains `kha-marketplace`,
and existing plugin entries are unchanged.

GitHub redirects Git clone, fetch, and push operations from the old repository
URL. Existing clones should still update their remote explicitly; the redirect
does not rewrite local Git configuration:

```sh
git remote set-url origin https://github.com/KHAEntertainment/marketplace.git
git remote -v
```

Use the new repository URL in publishing scripts and contributor instructions.
If your publishing remote has another name, replace `origin` accordingly.
Keep plugin installation identifiers such as `view-limits@kha-marketplace` as-is.
Do not recreate a repository at the old path: doing so would remove the redirect.

See [GitHub's repository rename documentation](https://docs.github.com/en/repositories/creating-and-managing-repositories/renaming-a-repository).
