# The companion app

`apps/ios/Sources/App`. A grown-up sets it up once; after that it's grown-ups only.

1. **Welcome**, then **Turn it on** (Open Settings goes to the app's page in iPhone Settings; the status line shows when the keyboard is on), then **Make it yours** (three questions: ABC or QWERTY order, print or cursive, and lowercase only or shift for capitals; each answer saves at once and Settings can change it later), then **Try it** (a real text box, to switch to the keyboard). Done goes straight to Settings.
2. **Grown-ups gate** on every later launch, and again whenever the app goes to the background: type a three-digit number spelled out in words (no zeros), or use Face ID, Touch ID or the passcode.
3. **Settings:** a native navigation bar on Settings and every page above it (large titles in Allo, the pen button in the bar), so pushing, popping and swiping back are Apple's own. The live keyboard pinned at the top (without the strip) so every change shows and sounds right away. As the settings scroll up under it, the tray settles into a compact keyboard over the first 120 points, following the finger: it keeps its full width while its tiles go from 46 to 36 points, its rows and padding tighten, and rows fade out as they slide under it. Order, letter shapes, capitals with shift, phonograms, Strip, Numbers, letter sounds, key clicks, the setup guide, and About. The pen button opens the **Pad**, a blank page with the full keyboard.

The setup pages and the gate sit on the lighter paper color; Settings and the pages above it on the page color. Settings rows, switches and segmented controls are drawn to match the design canvas (not the system ones), with sentence-case section headers; the back buttons and titles stay the system's.

Whether the keyboard is on comes from the system's list of keyboards; whether Full Access is on comes from the flag the keyboard writes when it runs with it.
