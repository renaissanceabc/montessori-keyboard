import type { Metadata } from "next";
import Link from "next/link";

import { PageHead } from "@/components/page-head";
import { pageMeta } from "@/lib/meta";

export const metadata: Metadata = pageMeta("/guide");

/** A settings path, one step after another. */
function Path({ steps }: { steps: string[] }) {
  return (
    <p className="path">
      {steps.map((s, i) => (
        <span key={s} style={{ display: "contents" }}>
          {i > 0 && <span aria-hidden="true">›</span>}
          <span>{s}</span>
        </span>
      ))}
    </p>
  );
}

export default function Guide() {
  return (
    <div className="prose">
      <PageHead title="Set up" line="Turn the keyboard on once, and it’s there in every app." />

      <p>
        The Montessori Keyboard app walks you through these steps when you first open it. Here they
        are in full, if you’d rather do them yourself.
      </p>

      <h2 id="turn-on">Turn it on</h2>
      <ol>
        <li>Open the Settings app on the iPhone.</li>
        <li>Go to the keyboards list:</li>
      </ol>
      <Path steps={["General", "Keyboard", "Keyboards"]} />
      <ol start={3}>
        <li>Tap Add New Keyboard.</li>
        <li>Under Other Keyboards, tap Montessori Keyboard.</li>
      </ol>
      <p>That’s it. The keyboard now shows up anywhere there’s something to type.</p>

      <h2 id="switch">Switch to it</h2>
      <p>
        When a keyboard is open, tap the globe key in the bottom corner to move to the next
        keyboard. Touch and hold the globe key to pick one from a list.
      </p>
      <p>
        To make it come up first, go back to Keyboards in Settings, tap Edit, and drag Montessori
        Keyboard to the top.
      </p>

      <h2 id="full-access">Allow Full Access</h2>
      <p>
        Full Access is only needed for letter sounds and key clicks. Without it, the keyboard works
        the same, just quietly.
      </p>
      <Path
        steps={["General", "Keyboard", "Keyboards", "Montessori Keyboard", "Allow Full Access"]}
      />
      <div className="callout">
        <p>
          iOS shows the same warning for every keyboard that asks for Full Access, saying it could
          send what you type over the network. Montessori Keyboard has no network access at all, so
          nothing your child types can leave the phone. The setting is what iOS requires for a
          keyboard to play sounds. See <Link href="/privacy">Privacy</Link>.
        </p>
      </div>

      <h2 id="settings">Change the settings</h2>
      <p>
        Open the Montessori Keyboard app to choose QWERTY or ABC order, print or cursive letters,
        capitals, sounds and the rest. A live keyboard on the settings screen shows each change as
        you make it. The settings sit behind a grown-ups gate: type the number that’s written out in
        words, or use Face ID.
      </p>

      <h2 id="try">Try it</h2>
      <p>
        The app’s Pad is a blank page for trying the keyboard without opening another app. It’s a
        good first place for a child to explore the tiles.
      </p>
    </div>
  );
}
