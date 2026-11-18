"""Draws the site's link previews: one 1200 x 630 card per page, a word in maple tiles over the page's name.

Run with `bun run og-images` (Pillow required). It writes apps/site/public/og/<page>.png, which lib/meta.ts points
each page's Open Graph and Twitter image at. The tiles come from scripts/icons.py, so they match the app icon.
Add a page here when lib/nav.ts gains one (test/og.test.ts fails until you do).
"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

from icons import MAPLE, ROOT, gradient, tile

FONTS = ROOT / "apps/ios/Sources/Shared/Fonts"
OUT = ROOT / "apps/site/public/og"

W, H = 1200, 630
S = 2  # supersampling
INK = (0x2B, 0x21, 0x18)
INK_3 = (0x7A, 0x6F, 0x66)  # --ink-3 on the paper
VOWELS = set("aeiou")

# (file name, the word in tiles, the page's name). The file name is the page's path, "index" for the home page.
PAGES = [
    ("index", "abc", "Montessori Keyboard"),
    ("install", "get", "Install"),
    ("features", "play", "Features"),
    ("privacy", "safe", "Privacy"),
    ("faq", "ask", "FAQ"),
    ("terms", "terms", "Terms of Service"),
    ("credits", "thanks", "Credits"),
]


def card(word: str, title: str, home: bool) -> Image.Image:
    w, h = W * S, H * S
    img = gradient((w, h), (0xFB, 0xF8, 0xF2), MAPLE.tray_top).convert("RGBA")

    size = 150 * S
    gap = 18 * S
    tiles = [tile(ch, size, size, MAPLE.vowel if ch in VOWELS else MAPLE.consonant, MAPLE) for ch in word]
    row = len(word) * size + (len(word) - 1) * gap
    x = (w - row) // 2
    cy = int(h * 0.36)
    for t in tiles:
        img.alpha_composite(t, (x + size // 2 - t.width // 2, cy - t.height // 2))
        x += size + gap

    draw = ImageDraw.Draw(img)
    bold = ImageFont.truetype(str(FONTS / "AlloLearner-Bold.otf"), 76 * S)
    medium = ImageFont.truetype(str(FONTS / "AlloLearner-Medium.otf"), 34 * S)
    draw.text((w // 2, int(h * 0.71)), title, font=bold, fill=INK, anchor="mm")
    line = "A wooden alphabet keyboard for iPhone and iPad" if home else "Montessori Keyboard"
    draw.text((w // 2, int(h * 0.83)), line, font=medium, fill=INK_3, anchor="mm")
    return img.resize((W, H), Image.LANCZOS).convert("RGB")


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    for name, word, title in PAGES:
        card(word, title, name == "index").save(OUT / f"{name}.png", optimize=True)
    print(f"{len(PAGES)} previews written to {Path(OUT).relative_to(ROOT)}")


if __name__ == "__main__":
    main()
