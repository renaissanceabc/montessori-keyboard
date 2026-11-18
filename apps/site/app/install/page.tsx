import type { Metadata } from "next";

import { DownloadButton } from "@/components/download-button";
import { ExternalLink } from "@/components/external-link";
import { PageHead } from "@/components/page-head";
import { pageMeta } from "@/lib/meta";

import { site } from "../../site.config";

export const metadata: Metadata = pageMeta("/install");

export default function Install() {
  return (
    <>
      <PageHead title="Install" line="Turn the keyboard on once, and it’s there in every app" />

      <section id="requirements">
        <h2>Requirements</h2>
        <ul>
          <li>An iPhone or iPad</li>
          <li>iOS or iPadOS 18 or later</li>
        </ul>
      </section>

      <section id="get">
        <h2>Get the app</h2>
        <p>
          Montessori Keyboard is free on the App Store. When you first open it, the app walks you
          through turning the keyboard on in Settings.
        </p>
        <p>
          <DownloadButton />
        </p>
      </section>

      <section id="source">
        <h2>Build from source</h2>
        <p>
          Needs a Mac with Xcode, Tuist and Bun. The{" "}
          <ExternalLink href={site.githubUrl}>README</ExternalLink> has the details.
        </p>
        <pre>{`bun install
bun run ios:generate
bun run ios:test`}</pre>
      </section>
    </>
  );
}
