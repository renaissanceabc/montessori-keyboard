import type { MetadataRoute } from "next";

import { site } from "../site.config";

export const dynamic = "force-static";

/** Open to search engines, with the sitemap. */
export default function robots(): MetadataRoute.Robots {
  return { rules: { userAgent: "*", allow: "/" }, sitemap: new URL("/sitemap.xml", site.url).href };
}
