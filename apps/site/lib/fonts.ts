import localFont from "next/font/local";

/**
 * Allo, Josh Puckett's friendly sans, as the keyboard's tiles and the app use it. One variable
 * file (every weight, roundness fixed at Friendly like the app's static fonts) from the allo-font
 * package, served with the site, so no other host is asked for anything. The learner forms
 * (single-storey a, tailed l, serifed I) are turned on in globals.css.
 */
export const allo = localFont({
  src: "../node_modules/allo-font/fonts/webfonts/AlloVariableFriendly.woff2",
  weight: "100 900",
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
