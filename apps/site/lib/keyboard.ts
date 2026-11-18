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

/** A few of the phonograms a long press offers, by the letter that holds them. */
export const PHONOGRAMS: Record<string, string[]> = {
  s: ["sh"],
  c: ["ch", "ck"],
  t: ["th"],
  a: ["ai", "ay", "ar"],
  e: ["ee", "ea", "er"],
  o: ["oa", "oo", "ow"],
};

/** Word families: a word's ending, and words that share it. */
export const FAMILIES: Record<string, string[]> = {
  at: ["cat", "hat", "mat", "sat", "bat"],
  un: ["sun", "run", "fun", "bun"],
  ig: ["pig", "dig", "big", "wig"],
  op: ["mop", "top", "hop", "pop"],
  en: ["hen", "pen", "ten", "den"],
};

/** The strip offers three rhymes at a time, as on iOS. */
export const RHYME_SLOTS = 3;

/** The rhymes in the strip for the word just typed: up to three from its family, or none. */
export function rhymesFor(word: string): string[] {
  const end = Object.keys(FAMILIES).find((f) => word.length > f.length && word.endsWith(f));
  if (!end) return [];

  return FAMILIES[end].filter((w) => w !== word).slice(0, RHYME_SLOTS);
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
