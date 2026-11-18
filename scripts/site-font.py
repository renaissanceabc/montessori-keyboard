"""Trims Allo to what the website uses, so the site's one preloaded font is a fraction of the full file.

The site draws every page in Allo's variable font (Friendly roundness). The full file covers many languages and
weights the site never shows. This keeps Basic Latin, Latin-1 and the punctuation, arrows and key symbols the pages
use; optical size and the weights from 400 to 800; and the OpenType features the site turns on (the learner forms,
tabular figures and capitals spacing). The text looks exactly as it did; only what's unused goes.

Run with `bun run site-font` after `bun install` (fontTools and brotli: pip install fonttools brotli). It reads
allo-font from apps/site/node_modules and writes apps/site/fonts/allo-site.woff2. It fails if a page uses a
character the trimmed font doesn't have, so run it again when a page gains new symbols.
"""

import sys
from pathlib import Path

from fontTools import subset
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer

ROOT = Path(__file__).resolve().parent.parent
SITE = ROOT / "apps/site"
SOURCE = SITE / "node_modules/allo-font/fonts/webfonts/AlloVariableFriendly.woff2"
OUT = SITE / "fonts/allo-site.woff2"

# Basic Latin, Latin-1, and the typographic punctuation, arrows and key symbols the site draws.
UNICODES = [
    *range(0x20, 0x7F),
    *range(0xA0, 0x100),
    *(0x2013, 0x2014, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022, 0x2026, 0x2039, 0x203A),
    *(0x2190, 0x2191, 0x2192, 0x2193, 0x2197, 0x21B5, 0x21E5, 0x21E7),
    *(0x2303, 0x2318, 0x2325, 0x232B),
]

# The weights the site's CSS uses (body 400 to the heaviest heading, 800). Lighter and heavier masters go.
WEIGHTS = (400, 800)

# On top of fontTools' defaults (kerning, ligatures, marks and the like).
FEATURES = ["ss01", "cv03", "cv04", "tnum", "case"]


def used_characters() -> set[str]:
    """Every character outside ASCII in the site's pages, components and styles."""
    chars: set[str] = set()
    for path in SITE.rglob("*"):
        if {"node_modules", ".next", "out"} & set(path.parts):
            continue
        if path.suffix in {".ts", ".tsx", ".css", ".md"}:
            chars.update(ch for ch in path.read_text(encoding="utf-8") if ord(ch) > 0x7E)
    return chars


def main() -> None:
    missing = sorted(ch for ch in used_characters() if ord(ch) not in UNICODES)
    if missing:
        sys.exit("Add these to UNICODES in scripts/site-font.py: " + " ".join(f"{ch} U+{ord(ch):04X}" for ch in missing))

    options = subset.Options()
    options.flavor = "woff2"
    options.layout_features = [*options.layout_features, *FEATURES]
    options.name_IDs = ["*"]
    options.notdef_outline = True

    font = TTFont(SOURCE)
    subsetter = subset.Subsetter(options)
    subsetter.populate(unicodes=UNICODES)
    subsetter.subset(font)
    font = instancer.instantiateVariableFont(font, {"wght": WEIGHTS})
    OUT.parent.mkdir(exist_ok=True)
    font.flavor = "woff2"
    font.save(OUT)
    print(f"{OUT.relative_to(ROOT)}: {SOURCE.stat().st_size // 1024} KB to {OUT.stat().st_size // 1024} KB")


if __name__ == "__main__":
    main()
