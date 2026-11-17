import type { Metadata } from "next";

import { site } from "../site.config";
import { ALL_PAGES } from "./nav";

/** The home page's title, in the tab and in search results. */
export const HOME_TITLE = "Montessori Keyboard: a wooden alphabet keyboard for iPhone";

/** A page's metadata from the nav: its title, description and canonical address. */
export function pageMeta(href: string): Metadata {
  const page = ALL_PAGES.find((p) => p.href === href);
  if (!page) throw new Error(`No page at ${href} in lib/nav.ts`);

  return {
    ...(href !== "/" && { title: page.title }),
    description: page.description,
    alternates: { canonical: href },
    openGraph: {
      title: href === "/" ? HOME_TITLE : `${page.title} · ${site.name}`,
      description: page.description,
      url: href,
      siteName: site.name,
      type: "website",
    },
  };
}
