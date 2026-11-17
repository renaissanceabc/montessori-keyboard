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

## TestFlight

The `TestFlight` workflow archives the app and the keyboard, signs them with [match](https://docs.fastlane.tools/actions/match/), and uploads the build. It's manual: run it from the Actions tab, or `gh workflow run testflight.yml --ref develop`. Internal testers get the build once Apple finishes processing it, usually 5 to 15 minutes later. Each build number is the UTC time of the run (`202611171430`); the version is `marketingVersion` in `Project.swift`.

The lanes are in `fastlane/Fastfile`. `mise install` at the repo root installs the Ruby they run on (the same as CI's), and `bundle install` here installs fastlane into `vendor/bundle` (`.bundle/config`), never a system Ruby folder. Locally, `bundle exec fastlane release` does the same as the workflow, signed with your own keychain.

### One-time setup

1. In the [developer portal](https://developer.apple.com/account/resources/identifiers/list), register the App Group `group.com.renaissance.montessorikeyboard`, then the App IDs `com.renaissance.montessorikeyboard` and `com.renaissance.montessorikeyboard.keyboard`, each with App Groups on and that group selected. fastlane can't do this step: Apple's API can't assign an App Group, and signing in with an Apple ID fails for federated and passkey accounts.
2. In [App Store Connect](https://appstoreconnect.apple.com/apps), add a new iOS app: name Montessori Keyboard, bundle id `com.renaissance.montessorikeyboard`, SKU `montessorikeyboard`.
3. On a Mac, from the repo root, run `mise run ios:setup` (after `infisical login`). It installs fastlane and makes the App Store profiles in the match repo. It signs in with the App Store Connect API key, never an Apple ID, and reads the secrets below from Infisical's `_Global` project (`/apple`, prod). Without Infisical, export the three `APP_STORE_CONNECT_*` variables and `MATCH_PASSWORD` yourself, then run `bundle exec fastlane setup` in `apps/ios`. `APP_STORE_CONNECT_API_KEY_PATH` can point at the `.p8` file in place of the base64.

4. The five secrets below are **renaissanceabc organization secrets** for CI, and live in Infisical's `_Global` project (`/apple`) for Macs. Every Renaissance app shares them, because the match repo and the App Store Connect key are shared. A new app only needs to be added to each secret's repository access (Organization settings, Secrets and variables, Actions). The workflow reads them as `secrets.*`, the same as repository secrets:

| Secret | What it is |
| --- | --- |
| `MATCH_PASSWORD` | The match repo's passphrase |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Base64 of `user:token` for a token that can read the match repo |
| `APP_STORE_CONNECT_API_KEY_ID` | The App Store Connect API key's id |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Its issuer id |
| `APP_STORE_CONNECT_API_KEY_BASE64` | Base64 of the `.p8` key file |

The match repo is Renaissance's shared one, `renaissanceabc/apple-certificates`, because Apple allows a team only a few distribution certificates and every app uses the same one. Set `MATCH_GIT_URL` to use another.
