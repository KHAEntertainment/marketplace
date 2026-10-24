# Agent guide: kha-marketplace

`CLAUDE.md` imports this file, so Claude Code and other agents read the same instructions.

`.claude-plugin/marketplace.json` is the catalog: each entry's `source.ref` pins a plugin to a release tag. `README.md` is the user-facing list of plugins.

## Every pin bump also updates the README

When you bump a plugin's `source.ref`, or add or remove a plugin, update that plugin's entry in `README.md` in the same PR. Follow "Updating a plugin" in the README's "For maintainers" section:

- Check the entry against the source repo's README at the new tag: summary line, what it does, install command, "After install" line.
- Keep the format: one collapsed `<details>` entry per plugin, under its category.
- Never put a current or pinned version in the README. `marketplace.json` is the only place pins live. An upgrade note may name the version a migration starts from (for example enigma's "Upgrading from before 0.3.0?").

## Checks

- `claude plugin validate .` checks the manifest's shape only.
- `verify-catalog` (`.github/workflows/verify-catalog.yml`) resolves every pin anonymously on pull requests that touch `marketplace.json`, and weekly. It does not read the README, so keeping the README current is on the PR author.
