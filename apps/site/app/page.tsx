import type { Metadata } from "next";
import Link from "next/link";

import { LiveKeyboard } from "@/components/demos/live-keyboard";
import { PadScene, SettingsScene } from "@/components/demos/scenes";
import { DownloadButton } from "@/components/download-button";
import { ExternalLink } from "@/components/external-link";
import { StageFigure } from "@/components/stage-figure";
import { HOME_TITLE, pageMeta } from "@/lib/meta";

import { site } from "../site.config";

export const metadata: Metadata = pageMeta("/");

export default function Overview() {
  return (
    <>
      <div className="meta">
        <span>{site.requirements}</span>
        <DownloadButton />
      </div>

      <h1 className="sr-only">{HOME_TITLE}</h1>
      <p className="lede">The Montessori moveable alphabet, as a keyboard for every app.</p>

      <StageFigure />

      <section>
        <h2>What it does</h2>
        <ul>
          <li>
            <strong>Wooden tiles.</strong> Lowercase print or cursive, blue vowels and red
            consonants, in ABC or QWERTY order.
          </li>
          <li>
            <strong>Quiet help.</strong> Phonograms on a long press, rhymes in the strip, bead
            colors on the numbers, and letter sounds if you turn them on.
          </li>
          <li>
            <strong>Nothing leaves the phone.</strong> No network, accounts, ads or analytics. One
            price.
          </li>
        </ul>
        <p>
          See <Link href="/features">Features</Link> for how each part works, or{" "}
          <Link href="/install">Install</Link> to set it up.
        </p>
      </section>

      <section>
        <h2>Try it</h2>
        <p>Tap the tiles, hold one for its letter teams, or tap a rhyme to swap it in.</p>
        <LiveKeyboard />
      </section>

      <section>
        <h2>On iPad</h2>
        <p>
          The same tiles on the bigger screen. They stretch to its width and keep their height, so a
          child’s finger finds them just as easily.
        </p>
        <PadScene />
      </section>

      <section>
        <h2>Companion app for grown-ups</h2>
        <p>Pick the order, the letters and the help, and watch the keyboard change as you do.</p>
        <SettingsScene />
      </section>

      <section>
        <h2>Where it comes from</h2>
        <p>
          The moveable alphabet is a box of loose wooden letters, vowels in blue and consonants in
          red. Children use it to build words from the sounds they hear, well before their hands are
          ready to write. Montessori Keyboard puts that box on a phone, so the letters a child types
          look like the ones on the classroom shelf.
        </p>
        <p>
          It’s open source under the {site.license} license, made by{" "}
          <ExternalLink href={site.maker.url}>{site.maker.name}</ExternalLink>. The code is on{" "}
          <ExternalLink href={site.githubUrl}>GitHub</ExternalLink>.
        </p>
      </section>
    </>
  );
}
