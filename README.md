# Montessori Keyboard

A free, open-source iPhone and iPad keyboard for young learners, made by [Renaissance](https://renaissance.education). It looks and works like the Montessori moveable alphabet: big maple tiles, blue vowels, red consonants, in ABC order or QWERTY.

## What's here

| Path | What it is |
| --- | --- |
| `apps/ios` | The keyboard extension and its companion app, in Swift and SwiftUI, generated with Tuist |
| `apps/site` | The website, a static Next.js export |
| `scripts/icons.py` | Draws the app icon and the site's favicons from code |
| `docs/` | How each feature works |
| [DESIGN.md](DESIGN.md) | Tile sizes, colors, type and the strip |
| [AGENTS.md](AGENTS.md) | The rules the code follows |

## Getting started

```sh
mise install            # bun, tuist and ruby, pinned in mise.toml
bun install
bun run ios:generate    # writes apps/ios/MontessoriKeyboard.xcworkspace
open apps/ios/MontessoriKeyboard.xcworkspace
bun run dev:site        # the website on localhost:3020
```

The iOS app needs macOS and Xcode 26. To try the keyboard in the simulator, run the app, then add the keyboard in Settings, General, Keyboard, Keyboards. More in [apps/ios/README.md](apps/ios/README.md) and [apps/site/README.md](apps/site/README.md).

| | |
| --- | --- |
| iOS build and tests (macOS) | `bun run ios:build`, `bun run ios:test` |
| Site typecheck, tests, build | `bun run typecheck`, `bun run test`, `bun run build` |
| Icons | `bun run icons` (needs Pillow) |

## Privacy

The keyboard collects nothing and sends nothing. Allow Full Access is optional; it only lets the keyboard play letter sounds and key clicks. There are no accounts, ads or analytics in the app.

## Contributing

Issues and pull requests are welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) first: branches, commit messages and checks. Report security problems to [support@montessorikeyboard.com](mailto:support@montessorikeyboard.com), not in a public issue.

## License

[MIT](LICENSE). The bundled fonts are under the SIL Open Font License, with their license files in `apps/ios/Sources/Shared/Fonts`: [Allo](https://joshpuckett.me) by Josh Puckett, and [Playwrite US Trad](https://github.com/TypeTogether/Playwrite) by TypeTogether.
