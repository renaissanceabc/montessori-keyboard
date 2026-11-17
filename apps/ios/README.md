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

The lanes are in `fastlane/Fastfile`, and `bundle install` here installs fastlane. Locally, `bundle exec fastlane release` does the same as the workflow, signed with your own keychain.

### One-time setup

1. On a Mac signed in to the Renaissance developer account, run `APPLE_ID=<your Apple ID> bundle exec fastlane setup` in `apps/ios`. It registers `com.renaissance.montessorikeyboard` and `.keyboard` with the App Group `group.com.renaissance.montessorikeyboard`, creates the App Store Connect app, and adds App Store profiles for both ids to the match repo.
2. Add these repository secrets. Flourish's values work for all five, since the match repo and the App Store Connect key are shared:

| Secret | What it is |
| --- | --- |
| `MATCH_PASSWORD` | The match repo's passphrase |
| `MATCH_GIT_BASIC_AUTHORIZATION` | Base64 of `user:token` for a token that can read the match repo |
| `APP_STORE_CONNECT_API_KEY_ID` | The App Store Connect API key's id |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Its issuer id |
| `APP_STORE_CONNECT_API_KEY_BASE64` | Base64 of the `.p8` key file |

The match repo is Flourish's, `renaissanceabc/flourish-certificates`, because Apple allows a team only a few distribution certificates and the apps share one. Set `MATCH_GIT_URL` to use another.
