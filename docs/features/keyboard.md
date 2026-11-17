# The keyboard

The extension (`apps/ios/Sources/Keyboard`) hosts `KeyboardView` from MontessoriUI over the text document proxy.

- **Settings** come from the App Group (`SettingsStore`). The keyboard reloads them every time it appears, so a change in the app shows the next time the keyboard opens.
- **Layers:** letters, and 123 (digits with beads, rods or plain marks, then punctuation). Tapping a digit says its number word when sounds are on.
- **Shift** only works when Capitals with shift is on; otherwise it's dimmed. It turns off after one letter.
- **Delete** repeats when held: first after 450ms, then every 90ms.
- **Phonograms:** holding a tile for 420ms opens its letter teams (sh, ch, th, ai, igh…) in a popup above it (over the strip for the top row). Slide onto a team and let go to type it, or lift and tap one. Typing any key closes the popup.
- **Strip:** Rhymes swaps the last word for a rhyme from the same word family (`WordFamilies.swift`), keeping its capital and spaces. Word mat shows the last word as tiles; tap one, then a letter tile, to replace it. Quiet hides the strip.
- **Sound:** letter sounds use the system voice with IPA, so "b" says /b/ rather than "bee". Sound and clicks need Allow Full Access; without it the keyboard is silent but otherwise the same. With Full Access it records `fullAccessSeen` so the app can show the status.
- **Dark mode:** walnut when the app asks for a dark keyboard or the system is dark.
- **Privacy:** no network access and no storage of what's typed.
