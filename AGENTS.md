# Montessori Keyboard

An iOS keyboard for young learners modelled on the Montessori moveable alphabet (`apps/ios`), and its website (`apps/site`). Open source, MIT. Start with [README.md](README.md), then [DESIGN.md](DESIGN.md) and [docs/](docs/).

## Layout

- `apps/ios/Sources/Core` (MontessoriCore): plain Swift with no UI. Layouts, letter colors, phonograms, word families, number words, bead colors, settings and the App Group store. Unit tests live in `apps/ios/Tests/CoreTests` (Swift Testing).
- `apps/ios/Sources/UI` (MontessoriUI): the SwiftUI keyboard, shared by the extension and the app's preview and Pad. `KeyboardModel` holds state; `KeyboardHost` is what it types into.
- `apps/ios/Sources/Keyboard`: the keyboard extension. A `UIInputViewController` hosting `KeyboardView`.
- `apps/ios/Sources/App`: the companion app (setup, Try it, Settings behind the grown-ups gate, Pad, guide, about).
- `apps/ios/Project.swift`: the Tuist project. Never commit the generated `.xcodeproj` or `.xcworkspace`.
- `apps/site`: static Next.js site, structured like Galley's site.

## Rules

- **The keyboard is simple.** It types; it doesn't grade, quiz or limit letters (the "learned letters only" mode was cut). Learning help is optional and quiet: bead colors on 123, phonograms on long press, the rhymes strip.
- **Nothing leaves the device.** No network requests, analytics or accounts in the app or the keyboard. A new request in the site goes in `apps/site/vercel.json`'s CSP and the privacy page.
- **Andika everywhere** (Allo was tried and rejected). Cursive is Playwrite US Trad. Maple is light mode, walnut is dark; colors live only in `Palette` (`Theme.swift`) and in the site's CSS tokens, and the bead colors in `Beads.swift` match `apps/site/lib/keyboard.ts`.
- **Keyboard art is drawn from parts** (tile face, edge, shadow), never a single image.
- **Bundle ids** come from `com.renaissance.montessorikeyboard` in `Project.swift`; the App Group is `group.com.renaissance.montessorikeyboard`.
- Swift 6 language mode, strict concurrency. Views and models are `@MainActor`; `MontessoriCore` stays nonisolated.
- Docs move with the code: a change to a feature updates its page in `docs/features/`.
- Commits and PR titles are Conventional Commits, lowercase, 72 characters max. Scopes are in `commitlint.config.ts`.

## Checks

- Site: `bun run typecheck`, `bun run test`, `bun run build`.
- iOS needs macOS: `bun run ios:test`. In a cloud session, push and read the `iOS` workflow instead.
