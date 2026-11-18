import type { Metadata } from "next";

import { ExternalLink } from "@/components/external-link";
import { PageHead } from "@/components/page-head";
import { pageMeta } from "@/lib/meta";

import { site } from "../../site.config";

export const metadata: Metadata = pageMeta("/privacy");

/** The date this policy last changed. Update it with the text. */
const UPDATED = "17 November 2026";

export default function Privacy() {
  return (
    <div className="prose">
      <PageHead title="Privacy" line="Montessori Keyboard collects nothing." />
      <p className="updated">Last updated {UPDATED}</p>

      <h2 id="short">In short</h2>
      <ul>
        <li>No ads.</li>
        <li>No accounts or sign-in.</li>
        <li>No analytics, tracking or crash reports.</li>
        <li>No network access. The keyboard and the app never go online.</li>
      </ul>

      <h2 id="typing">What your child types</h2>
      <p>
        Everything typed with Montessori Keyboard stays on the device. The keyboard doesn’t store
        it, send it, or show it to us. The word-family strip and the phonograms come from word lists
        built into the app.
      </p>

      <h2 id="settings">Settings</h2>
      <p>
        Your choices, such as the letter order or whether capitals are on, are saved on the device
        so the keyboard can read them. They aren’t sent anywhere. Deleting the app removes them.
      </p>

      <h2 id="full-access">Allow Full Access</h2>
      <p>
        iOS asks you to allow Full Access before a keyboard can play sounds. When you turn it on,
        iOS warns that a keyboard with Full Access could send what you type over the network.
        Montessori Keyboard has no network code at all, so even with Full Access on, nothing can
        leave the phone. Sounds are the only thing Full Access is used for.
      </p>

      <h2 id="face-id">Face ID</h2>
      <p>
        If you use Face ID to open the settings, iOS checks your face and tells the app only whether
        it matched. The app never sees your face data.
      </p>

      <h2 id="children">Children</h2>
      <p>
        Montessori Keyboard is made for young children. Because it collects no personal information
        from anyone, there’s nothing to request, correct or delete.
      </p>

      <h2 id="website">This website</h2>
      <p>
        This site has no cookies, no analytics and no third-party scripts. Its fonts and images are
        served from this site, and our host may keep standard server logs, such as IP addresses, for
        security.
      </p>

      <h2 id="check">Check for yourself</h2>
      <p>
        The app is open source, so anyone can read exactly what it does. The code is on{" "}
        <ExternalLink href={site.githubUrl}>GitHub</ExternalLink>.
      </p>

      <h2 id="contact">Questions</h2>
      <p>
        Montessori Keyboard is made by{" "}
        <ExternalLink href={site.maker.url}>{site.maker.name}</ExternalLink>. Questions about
        privacy go to <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>. If this
        policy changes, the new version will be posted here with a new date.
      </p>
    </div>
  );
}
