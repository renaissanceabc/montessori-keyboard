# Montessori Keyboard

A free, open-source iPhone and iPad keyboard for young learners, made by [Renaissance](https://renaissance.education). It looks and works like the Montessori moveable alphabet: big maple tiles, blue vowels, red consonants, in ABC order or QWERTY.

## What's here

| Path | What it is |
| --- | --- |
| `apps/ios` | The keyboard extension and its companion app, in Swift and SwiftUI, generated with Tuist |
| `apps/site` | The website, a static Next.js export |
| `scripts/icons.py` | Draws the app icon and the site's favicons from code |
| `docs/` | How each feature works |

## Getting started

```sh
mise install            # bun and tuist, pinned in mise.toml
bun install
bun run ios:generate    # writes apps/ios/MontessoriKeyboard.xcworkspace
open apps/ios/MontessoriKeyboard.xcworkspace
bun run dev:site        # the website on localhost:3000
```

| | |
| --- | --- |
| iOS build and tests (macOS) | `bun run ios:build`, `bun run ios:test` |
| Site typecheck, tests, build | `bun run typecheck`, `bun run test`, `bun run build` |
| Icons | `bun run icons` (needs Pillow) |

## Privacy

The keyboard collects nothing and sends nothing. Allow Full Access is optional; it only lets the keyboard play letter sounds and key clicks. There are no accounts, ads or analytics in the app.

## License

MIT. The bundled fonts, Andika and Playwrite US Trad, are under the SIL Open Font License (`apps/ios/Sources/Shared/Fonts`).
