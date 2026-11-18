# Design

The sizes, colors and type the code depends on. Change them here and in the code together: colors live in `Palette` (`apps/ios/Sources/UI/Theme.swift`) and the site's CSS tokens.

## Tiles

- Letter tiles are 46pt tall, 7pt corners, on a ten-tile grid with 6pt gaps, 11pt between rows and 3pt at the sides. Every row uses the same tile width; the third row scales down to fit shift and delete.
- A tile is a gradient face on a darker edge 2pt below it, over a soft shadow, all drawn from parts. Pressed, the face sinks 2pt onto the edge at once and rises over 80ms, keeping its color. Only shift, when on, gets the pale face, and it stays raised.
- Shift, delete and return are drawn strokes (1.8pt, round caps). The space bar is blank.
- Vowels are blue, consonants red, "y" included in red, as in the classroom box.
- ABC rows: `abcdefghi`, `jklmnopqr`, `stuvwxyz`. QWERTY as usual. Shift and delete are 1 tile wide in ABC and 1.45 in QWERTY. With capitals off, shift's slot stays empty, so nothing moves.
- Bottom row: 123 (2.3), space (5), return (2.3). When iOS asks for a globe: 123 (1.5), globe (1.2), space (4.6), return (2).

## Colors

| | Maple (light) | Walnut (dark) |
| --- | --- | --- |
| Tray | `#EADBC0` | `#2A1D15` |
| Tile face | `#F8E7C9` to `#F0D8B0` | `#6E4C34` to `#5C3F2B` |
| Tile edge | `#CDAA78` | `#36241A` |
| Vowel | `#1650B0` | `#86BEFF` |
| Consonant | `#B3141A` | `#FF7A6B` |

Bead stair: 1 red `#D2232A`, 2 green `#2E9B45`, 3 pink `#EE86AE`, 4 yellow `#F2C318`, 5 light blue `#6DBFE8`, 6 purple `#8E5BB5`, 7 white `#E9E2D2`, 8 brown `#8A5A2E`, 9 dark blue `#1E3A8A`, 10 gold `#C9A227`.

## Type

Allo everywhere: Bold for tiles and headings, Regular for children's writing, and Regular, Medium and SemiBold for app body copy (`TileFont.text`). Its learner forms are always on: single-storey a (ss01), tailed l (cv03) and serifed I (cv04). The iOS app bundles them baked in as Allo Learner (`scripts/learner-fonts.py`), so app text uses `Font.custom(_:size:relativeTo:)` and follows Dynamic Type, up to the third accessibility size. Keyboard tiles keep a fixed size, like Apple's keys. Playwrite US Trad for cursive tiles (drawn at 0.78 of the print size so it fits).

## Strip

44pt above the tiles. Rhymes (default), Word mat (tap a letter, then a tile, to change it) or Quiet. It never autocorrects. Holding a tile opens its phonograms in a popup over the tile instead, like Apple's accent picker; over the top row the popup stops at the keyboard's top edge, because a keyboard can't draw above its frame.

## Icon

Three tiles stacked as a triangle, a on top and b c below, drawn by `scripts/icons.py`. Maple on the tray is the light icon, walnut is the dark one, and a grayscale copy is the tinted one. The favicon is the same triangle filling a transparent square, drawn separately at each size.

## Settings preview

The app's Settings pins the live keyboard at the top. As the settings scroll, it settles over 120pt into a compact keyboard: full width, 36pt tiles and 7pt row gaps. Rows fade out below a 6pt band under it.
