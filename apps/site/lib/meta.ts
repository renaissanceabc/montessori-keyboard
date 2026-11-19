import type { Metadata } from "next";

import { site } from "../site.config";
import { ALL_PAGES } from "./nav";

/** The home page's title, in the tab and in search results. */
export const HOME_TITLE = "Montessori Keyboard: a wooden alphabet keyboard for iPhone";

/** A page's link preview in public/og, drawn by scripts/og-images.py: "index" for the home page, else its path. */
export function ogImage(href: string): string {
  return `/og/${href === "/" ? "index" : href.slice(1)}.png`;
}

/** A page's metadata from the nav: its title, description, canonical address and link preview. */
export function pageMeta(href: string): Metadata {
  const page = ALL_PAGES.find((p) => p.href === href);
  if (!page) throw new Error(`No page at ${href} in lib/nav.ts`);

  const title = href === "/" ? HOME_TITLE : `${page.title} · ${site.name}`;
  const image = { url: ogImage(href), width: 1200, height: 630, alt: title };

  return {
    ...(href !== "/" && { title: page.title }),
    description: page.description,
    alternates: { canonical: href },
    openGraph: {
      title,
      description: page.description,
      url: href,
      siteName: site.name,
      type: "website",
      images: [image],
    },
    twitter: { card: "summary_large_image", title, description: page.description, images: [image] },
  };
}
