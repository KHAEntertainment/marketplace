# kha-marketplace

KHA Entertainment's Claude Code plugin marketplace.

## Plugins

- **view-limits** — check coding-plan credit / rate-limit status across providers
  (MiniMax, Kimi, GLM, DeepSeek, OpenRouter) before dispatching sub-agents.
  Source: `https://github.com/KHAEntertainment/view-limits`.

## Install

```sh
claude plugin marketplace add KHAEntertainment/kha-marketplace
claude plugin install view-limits@kha-marketplace
```

Or, inside a Claude Code session:

```
/plugin marketplace add KHAEntertainment/kha-marketplace
/plugin install view-limits@kha-marketplace
```
