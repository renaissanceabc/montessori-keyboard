# Contributing

Thanks for helping. Montessori Keyboard is small on purpose, so start with the rules in [AGENTS.md](AGENTS.md#rules). They apply to people too. The short version: the keyboard only types, nothing leaves the device, and every color and size comes from [DESIGN.md](DESIGN.md).

## Branches and pull requests

- Branch from `develop` and open your pull request into `develop`. `main` is the release branch, and releases are tagged automatically.
- Keep a pull request to one change. If it changes what someone sees, add before and after screenshots.
- Docs move with the code. A change to how a feature works updates its page in [docs/features](docs/features) in the same pull request.

## Commit messages

Commits and pull request titles are [Conventional Commits](https://www.conventionalcommits.org): `type(scope): subject`, lowercase, imperative, 72 characters at most.

```
feat(keyboard): show phonograms in a popup above the held tile
fix(app): keep the settings title inline above the pinned tray
docs: explain the word mat
```

- **Types:** `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`, `perf`, `build`, `style`, `revert`.
- **Scopes:** `ios`, `keyboard`, `app`, `kit`, `site`, `icons`, `docs`, `ci`, `deps`. A scope is optional.
- A body is optional, and at most 10 short lines.

`bun install` turns on a commit-msg hook that checks this (`commitlint.config.ts`). Skip it once with `git commit --no-verify`.

## Checks

Run these before you push:

| | |
| --- | --- |
| Site | `bun run typecheck`, `bun run test`, `bun run build` |
| iOS (macOS) | `bun run ios:test` |

CI runs the site checks on every pull request, and builds and tests the iOS app on pull requests that touch `apps/ios`.
