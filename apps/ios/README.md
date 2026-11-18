# Montessori Keyboard for iOS

You need Xcode 26 and the tools from `mise install` at the repo root. Run `bun run ios:generate` from the repo root, then open `MontessoriKeyboard.xcworkspace`. Never commit the generated `.xcodeproj` or `.xcworkspace`.

| Target | Product |
| --- | --- |
| MontessoriKeyboard | The companion app, `com.renaissance.montessorikeyboard` |
| Keyboard | The keyboard extension, `com.renaissance.montessorikeyboard.keyboard` |
| MontessoriCore | Static framework, no UI |
| MontessoriUI | Static framework, the SwiftUI keyboard |
| CoreTests | Swift Testing unit tests for MontessoriCore |

The app and the keyboard share settings through the App Group `group.com.renaissance.montessorikeyboard`. To try the keyboard in the simulator, run the app, then add it in Settings, General, Keyboard, Keyboards.

Debug builds can open straight to one screen with a launch argument, such as `-screen settings`. The screens are listed in `Sources/App/DebugScreens.swift`.

## On your own device

Signing uses Renaissance's Apple team (`developmentTeam` in `Project.swift`). To run on your own iPhone or iPad, set `developmentTeam` to your team id and change the bundle ids and App Group to ones your team can register, then generate again. Don't commit those changes.

## TestFlight

For maintainers. The `TestFlight` workflow archives the app and the keyboard, signs them with [match](https://docs.fastlane.tools/actions/match/), and uploads the build. It's manual: run it from the Actions tab, or `gh workflow run testflight.yml --ref develop`. Internal testers get the build once Apple finishes processing it, usually 5 to 15 minutes later. Each build number is the UTC time of the run (`202611171430`); the version is `marketingVersion` in `Project.swift`.

The lanes are in `fastlane/Fastfile`. `mise install` installs the Ruby they run on (the same as CI's), and `bundle install` here installs fastlane into `vendor/bundle`, never a system Ruby folder. Locally, `bundle exec fastlane release` does the same as the workflow, signed with your own keychain.

### One-time setup

1. In the [developer portal](https://developer.apple.com/account/resources/identifiers/list), register the App Group `group.com.renaissance.montessorikeyboard`, then the App IDs `com.renaissance.montessorikeyboard` and `com.renaissance.montessorikeyboard.keyboard`, each with App Groups on and that group selected. fastlane can't do this step: Apple's API can't assign an App Group, and signing in with an Apple ID fails for federated and passkey accounts.
2. In [App Store Connect](https://appstoreconnect.apple.com/apps), add a new iOS app: name Montessori Keyboard, bundle id `com.renaissance.montessorikeyboard`, SKU `montessorikeyboard`.
3. On a Mac, export the secrets below (`APP_STORE_CONNECT_API_KEY_PATH` can point at the `.p8` file in place of the base64), then run `bundle exec fastlane setup` here. It makes the App Store profiles in the match repo, signing in with the App Store Connect API key, never an Apple ID. Renaissance's maintainers can run `mise run ios:setup` from the repo root instead, which reads the secrets from Infisical (it needs `infisical login` and `INFISICAL_PROJECT_ID`).
4. CI reads the same secrets as GitHub Actions secrets:

| Secret | What it is |
| --- | --- |
| `MATCH_PASSWORD` | The match repo's passphrase |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Base64 of `user:token` for a token that can read the match repo |
| `APP_STORE_CONNECT_API_KEY_ID` | The App Store Connect API key's id |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Its issuer id |
| `APP_STORE_CONNECT_API_KEY_BASE64` | Base64 of the `.p8` key file |

The match repo is set in `fastlane/Matchfile`. Set `MATCH_GIT_URL` to use another.
