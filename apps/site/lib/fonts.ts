import localFont from "next/font/local";

/**
 * Andika, SIL's typeface for beginning readers, as the keyboard's print tiles use it:
 * a single-storey a and g, and letters that don't mirror each other. Served with the
 * site from @fontsource's latin files, so no other host is asked for anything.
 */
export const andika = localFont({
  src: [
    {
      path: "../node_modules/@fontsource/andika/files/andika-latin-400-normal.woff2",
      weight: "400",
      style: "normal",
    },
    {
      path: "../node_modules/@fontsource/andika/files/andika-latin-700-normal.woff2",
      weight: "700",
      style: "normal",
    },
  ],
  variable: "--font-andika",
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
