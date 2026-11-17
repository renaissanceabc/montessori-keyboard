"""Draws the app icon and the site's favicons from code: three maple tiles, a b c, on the tray.

Run with `bun run icons` (Pillow required). It writes:
  apps/ios/Sources/App/Assets.xcassets/AppIcon.appiconset/icon-1024.png
  apps/site/app/icon.png, apps/site/app/apple-icon.png, apps/site/app/favicon.ico
"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
FONT = ROOT / "apps/ios/Sources/Shared/Fonts/Allo-Bold.otf"
# Allo's learner forms, as the tiles draw them: single-storey a, tailed l, serifed I. Needs Pillow with raqm.
FEATURES = ["ss01", "cv03", "cv04"]

TRAY_TOP = (0xF1, 0xE4, 0xCC)
TRAY_BOTTOM = (0xE2, 0xCF, 0xAE)
TILE_TOP = (0xF8, 0xE7, 0xC9)
TILE_BOTTOM = (0xF0, 0xD8, 0xB0)
TILE_EDGE = (0xCD, 0xAA, 0x78)
VOWEL = (0x16, 0x50, 0xB0)
CONSONANT = (0xB3, 0x14, 0x1A)

S = 4  # supersampling


def gradient(size, top, bottom):
    w, h = size
    img = Image.new("RGB", size)
    draw = ImageDraw.Draw(img)
    for y in range(h):
        t = y / max(h - 1, 1)
        draw.line([(0, y), (w, y)], fill=tuple(round(a + (b - a) * t) for a, b in zip(top, bottom)))
    return img


def tile(letter, w, h, color):
    """One tile with its darker edge and soft shadow, on a transparent canvas with room for both."""
    pad = int(w * 0.35)
    r = int(w * 0.16)
    edge = int(h * 0.05)
    canvas = Image.new("RGBA", (w + pad * 2, h + pad * 2), (0, 0, 0, 0))

    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        [pad, pad + edge * 2, pad + w, pad + h + edge * 2], r, fill=(84, 52, 18, 90)
    )
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(w * 0.08)))

    ImageDraw.Draw(canvas).rounded_rectangle([pad, pad + edge, pad + w, pad + h + edge], r, fill=TILE_EDGE)

    face = gradient((w, h), TILE_TOP, TILE_BOTTOM).convert("RGBA")
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, w - 1, h - 1], r, fill=255)
    canvas.paste(face, (pad, pad), mask)

    font = ImageFont.truetype(str(FONT), int(h * 0.72))
    draw = ImageDraw.Draw(canvas)
    box = draw.textbbox((0, 0), letter, font=font, anchor="ls", features=FEATURES)
    x = pad + (w - (box[2] - box[0])) / 2 - box[0]
    # Center the x-height, not the ink box, so a b c sit on one baseline.
    xh = font.getbbox("x", anchor="ls")
    y = pad + h / 2 - (xh[1] + xh[3]) / 2 - h * 0.03
    draw.text((x, y), letter, font=font, fill=color, anchor="ls", features=FEATURES)
    return canvas


def icon(size, trio=True):
    n = size * S
    img = gradient((n, n), TRAY_TOP, TRAY_BOTTOM).convert("RGBA")
    if trio:
        w, h = int(n * 0.265), int(n * 0.32)
        specs = [("a", VOWEL, -5, 0.0), ("b", CONSONANT, 0, -0.045), ("c", CONSONANT, 4, 0.0)]
        gap = int(n * 0.03)
        total = 3 * w + 2 * gap
        x0 = (n - total) // 2
        for i, (letter, color, angle, dy) in enumerate(specs):
            t = tile(letter, w, h, color).rotate(angle, resample=Image.BICUBIC, expand=False)
            cx = x0 + i * (w + gap) + w // 2
            cy = n // 2 + int(n * dy) + int(n * 0.01)
            img.alpha_composite(t, (cx - t.width // 2, cy - t.height // 2))
    else:
        # Small sizes: one big "a" tile reads better than three.
        w, h = int(n * 0.62), int(n * 0.72)
        t = tile("a", w, h, VOWEL)
        img.alpha_composite(t, ((n - t.width) // 2, (n - t.height) // 2 - int(n * 0.02)))
    return img.resize((size, size), Image.LANCZOS).convert("RGB")


def main():
    appicon = ROOT / "apps/ios/Sources/App/Assets.xcassets/AppIcon.appiconset"
    appicon.mkdir(parents=True, exist_ok=True)
    icon(1024).save(appicon / "icon-1024.png")

    site = ROOT / "apps/site/app"
    site.mkdir(parents=True, exist_ok=True)
    icon(512).save(site / "icon.png")
    icon(180).save(site / "apple-icon.png")
    small = icon(64, trio=False).convert("RGBA")
    small.save(site / "favicon.ico", sizes=[(16, 16), (32, 32), (48, 48), (64, 64)])
    print("icons written")


if __name__ == "__main__":
    main()
