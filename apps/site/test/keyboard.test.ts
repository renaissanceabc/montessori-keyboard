import { describe, expect, it } from "vitest";

import { BEADS, isVowel, rhymesFor, ROWS } from "../lib/keyboard";

describe("the keyboard", () => {
  it("has all 26 letters once in each order", () => {
    for (const rows of Object.values(ROWS)) {
      expect(rows.flat().toSorted()).toEqual([..."abcdefghijklmnopqrstuvwxyz"]);
    }
  });

  it("colors a, e, i, o and u as vowels, and y as a consonant", () => {
    expect([..."abcdefghijklmnopqrstuvwxyz"].filter(isVowel)).toEqual([..."aeiou"]);
  });

  it("offers up to three rhymes from the word's family, not the word itself", () => {
    expect(rhymesFor("cat")).toEqual(["bat", "hat", "mat"]);
    expect(rhymesFor("sun")).toEqual(["bun", "fun", "run"]);
    expect(rhymesFor("xyz")).toEqual([]);
    expect(rhymesFor("at")).toEqual([]);
  });

  it("has a bead color for 1 to 10", () => {
    expect(BEADS.map((b) => b.n)).toEqual([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
  });
});
