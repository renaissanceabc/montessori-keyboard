"""Draws the app icon and the site's favicons from code: a b c tiles stacked as a triangle, a on top.

Run with `bun run icons` (Pillow required). It writes:
  apps/ios/Sources/App/Assets.xcassets/AppIcon.appiconset/icon-1024.png         (maple, light)
  apps/ios/Sources/App/Assets.xcassets/AppIcon.appiconset/icon-1024-dark.png    (walnut, dark)
  apps/ios/Sources/App/Assets.xcassets/AppIcon.appiconset/icon-1024-tinted.png  (grayscale, tinted)
  apps/site/app/icon.png, apps/site/app/apple-icon.png, apps/site/app/favicon.ico
"""

from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
FONT = ROOT / "apps/ios/Sources/Shared/Fonts/AlloLearner-Bold.otf"
# Allo Learner has the learner forms baked in (scripts/learner-fonts.py), so no OpenType features are needed.

S = 4  # supersampling
EDGE = 0.04  # the tile's darker edge below its face, as a share of its height

Rgb = tuple[int, int, int]


@dataclass(frozen=True)
class Look:
    """The icon's colors. Maple and walnut match `Palette` in Theme.swift."""

    tray_top: Rgb
    tray_bottom: Rgb
    tile_top: Rgb
    tile_bottom: Rgb
    tile_edge: Rgb
    vowel: Rgb
    consonant: Rgb
    shadow: tuple[int, int, int, int]


MAPLE = Look(
    tray_top=(0xF1, 0xE4, 0xCC),
    tray_bottom=(0xE2, 0xCF, 0xAE),
    tile_top=(0xF8, 0xE7, 0xC9),
    tile_bottom=(0xF0, 0xD8, 0xB0),
    tile_edge=(0xCD, 0xAA, 0x78),
    vowel=(0x16, 0x50, 0xB0),
    consonant=(0xB3, 0x14, 0x1A),
    shadow=(84, 52, 18, 90),
)

WALNUT = Look(
    tray_top=(0x33, 0x24, 0x1A),
    tray_bottom=(0x22, 0x17, 0x10),
    tile_top=(0x6E, 0x4C, 0x34),
    tile_bottom=(0x5C, 0x3F, 0x2B),
    tile_edge=(0x36, 0x24, 0x1A),
    vowel=(0x86, 0xBE, 0xFF),
    consonant=(0xFF, 0x7A, 0x6B),
    shadow=(0, 0, 0, 140),
)

# iOS tints this one from its luminance, so it is gray on black: light tiles, dark letters.
TINTED = Look(
    tray_top=(0, 0, 0),
    tray_bottom=(0, 0, 0),
    tile_top=(0xF2, 0xF2, 0xF2),
    tile_bottom=(0xD6, 0xD6, 0xD6),
    tile_edge=(0x80, 0x80, 0x80),
    vowel=(0x26, 0x26, 0x26),
    consonant=(0x26, 0x26, 0x26),
    shadow=(0, 0, 0, 0),
)


def gradient(size, top, bottom):
    w, h = size
    img = Image.new("RGB", size)
    draw = ImageDraw.Draw(img)
    for y in range(h):
        t = y / max(h - 1, 1)
        draw.line([(0, y), (w, y)], fill=tuple(round(a + (b - a) * t) for a, b in zip(top, bottom)))
    return img


def tile(letter, w, h, color, look, shadow=True):
    """One tile with its darker edge and soft shadow, on a transparent canvas with room for both."""
    pad = int(w * 0.35)
    r = int(w * 0.17)
    edge = int(h * EDGE)
    canvas = Image.new("RGBA", (w + pad * 2, h + pad * 2), (0, 0, 0, 0))

    if shadow and look.shadow[3]:
        layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
        ImageDraw.Draw(layer).rounded_rectangle(
            [pad, pad + edge * 2, pad + w, pad + h + edge * 2], r, fill=look.shadow
        )
        canvas.alpha_composite(layer.filter(ImageFilter.GaussianBlur(w * 0.07)))

    ImageDraw.Draw(canvas).rounded_rectangle([pad, pad + edge, pad + w, pad + h + edge], r, fill=look.tile_edge)

    face = gradient((w, h), look.tile_top, look.tile_bottom).convert("RGBA")
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, w - 1, h - 1], r, fill=255)
    canvas.paste(face, (pad, pad), mask)

    font = ImageFont.truetype(str(FONT), int(h * 0.7))
    draw = ImageDraw.Draw(canvas)
    box = draw.textbbox((0, 0), letter, font=font, anchor="ls")
    x = pad + (w - (box[2] - box[0])) / 2 - box[0]
    # Every tile shares one baseline, like the moveable alphabet. The baseline sits so that an ascender
    # letter (b) and an x-height letter (a, c) both look centered: halfway between centering each.
    xh = font.getbbox("x", anchor="ls")[1]
    asc = font.getbbox("b", anchor="ls")[1]
    y = pad + h / 2 - (xh + asc) / 4
    draw.text((x, y), letter, font=font, fill=color, anchor="ls")
    return canvas


def triangle(img, look, tile_w, tile_h, gap, shadow=True):
    """a on top, b and c below it, centered on the image as one group."""
    n = img.width
    edge = int(tile_h * EDGE)
    group_h = 2 * tile_h + gap + edge
    top = (n - group_h) // 2
    rows = [
        (("a", look.vowel, n // 2),),
        (("b", look.consonant, n // 2 - (tile_w + gap) // 2), ("c", look.consonant, n // 2 + (tile_w + gap) // 2)),
    ]
    for row, specs in enumerate(rows):
        cy = top + row * (tile_h + gap) + tile_h // 2
        for letter, color, cx in specs:
            t = tile(letter, tile_w, tile_h, color, look, shadow)
            img.alpha_composite(t, (cx - t.width // 2, cy - t.height // 2))


def icon(size, look=MAPLE):
    """The app icon: the triangle on the tray, with room around it for the icon mask."""
    n = size * S
    img = gradient((n, n), look.tray_top, look.tray_bottom).convert("RGBA")
    triangle(img, look, int(n * 0.32), int(n * 0.32), int(n * 0.035))
    return img.resize((size, size), Image.LANCZOS).convert("RGB")


def favicon(size):
    """The tab icon: the same triangle filling a transparent square, so it stays legible at 16-48px."""
    n = size * S
    img = Image.new("RGBA", (n, n), (0, 0, 0, 0))
    triangle(img, MAPLE, int(n * 0.47), int(n * 0.46), int(n * 0.04), shadow=False)
    return img.resize((size, size), Image.LANCZOS)


def main():
    appicon = ROOT / "apps/ios/Sources/App/Assets.xcassets/AppIcon.appiconset"
    appicon.mkdir(parents=True, exist_ok=True)
    icon(1024).save(appicon / "icon-1024.png")
    icon(1024, WALNUT).save(appicon / "icon-1024-dark.png")
    icon(1024, TINTED).convert("L").save(appicon / "icon-1024-tinted.png")

    site = ROOT / "apps/site/app"
    site.mkdir(parents=True, exist_ok=True)
    icon(512).save(site / "icon.png")
    icon(180).save(site / "apple-icon.png")
    # Each size is drawn on its own, not scaled down from one big image.
    sizes = [16, 32, 48, 64]
    frames = [favicon(s) for s in sizes]
    frames[-1].save(site / "favicon.ico", sizes=[(s, s) for s in sizes], append_images=frames[:-1])
    print("icons written")


if __name__ == "__main__":
    main()
