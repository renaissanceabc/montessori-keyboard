import type { Metadata } from "next";
import Link from "next/link";

import { NumberScene, PhonogramScene, RhymeScene, SettingsScene, TypeScene } from "@/components/demos/scenes";
import { PageHead } from "@/components/page-head";
import { pageMeta } from "@/lib/meta";

export const metadata: Metadata = pageMeta("/features");

export default function Features() {
  return (
    <>
      <PageHead title="Features" line="Everything the keyboard does, and where to change it" />

      <section id="tiles">
        <h2>The tiles</h2>
        <p>
          Each key is a wooden tile with a lowercase print letter: blue for the vowels, red for the
          consonants, as in the moveable alphabet. A tile sinks under a finger and lifts a bigger
          copy of its letter above it, so small hands can see what they hit.
        </p>
        <TypeScene />
        <ul>
          <li>
            <strong>ABC or QWERTY.</strong> The tiles start in alphabet order. Switch to QWERTY,
            the layout grown-ups use, when a child is ready.
          </li>
          <li>
            <strong>Print or cursive.</strong> Many Montessori classrooms teach cursive alongside
            print. The cursive tiles use Playwrite US Trad.
          </li>
          <li>
            <strong>Capitals.</strong> Off to start with. Turn on capitals with shift in the
            settings.
          </li>
          <li>
            <strong>Maple and walnut.</strong> Light tiles on a maple tray, or walnut when the
            iPhone is in dark mode.
          </li>
        </ul>
      </section>

      <section id="phonograms">
        <h2>Phonograms</h2>
        <p>
          Touch and hold a tile to see the sounds written with more than one letter that start with
          it: sh on s, ch and ck on c, ee, ea and er on e, and so on. Slide onto one and lift to
          type it, or lift away and tap one.
        </p>
        <PhonogramScene />
        <p className="note">Turn phonograms off in the settings if a long press gets in the way.</p>
      </section>

      <section id="rhymes">
        <h2>Word families</h2>
        <p>
          The strip above the tiles offers words that rhyme with the one being typed: cat, hat, mat
          and sat. Tap one and it takes the word’s place, so a child hears that only the first sound
          changed.
        </p>
        <RhymeScene />
        <p>
          The strip can show the letters of the word instead, to change one at a time, or nothing
          at all.
        </p>
      </section>

      <section id="numbers">
        <h2>Numbers</h2>
        <p>
          Tap 123 for the digits. Each one carries its beads in the colors of the Montessori bead
          stair: 1 red, 2 green, 3 pink, 4 yellow, 5 light blue, 6 purple, 7 white, 8 brown and 9
          dark blue.
        </p>
        <NumberScene />
        <p>The settings can show red and blue number rods under the digits instead, or nothing.</p>
      </section>

      <section id="sounds">
        <h2>Letter sounds</h2>
        <p>
          Each tile can say its letter sound as it’s tapped, and keys can click. iOS only lets a
          keyboard make sounds when you allow Full Access, so the keyboard is quiet until you do.
          See <Link href="/install#full-access">Allow Full Access</Link>.
        </p>
      </section>

      <section id="app">
        <h2>Companion app</h2>
        <p>
          The keyboard comes with a small app for grown-ups. Its settings have a live keyboard at
          the top that shows each change as you make it.
        </p>
        <SettingsScene />
        <ul>
          <li>
            <strong>Setup</strong> walks you through adding the keyboard in Settings.
          </li>
          <li>
            <strong>Settings</strong> for the order, letter shapes, capitals, the strip, numbers
            and sounds.
          </li>
          <li>
            <strong>Pad</strong>, a blank page for trying the keyboard without opening another
            app.
          </li>
          <li>
            <strong>About</strong>, on who makes it and why.
          </li>
        </ul>
      </section>
    </>
  );
}
