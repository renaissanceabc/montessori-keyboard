/** The keyboard as the site draws it: the same rows, colors and words as the app. */

export type Order = "qwerty" | "abc";
export type Letters = "print" | "cursive";

const VOWELS = new Set(["a", "e", "i", "o", "u"]);

/** Vowels are blue and consonants red, as in a moveable alphabet. y counts as a consonant there. */
export const isVowel = (letter: string) => VOWELS.has(letter);

/** The letter rows, top to bottom, in each order. */
export const ROWS: Record<Order, string[][]> = {
  qwerty: [[..."qwertyuiop"], [..."asdfghjkl"], [..."zxcvbnm"]],
  abc: [[..."abcdefghij"], [..."klmnopqrs"], [..."tuvwxyz"]],
};

/** The letter teams a long press offers, by the tile that holds them (Phonograms.swift). */
export const PHONOGRAMS: Record<string, string[]> = {
  a: ["ai", "ay", "ar", "au", "aw"],
  c: ["ch", "ck"],
  e: ["ee", "ea", "er", "ew"],
  g: ["gh"],
  i: ["igh", "ir", "ie"],
  k: ["kn"],
  n: ["ng", "nk"],
  o: ["oa", "oo", "or", "ou", "ow", "oi", "oy"],
  p: ["ph"],
  q: ["qu"],
  s: ["sh"],
  t: ["th", "tch"],
  u: ["ur", "ue"],
  w: ["wh", "wr"],
};

/** Word families: a word's ending, and words that share it (a few of WordFamilies.swift's). */
export const FAMILIES: Record<string, string[]> = {
  at: ["bat", "cat", "hat", "mat", "rat", "sat"],
  un: ["bun", "fun", "run", "sun"],
  ig: ["big", "dig", "fig", "pig", "wig"],
  op: ["hop", "mop", "pop", "top"],
  en: ["hen", "men", "pen", "ten"],
};

/** The words in the strip for what's typed so far: its family if it has one, else the at family. */
export function familyFor(word: string): string[] {
  const end = Object.keys(FAMILIES).find((f) => word.length > f.length && word.endsWith(f));

  return FAMILIES[end ?? "at"];
}

/**
 * The bead stair's colors, one per number from 1 to 10 (10 is the golden bead bar).
 * The number keys on the 123 layer wear them.
 */
export const BEADS: { n: number; name: string; color: string }[] = [
  { n: 1, name: "red", color: "#D2232A" },
  { n: 2, name: "green", color: "#2E9B45" },
  { n: 3, name: "pink", color: "#EE86AE" },
  { n: 4, name: "yellow", color: "#F2C318" },
  { n: 5, name: "light blue", color: "#6DBFE8" },
  { n: 6, name: "purple", color: "#8E5BB5" },
  { n: 7, name: "white", color: "#E9E2D2" },
  { n: 8, name: "brown", color: "#8A5A2E" },
  { n: 9, name: "dark blue", color: "#1E3A8A" },
  { n: 10, name: "gold", color: "#C9A227" },
];

/** Each digit's bead color, 1 to 9, for the beads under the number keys. */
export const BEADS_BY_DIGIT: Record<number, string> = Object.fromEntries(
  BEADS.filter((b) => b.n < 10).map((b) => [b.n, b.color]),
);
