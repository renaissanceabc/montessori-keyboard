import { existsSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

import { ogImage } from "../lib/meta";
import { ALL_PAGES } from "../lib/nav";

const publicDir = join(import.meta.dirname, "..", "public");

describe("link previews", () => {
  it("has one for every page (run `bun run og-images` after adding a page)", () => {
    for (const p of ALL_PAGES)
      expect(existsSync(join(publicDir, ogImage(p.href))), p.href).toBe(true);
  });
});
