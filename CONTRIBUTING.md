# Contributing

Thanks for helping. Montessori Keyboard is small on purpose, so for anything bigger than a fix, open an issue first and say what you'd like to change and why. [AGENTS.md](AGENTS.md) has the rules the code follows, and [DESIGN.md](DESIGN.md) has the design decisions.

## Set up

```sh
mise install    # bun, tuist and ruby, pinned in mise.toml
bun install     # also turns on the commit-msg hook in .githooks
```

The iOS app needs macOS and Xcode 26. `bun run ios:generate` writes the workspace; never commit the generated `.xcodeproj` or `.xcworkspace`.

To run on your own iPhone, change `developmentTeam` and `bundleIdPrefix` at the top of `apps/ios/Project.swift` to your own team and a prefix you own, and keep that change out of your pull request. The simulator needs neither.

## Branches and pull requests

- Branch from `develop` and open pull requests against `develop`. `main` is for releases.
- Keep a pull request to one change, and say how you tested it.
- Docs move with the code: a change to a feature updates its page in [docs/features](docs/features).
- Pull requests from forks wait for a maintainer to approve their checks.

## Commit messages

[Conventional Commits](https://www.conventionalcommits.org), checked by `commitlint.config.ts` on every commit:

- `type(scope): subject`, 72 characters at most, starting with a lowercase letter and without a full stop.
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- Scopes: `ios`, `keyboard`, `app`, `kit`, `site`, `icons`, `docs`, `ci`, `deps`.
- A body is optional: 10 lines at most, 100 characters each.

```
fix(keyboard): keep delete in place when shift is hidden
feat(site): add the support email to the faq
```

Pull request titles follow the same rule.

## Checks

| | |
| --- | --- |
| Site | `bun run typecheck`, `bun run test`, `bun run build` |
| iOS (macOS) | `bun run ios:test` |

CI runs the same checks on every pull request.

## Security and privacy

The app and the keyboard make no network requests and collect nothing, and contributions have to keep it that way. To report a security problem, email [support@montessorikeyboard.com](mailto:support@montessorikeyboard.com) instead of opening a public issue.

## License

Contributions are under the [MIT License](LICENSE), the same as the rest of the project.
