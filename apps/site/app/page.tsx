import type { Metadata } from "next";
import Link from "next/link";

import { SettingsScene } from "@/components/demos/scenes";
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
            <strong>Types in lowercase print.</strong> The letters children meet first, on maple
            tiles, or walnut in dark mode. Capitals come with shift, if you turn them on.
          </li>
          <li>
            <strong>Keeps the alphabet in order.</strong> The tiles start in ABC order for a child
            still finding each letter, and switch to QWERTY when they’re ready. Print or cursive.
          </li>
          <li>
            <strong>Helps quietly.</strong> Phonograms on a long press, rhymes in the strip, bead
            colors on the numbers. Nothing grades, quizzes or holds letters back.
          </li>
          <li>
            <strong>Says the sounds.</strong> Each tile can say its letter sound as it’s tapped,
            once you allow Full Access.
          </li>
          <li>
            <strong>Keeps the settings for grown-ups.</strong> They sit behind a gate: a number
            written in words, or Face ID.
          </li>
          <li>
            <strong>Stays on the phone.</strong> No network, no accounts, no analytics. One price,
            with no ads or in-app purchases.
          </li>
        </ul>
        <p>
          See <Link href="/features">Features</Link> for how each part works, or{" "}
          <Link href="/install">Install</Link> to set it up.
        </p>
      </section>

      <section>
        <h2>Settings</h2>
        <p>
          The keyboard comes with a small app for grown-ups. Its settings have a live keyboard at
          the top that changes as you do.
        </p>
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
