import type { Metadata } from "next";
import Link from "next/link";

import { PageHead } from "@/components/page-head";

export const metadata: Metadata = { title: "Not found", robots: { index: false } };

/** Any address the site doesn't have (out/404.html in the static build). */
export default function NotFound() {
  return (
    <>
      <div className="lost" aria-hidden="true">
        <span className="lost-tile" data-tone="vowel">
          o
        </span>
        <span className="lost-tile" data-tone="vowel">
          o
        </span>
        <span className="lost-tile">p</span>
        <span className="lost-tile">s</span>
      </div>
      <PageHead title="Not found" line="There’s no page at this address" />
      <p>
        It may have moved. Start again from <Link href="/">Overview</Link>.
      </p>
    </>
  );
}
