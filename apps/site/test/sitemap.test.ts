import { existsSync, readdirSync, statSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

import sitemap from "../app/sitemap";
import { ALL_PAGES } from "../lib/nav";
import { site } from "../site.config";

const app = join(import.meta.dirname, "..", "app");

/** Every page the app folder defines, as its address: app/guide/page.tsx is /guide. */
function pagesOnDisk(dir = app, base = ""): string[] {
  const out: string[] = [];

  for (const name of readdirSync(dir)) {
    const full = join(dir, name);

    if (statSync(full).isDirectory()) out.push(...pagesOnDisk(full, `${base}/${name}`));
    else if (name === "page.tsx") out.push(base || "/");
  }

  return out;
}

describe("the sitemap", () => {
  const urls = sitemap().map((e) => e.url);

  it("lists every page in the app folder", () => {
    for (const href of pagesOnDisk()) {
      expect(urls).toContain(href === "/" ? site.url : new URL(href, site.url).href);
    }
  });

  it("lists only pages that exist", () => {
    for (const p of ALL_PAGES) {
      const file = p.href === "/" ? "page.tsx" : join(p.href.slice(1), "page.tsx");
      expect(existsSync(join(app, file)), p.href).toBe(true);
    }
  });

  it("uses the site's address", () => {
    for (const url of urls) expect(url.startsWith(site.url)).toBe(true);
  });
});
