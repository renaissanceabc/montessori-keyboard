# The keyboard

The extension (`apps/ios/Sources/Keyboard`) hosts `KeyboardView` from MontessoriUI over the text document proxy.

- **Settings** come from the App Group (`SettingsStore`). The keyboard reloads them every time it appears, so a change in the app shows the next time the keyboard opens.
- **Layers:** letters, and 123 (digits with beads, rods or plain marks, then punctuation). Tapping a digit says its number word when sounds are on.
- **Shift** is there only when Capitals with shift is on; otherwise its tile is gone and the tray shows through, so the other keys keep their places. It turns off after one letter.
- **Delete** repeats when held: first after 450ms, then every 90ms.
- **Lift:** while a letter tile is down, a larger copy lifts above it so small hands can see what they hit.
- **Phonograms:** holding a tile for 400ms opens a popup over it with the letter and its teams (sh, ch, th, ai, igh…), like Apple's accent picker. Slide to one and lift to type it. Lifting far from the popup leaves it open so a team can be tapped; any other key closes it. Over the top row the popup stops at the keyboard's top edge, because a keyboard can't draw above its frame. VoiceOver offers the teams as actions on each tile.
- **Strip:** Rhymes offers three rhymes from the last word's family (`WordFamilies.swift`) in three equal slots, like the system suggestion bar, with no family label; tapping one swaps the last word for it, keeping its capital and spaces. With no rhymes the strip is blank: it has no helper text. Word mat shows the last word as tiles (blank before anything is typed); tap one, then a letter tile, to replace it. Quiet hides the strip.
- **Sound:** letter sounds use the system voice with IPA, so "b" says /b/ rather than "bee". Sound and clicks need Allow Full Access; without it the keyboard is silent but otherwise the same. With Full Access it records `fullAccessSeen` so the app can show the status.
- **Look:** drawn from parts (face, edge, shadow), as `DESIGN.md` describes. A pressed tile sinks onto its edge at once and rises over 80ms, keeping its color; only shift, when on, lights up (and stays raised). Shift, delete and return are drawn strokes, not SF Symbols, and the space bar is blank. Rhymes are words in tile colors with a thin line between slots, and a paper patch behind the one pressed. Word mat letters are flat paper on a 1pt edge in maple and small tiles in walnut; the chosen one gets a blue ring.
- **Dark mode:** walnut when the app asks for a dark keyboard or the system is dark.
- **Privacy:** no network access and no storage of what's typed.
