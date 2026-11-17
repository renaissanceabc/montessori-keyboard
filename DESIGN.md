# Design

The full canvas (screens, keyboard states, light and dark) is the Montessori Keyboard design artifact. This file keeps the decisions the code depends on.

## Tiles

- Letter tiles are 46pt tall, 7pt corners, on a ten-tile grid with 6pt gaps, 11pt between rows and 3pt at the sides. Every row uses the same tile width; the third row scales down to fit shift and delete.
- A tile is a gradient face on a darker edge 2pt below it. Pressed, the face drops 2pt onto the edge and lightens.
- Vowels are blue, consonants red, "y" included in red, as in the classroom box.
- ABC rows: `abcdefghi`, `jklmnopqr`, `stuvwxyz`. QWERTY as usual. Shift and delete are 1 tile wide in ABC and 1.45 in QWERTY.
- Bottom row: 123 (2.3), space (5), return (2.3), and a globe only when iOS asks for one.

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

Andika Bold for tiles and headings, Andika Regular for children's writing, Playwrite US Trad for cursive tiles (drawn at 0.78 of the print size so it fits). System font for app body copy.

## Strip

44pt above the tiles. Rhymes (default), Word mat (tap a letter, then a tile, to change it) or Quiet. It never autocorrects. The phonogram tray takes it over while a tile is held.

## Icon

Three maple tiles, a b c, on the tray, drawn by `scripts/icons.py`. The favicon is a single blue "a" tile.
