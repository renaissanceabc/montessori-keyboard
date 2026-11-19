import localFont from "next/font/local";

/**
 * Allo, Josh Puckett's friendly sans, as the keyboard's tiles and the app use it. One variable
 * file (roundness fixed at Friendly like the app's static fonts), trimmed from the allo-font
 * package to the characters and weights the site uses (`bun run site-font`), and served with the
 * site, so no other host is asked for anything. The learner forms (single-storey a, tailed l,
 * serifed I) are turned on in globals.css.
 */
export const allo = localFont({
  src: "../fonts/allo-site.woff2",
  weight: "400 800",
  style: "normal",
  variable: "--font-allo",
  adjustFontFallback: "Arial",
});

/** Playwrite US Trad, the cursive tiles' letters. Only the cursive demo uses it, so it isn't preloaded. */
export const playwrite = localFont({
  src: "../node_modules/@fontsource/playwrite-us-trad/files/playwrite-us-trad-latin-400-normal.woff2",
  weight: "400",
  variable: "--font-cursive",
  preload: false,
  adjustFontFallback: false,
});
