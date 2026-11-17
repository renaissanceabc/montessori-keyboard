import { describe, expect, it } from "vitest";

import { BEADS, FAMILIES, familyFor, isVowel, ROWS } from "../lib/keyboard";

describe("the keyboard", () => {
  it("has all 26 letters once in each order", () => {
    for (const rows of Object.values(ROWS)) {
      expect(rows.flat().toSorted()).toEqual([..."abcdefghijklmnopqrstuvwxyz"]);
    }
  });

  it("colors a, e, i, o and u as vowels, and y as a consonant", () => {
    expect([..."abcdefghijklmnopqrstuvwxyz"].filter(isVowel)).toEqual([..."aeiou"]);
  });

  it("offers a word's own family in the strip", () => {
    expect(familyFor("sun")).toEqual(FAMILIES.un);
    expect(familyFor("xyz")).toEqual(FAMILIES.at);
  });

  it("has a bead color for 1 to 10", () => {
    expect(BEADS.map((b) => b.n)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  });
});
