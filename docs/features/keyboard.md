# The keyboard

The extension (`apps/ios/Sources/Keyboard`) hosts `KeyboardView` from MontessoriUI over the text document proxy.

- **Settings** come from the App Group (`SettingsStore`). The keyboard reloads them every time it appears, so a change in the app shows the next time the keyboard opens.
- **Layers:** letters, and 123 (digits with beads, rods or plain marks, then punctuation). Tapping a digit says its number word when sounds are on.
- **Shift** only works when Capitals with shift is on; otherwise it's dimmed. It turns off after one letter.
- **Delete** repeats when held: first after 450ms, then every 90ms.
- **Lift:** while a letter tile is down, a larger copy lifts above it so small hands can see what they hit.
- **Phonograms:** holding a tile for 400ms opens a popup over it with the letter and its teams (sh, ch, th, ai, igh…), like Apple's accent picker. Slide to one and lift to type it. Lifting far from the popup leaves it open so a team can be tapped; any other key closes it. Over the top row the popup stops at the keyboard's top edge, because a keyboard can't draw above its frame. VoiceOver offers the teams as actions on each tile.
- **Strip:** Rhymes swaps the last word for a rhyme from the same word family (`WordFamilies.swift`), keeping its capital and spaces. Word mat shows the last word as tiles; tap one, then a letter tile, to replace it. Quiet hides the strip.
- **Sound:** letter sounds use the system voice with IPA, so "b" says /b/ rather than "bee". Sound and clicks need Allow Full Access; without it the keyboard is silent but otherwise the same. With Full Access it records `fullAccessSeen` so the app can show the status.
- **Dark mode:** walnut when the app asks for a dark keyboard or the system is dark.
- **Privacy:** no network access and no storage of what's typed.
