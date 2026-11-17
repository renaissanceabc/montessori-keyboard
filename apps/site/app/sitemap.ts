import type { MetadataRoute } from "next";

import { ALL_PAGES } from "@/lib/nav";

import { site } from "../site.config";

export const dynamic = "force-static";

/** Every page at its canonical address (the home page's has no trailing slash). */
export default function sitemap(): MetadataRoute.Sitemap {
  return ALL_PAGES.map((p) => ({
    url: p.href === "/" ? site.url : new URL(p.href, site.url).href,
    changeFrequency: "monthly",
    priority: p.href === "/" ? 1 : 0.7,
  }));
}
