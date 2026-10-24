# KHA Entertainment Marketplace

Claude Code plugins from KHA Entertainment. Add the marketplace once, then install only the plugins you want.

## 1. Add the marketplace (once)

In your terminal:

```sh
claude plugin marketplace add KHAEntertainment/marketplace
```

Or inside a Claude Code session:

```
/plugin marketplace add KHAEntertainment/marketplace
```

## 2. Pick your plugins

Click a plugin to see what it does and how to install it. Each one installs on its own.

The commands use the terminal form. Inside a session, type `/plugin install ...` instead of `claude plugin install ...`.

### Running agents

<details>
<summary><b>handoff</b>: saves a resume note before your context compacts</summary>

<br>

Before your context is compacted, the agent writes itself a resume note. The session compacts, then the agent reads the note and carries on where it left off.

```sh
claude plugin install handoff@kha-marketplace
```

After install: nothing to run. It triggers at 80% context (configurable) or when you type `/compact`. Needs a Claude Code build with module hooks.

</details>

<details>
<summary><b>view-limits</b>: checks your coding-plan credits and rate limits before you dispatch sub-agents</summary>

<br>

Checks the credit and rate-limit status of your coding-plan accounts (MiniMax, Kimi, GLM, DeepSeek, OpenRouter) before you send work to sub-agents.

```sh
claude plugin install view-limits@kha-marketplace
```

After install: run `/view-limits:setup` to add your keys, then `/view-limits` for a live report.

</details>

<details>
<summary><b>dev-skill</b>: runs an issue-to-pull-request workflow as your Tech Lead</summary>

<br>

Turns Claude Code into a Tech Lead that takes an issue through to a pull request: requirements, worktrees, delegated workers, QA, review, and a retro.

```sh
claude plugin install dev-skill@kha-marketplace
```

After install: start a run with `/dev`.

</details>

### Building with Claude

<details>
<summary><b>authoring-kit</b>: builds skills, hooks, subagents and plugins from the live Claude Code docs</summary>

<br>

Has Claude build Claude Code skills, hooks, subagents and plugins from the live code.claude.com docs instead of stale training data.

```sh
claude plugin install authoring-kit@kha-marketplace
```

After install: the `claude-code-authoring` skill loads when you ask Claude to build one of those. Previously listed as `claude-code-dev-kit`, which could not install; use `authoring-kit`.

</details>

<details>
<summary><b>jev</b>: guides adding TypeSafe's Jev decision model to a project</summary>

<br>

Helps you decide when and how to add TypeSafe's Jev decision model to a project: which access path (TypeSafe, OpenRouter, Vercel AI SDK/Gateway, Cloudflare), which framework, which harness pattern (tool-call gates, routers, triage), and how to calibrate and run it. Pairs with TypeSafe's official `typesafe-ai/skills`.

```sh
claude plugin install jev@kha-marketplace
```

After install: ask Claude about integrating Jev and the `jev-integration` skill takes over.

</details>

### Secrets

<details>
<summary><b>enigma</b>: lets the agent use API keys without seeing them</summary>

<br>

You enter the secret through a one-time local URL; the value is not returned in MCP tool responses. `enigma_reveal` shows it to you directly, and `enigma run` injects it into a child process's environment.

```sh
claude plugin install enigma@kha-marketplace
```

After install: ask the agent to add a key, for example "I need to add my OpenAI API key for this project."

> **Heads up:** child-process output can still expose a secret (for example `enigma run -- printenv NAME`).

> **Upgrading from before 0.3.0?** Secrets saved from a worktree, symlinked clone path, or submodule need `enigma migrate-scope`.

</details>

---

## For maintainers

### Where versions live

`.claude-plugin/marketplace.json` is the source of truth. Each entry's `source.ref` pins the plugin to a release tag, so an install resolves to a known version and does not silently drift. This README deliberately lists no version numbers.

Cutting a release in a source repo does **not** reach users on its own: bump that entry's `source.ref` in `.claude-plugin/marketplace.json` and merge.

Two entries have sources worth knowing about:

- `dev-skill` builds from the `KHAEntertainment/showrunner` repo.
- `enigma` lives at `plugins/enigma/` in `Clarit-AI/enigma` (git-subdir source type).

### CI guards this

[`verify-catalog`](.github/workflows/verify-catalog.yml) resolves every entry on each PR and weekly, cloning **anonymously** the way a real user does. It fails when:

- `source.ref` does not exist, or the source repo is not publicly readable
- the plugin name at that ref no longer matches the catalog entry name
- an entry declares a `version` that differs from the ref's manifest
- a plugin name uses a prefix Anthropic reserves (`claude-`, `anthropic-`, …)

`claude plugin validate` does **not** cover these. It checks manifest shape only, so a dead pin passes validation and fails at install time. Unpinned entries are reported as warnings rather than failures; pinning is a deliberate per-plugin choice.

### Repository rename

This repository was renamed from `KHAEntertainment/kha-marketplace` to `KHAEntertainment/marketplace`. The manifest's `name` remains `kha-marketplace`, so install identifiers such as `view-limits@kha-marketplace` stay as they are.

GitHub redirects clone, fetch, and push from the old URL, but the redirect does not rewrite local Git configuration. Update existing clones:

```sh
git remote set-url origin https://github.com/KHAEntertainment/marketplace.git
git remote -v
```

If your publishing remote has another name, replace `origin`. Use the new URL in publishing scripts and contributor instructions.

**Do not recreate a repository at the old path:** doing so would remove the redirect. See [GitHub's repository rename documentation](https://docs.github.com/en/repositories/creating-and-managing-repositories/renaming-a-repository).
