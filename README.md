# KHA Entertainment Marketplace

KHA Entertainment's Claude Code plugin marketplace.

Repository: `KHAEntertainment/marketplace`.
The internal catalog name remains `kha-marketplace`; use that name after `@`
when installing plugins.

## Plugins

- **view-limits** — check coding-plan credit / rate-limit status across providers
  (MiniMax, Kimi, GLM, DeepSeek, OpenRouter) before dispatching sub-agents.
  Source: `https://github.com/KHAEntertainment/view-limits`.
- **jev** — decide when and how to integrate TypeSafe's Jev decision model: fit test,
  access paths (TypeSafe, OpenRouter, Vercel AI SDK/Gateway, Cloudflare), framework
  choice, harness patterns (tool-call gates, routers, triage), calibration and ops.
  Pairs with TypeSafe's official `typesafe-ai/skills`.
  Source: `https://github.com/KHAEntertainment/jev-skill`.

## Install

```sh
claude plugin marketplace add KHAEntertainment/marketplace
claude plugin install view-limits@kha-marketplace
claude plugin install jev@kha-marketplace
```

Or, inside a Claude Code session:

```
/plugin marketplace add KHAEntertainment/marketplace
/plugin install view-limits@kha-marketplace
/plugin install jev@kha-marketplace
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
