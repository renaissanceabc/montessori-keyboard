import type { Metadata } from "next";

import { ExternalLink } from "@/components/external-link";
import { PageHead } from "@/components/page-head";
import { pageMeta } from "@/lib/meta";

import { site } from "../../site.config";

export const metadata: Metadata = pageMeta("/privacy");

/** The date this policy last changed. Update it with the text. */
const UPDATED = "18 November 2026";

export default function Privacy() {
  return (
    <>
      <PageHead title="Privacy" line="Montessori Keyboard collects nothing" />
      <p className="updated">Last updated {UPDATED}</p>

      <section id="short">
        <h2>In short</h2>
        <ul>
          <li>No ads, accounts, analytics or tracking.</li>
          <li>No network access. The keyboard and the app never go online.</li>
          <li>Nothing about you or your child is collected, so there’s nothing to delete.</li>
        </ul>
      </section>

      <section id="app">
        <h2>In the app</h2>
        <p>
          What your child types stays on the device. The rhymes and phonograms come from word lists
          built into the app, and your settings are saved on the device until you delete it.
        </p>
        <p>
          iOS needs Full Access before a keyboard can play sounds, and warns that such a keyboard
          could send what you type. Montessori Keyboard has no network code, so it can’t. If you
          open the settings with Face ID, the app only learns whether it matched.
        </p>
      </section>

      <section id="website">
        <h2>This website</h2>
        <p>
          No cookies, analytics or third-party scripts. Our host may keep standard server logs for
          security. If you pick a light or dark look, your browser remembers it.
        </p>
      </section>

      <section id="contact">
        <h2>Questions</h2>
        <p>
          Montessori Keyboard is made by{" "}
          <ExternalLink href={site.maker.url}>{site.maker.name}</ExternalLink>. Write to{" "}
          <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>. The code is on{" "}
          <ExternalLink href={site.githubUrl}>GitHub</ExternalLink>, so anyone can check what it
          does. Changes to this policy are posted here with a new date.
        </p>
      </section>
    </>
  );
}
