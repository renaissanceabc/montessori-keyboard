# Montessori Keyboard for iOS

Needs Xcode 26 and Tuist (`mise install` at the repo root). Run `bun run ios:generate` from the repo root, then open `MontessoriKeyboard.xcworkspace`.

| Target | Product |
| --- | --- |
| MontessoriKeyboard | The companion app, `com.renaissance.montessorikeyboard` |
| Keyboard | The keyboard extension, `com.renaissance.montessorikeyboard.keyboard` |
| MontessoriCore | Static framework, no UI |
| MontessoriUI | Static framework, the SwiftUI keyboard |
| CoreTests | Swift Testing unit tests for MontessoriCore |

Both the app and the keyboard need the App Group `group.com.renaissance.montessorikeyboard` on team 6P8L9SND3U. To try the keyboard in the simulator, run the app, then add it in Settings, General, Keyboard, Keyboards.
