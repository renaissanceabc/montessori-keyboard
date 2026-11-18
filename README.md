# Montessori Keyboard

An open-source keyboard for iPhone and iPad, for young learners. It looks and works like the Montessori moveable alphabet: wooden tiles in lowercase print, blue vowels and red consonants, in ABC order or QWERTY. Made by [Renaissance](https://renaissance.education).

[montessorikeyboard.com](https://montessorikeyboard.com) · Coming soon to the App Store for $1.99

## What it does

- **Types, simply.** No grading, quizzes or locked letters. Capitals only if a grown-up turns on shift.
- **Print or cursive** tiles, in Allo with its learner forms (single-storey a, tailed l) or Playwrite US Trad.
- **Phonograms:** hold a tile to type its letter teams, like sh, ch, ai and igh.
- **A strip above the tiles** that offers rhymes from the same word family, shows the last word as tiles to change one letter, or stays out of the way.
- **Bead colors on 123**, from the Montessori bead stair.
- **Maple in light mode, walnut in dark.**
- **A companion app** for grown-ups: setup, a live preview of every setting, and a blank pad to try it, behind a grown-ups gate.

## Price

The App Store download is $1.99, once, with no ads, subscriptions or in-app purchases. The source stays MIT, so anyone can build it from this repo for free.

## Privacy

The keyboard collects nothing and sends nothing. There are no accounts, ads or analytics, and the app makes no network requests. Allow Full Access is optional: it only lets the keyboard play letter sounds and key clicks.

## What's here

| Path            | What it is                                                                                               |
| --------------- | -------------------------------------------------------------------------------------------------------- |
| `apps/ios`      | The keyboard extension and its companion app, in Swift and SwiftUI, generated with Tuist                 |
| `apps/site`     | The website, a static Next.js export                                                                     |
| `scripts/`      | The app icon and favicons, drawn from code (`icons.py`), and the Allo Learner fonts (`learner-fonts.py`) |
| `docs/features` | How each part works                                                                                      |
| `DESIGN.md`     | The sizes, colors and type the code depends on                                                           |

## Getting started

You need [mise](https://mise.jdx.dev), and Xcode 26 on a Mac for the app.

```sh
mise install            # bun, tuist, swiftlint and ruby, pinned in mise.toml
bun install
bun run ios:generate    # writes apps/ios/MontessoriKeyboard.xcworkspace
open apps/ios/MontessoriKeyboard.xcworkspace
bun run dev:site        # the website on localhost:3020
```

|                              |                                                        |
| ---------------------------- | ------------------------------------------------------ |
| iOS build and tests (macOS)  | `bun run ios:build`, `bun run ios:test`                |
| Site typecheck, tests, build | `bun run typecheck`, `bun run test`, `bun run build`   |
| Lint, format                 | `bun run lint`, `bun run format`, `bun run lint:swift` |
| Icons                        | `bun run icons` (needs Pillow)                         |

To run the app on your own device, see [apps/ios/README.md](apps/ios/README.md).

## Contributing

Issues and pull requests are welcome. [CONTRIBUTING.md](CONTRIBUTING.md) covers branches, commit messages and checks. For help with the app, write to [support@montessorikeyboard.com](mailto:support@montessorikeyboard.com).

## License

[MIT](LICENSE). The bundled fonts, Allo and Playwrite US Trad, are under the SIL Open Font License (`apps/ios/Sources/Shared/Fonts`).
