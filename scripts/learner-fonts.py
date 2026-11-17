"""Bakes Allo's learner forms into its font files, so every app draws them without OpenType features.

Allo's single-storey a (ss01), tailed l (cv03) and serifed I (cv04) are single substitutions in GSUB. This points
the cmap at the substituted glyphs and renames the family "Allo Learner", as the SIL Open Font License asks of a
modified font. Then iOS can use `Font.custom(_:size:relativeTo:)`, which scales live with Dynamic Type.

Usage: python3 scripts/learner-fonts.py <upstream Allo .otf files> --out apps/ios/Sources/Shared/Fonts
Needs fontTools (pip install fonttools).
"""

import argparse
from pathlib import Path

from fontTools.ttLib import TTFont

FEATURES = ("ss01", "cv03", "cv04")
FAMILY = "Allo Learner"


def substitutions(font: TTFont) -> dict[str, str]:
    """Every single substitution the learner features make, glyph to glyph."""
    gsub = font["GSUB"].table
    lookups: set[int] = set()
    for record in gsub.FeatureList.FeatureRecord:
        if record.FeatureTag in FEATURES:
            lookups.update(record.Feature.LookupListIndex)
    mapping: dict[str, str] = {}
    for index in sorted(lookups):
        lookup = gsub.LookupList.Lookup[index]
        for sub in lookup.SubTable:
            if lookup.LookupType == 7:  # extension
                sub = sub.ExtSubTable
            if getattr(sub, "mapping", None):
                mapping.update(sub.mapping)
    return mapping


def bake(path: Path, out: Path) -> None:
    font = TTFont(path)
    mapping = substitutions(font)
    if not mapping:
        raise SystemExit(f"{path.name}: no learner substitutions found")
    for table in font["cmap"].tables:
        for code, glyph in list(table.cmap.items()):
            if glyph in mapping:
                table.cmap[code] = mapping[glyph]

    names = font["name"]
    style = (names.getDebugName(6) or "Allo-Regular").split("-")[-1]
    postscript = f"{FAMILY.replace(' ', '')}-{style}"
    # Regular and Bold share the family name; Medium and SemiBold are their own families, as in upstream Allo.
    family = FAMILY if style in ("Regular", "Bold") else f"{FAMILY} {style}"
    for record in list(names.names):
        if record.nameID == 1:
            names.setName(family, 1, record.platformID, record.platEncID, record.langID)
        elif record.nameID == 16:
            names.setName(FAMILY, 16, record.platformID, record.platEncID, record.langID)
        elif record.nameID == 4:
            names.setName(f"{FAMILY} {style}", 4, record.platformID, record.platEncID, record.langID)
        elif record.nameID == 6:
            names.setName(postscript, 6, record.platformID, record.platEncID, record.langID)
        elif record.nameID == 3:
            names.setName(f"{postscript};learner", 3, record.platformID, record.platEncID, record.langID)
    if "CFF " in font:
        cff = font["CFF "].cff
        cff.fontNames = [postscript]
        top = cff.topDictIndex[0]
        top.FamilyName = FAMILY
        top.FullName = f"{FAMILY} {style}"

    target = out / f"{postscript}.otf"
    font.save(target)
    print(f"{path.name} -> {target.name}: {len(mapping)} glyphs swapped")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("fonts", nargs="+", type=Path)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)
    for path in args.fonts:
        bake(path, args.out)


if __name__ == "__main__":
    main()
