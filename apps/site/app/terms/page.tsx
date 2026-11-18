import type { Metadata } from "next";
import Link from "next/link";

import { ExternalLink } from "@/components/external-link";
import { PageHead } from "@/components/page-head";
import { pageMeta } from "@/lib/meta";

import { site } from "../../site.config";

export const metadata: Metadata = pageMeta("/terms");

/** The date these terms last changed. Update it with the text. */
const UPDATED = "18 November 2026";

/*
 * A plain-language draft, in the shape of Galley's terms, awaiting legal review before launch.
 * Apple's standard licence covers the App Store purchase itself; these cover the rest.
 */
export default function Terms() {
  return (
    <>
      <PageHead title="Terms of Service" line="The terms for Montessori Keyboard and this site" />
      <p className="updated">Last updated {UPDATED}</p>
      <p className="note">Draft, pending legal review.</p>

      <section id="who">
        <h2>Who we are</h2>
        <p>
          Montessori Keyboard is made by Karel Vuong through{" "}
          <ExternalLink href={site.maker.url}>{site.maker.name}</ExternalLink>, a product of
          Renaissance Labs Inc., 2482 Yonge Street #1481, Toronto, ON M4P 2H5, Canada. “We” means
          us; “you” means you, using the app or this site.
        </p>
      </section>

      <section id="app">
        <h2>Buying and using the app</h2>
        <p>
          The app is a one-time purchase of {site.price} on the App Store, with no subscription or
          in-app purchases. Apple sells it, so Apple’s standard licence for App Store apps applies,
          and refunds go through Apple. Grown-ups decide whether a child uses it and how.
        </p>
        <p>
          The code is open source under the {site.license} license, which covers the code itself:
          you can read, build and change it on{" "}
          <ExternalLink href={site.githubUrl}>GitHub</ExternalLink>. The name and icon stay ours.
        </p>
      </section>

      <section id="privacy">
        <h2>Your data</h2>
        <p>
          The app collects nothing and never goes online. What it does with what you type is on the{" "}
          <Link href="/privacy">Privacy</Link> page.
        </p>
      </section>

      <section id="liability">
        <h2>Disclaimers</h2>
        <p>
          The app and this site are provided “as is”. We work to keep them right, but can’t promise
          they’re free of bugs. To the extent the law allows, we aren’t liable for indirect losses,
          and our total liability is limited to what you paid for the app. Nothing here limits the
          rights consumer law gives you where you live.
        </p>
      </section>

      <section id="changes">
        <h2>Changes and law</h2>
        <p>
          If these terms change, the new version is posted here with a new date. They’re governed by
          the laws of Ontario and of Canada that apply there.
        </p>
      </section>

      <section id="contact">
        <h2>Questions</h2>
        <p>
          Write to <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>.
        </p>
      </section>
    </>
  );
}
