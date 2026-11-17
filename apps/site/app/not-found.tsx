import type { Metadata } from "next";
import Link from "next/link";

import { PageHead } from "@/components/page-head";
import { Tile } from "@/components/tile";

export const metadata: Metadata = { title: "Not found", robots: { index: false } };

/** Any address the site doesn't have (out/404.html in the static build). */
export default function NotFound() {
  return (
    <div className="prose">
      <div className="lost" aria-hidden="true">
        <Tile size="lg">o</Tile>
        <Tile size="lg">o</Tile>
        <Tile size="lg">p</Tile>
        <Tile size="lg">s</Tile>
      </div>
      <PageHead title="Not found" line="There’s no page at this address." />
      <p>
        It may have moved. Start again from the <Link href="/">home page</Link>.
      </p>
    </div>
  );
}
