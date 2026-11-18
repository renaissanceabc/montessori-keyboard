import type { Metadata } from "next";
import Link from "next/link";

import { DownloadButton } from "@/components/download-button";
import { ExternalLink } from "@/components/external-link";
import { PageHead } from "@/components/page-head";
import { pageMeta } from "@/lib/meta";

import { site } from "../../site.config";

export const metadata: Metadata = pageMeta("/install");

/** A settings path, one step after another. */
function Path({ steps }: { steps: string[] }) {
  return (
    <p className="path">
      {steps.map((s, i) => (
        <span key={s}>
          {i > 0 && <span aria-hidden="true">›</span>}
          {s}
        </span>
      ))}
    </p>
  );
}

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
          Montessori Keyboard is free on the App Store. The app walks you through the steps below
          when you first open it.
        </p>
        <p>
          <DownloadButton />
        </p>
      </section>

      <section id="turn-on">
        <h2>Turn it on</h2>
        <ol>
          <li>Open the Settings app.</li>
          <li>Go to the keyboards list:</li>
        </ol>
        <Path steps={["General", "Keyboard", "Keyboards"]} />
        <ol start={3}>
          <li>Tap Add New Keyboard.</li>
          <li>Under Other Keyboards, tap Montessori Keyboard.</li>
        </ol>
        <p>The keyboard now shows up anywhere there’s something to type.</p>
      </section>

      <section id="switch">
        <h2>Switch to it</h2>
        <p>
          When a keyboard is open, tap the globe key in the bottom corner to move to the next
          keyboard. Touch and hold the globe key to pick one from a list.
        </p>
        <p>
          To make it come up first, go back to Keyboards in Settings, tap Edit, and drag Montessori
          Keyboard to the top.
        </p>
      </section>

      <section id="full-access">
        <h2>Allow Full Access</h2>
        <p>
          Full Access is only needed for letter sounds and key clicks. Without it, the keyboard
          works the same, just quietly.
        </p>
        <Path steps={["General", "Keyboard", "Keyboards", "Montessori Keyboard", "Allow Full Access"]} />
        <p className="note">
          iOS shows the same warning for every keyboard that asks for Full Access, saying it could
          send what you type over the network. Montessori Keyboard has no network access at all, so
          nothing your child types can leave the phone. See <Link href="/privacy">Privacy</Link>.
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
