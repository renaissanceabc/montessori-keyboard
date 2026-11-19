import type { Metadata } from "next";
import Link from "next/link";

import { ExternalLink } from "@/components/external-link";
import { Question } from "@/components/faq";
import { PageHead } from "@/components/page-head";
import { pageMeta } from "@/lib/meta";

import { site } from "../../site.config";

export const metadata: Metadata = pageMeta("/faq");

export default function Faq() {
  return (
    <>
      <PageHead title="FAQ" line="Common questions about Montessori Keyboard" />

      <section className="faq-group">
        <Question q="What is it, and who is it for?">
          <p>
            A keyboard for iPhone and iPad that looks like the Montessori moveable alphabet, for
            young children learning their letters and the grown-ups helping them.
          </p>
        </Question>
        <Question q="What does it cost?">
          <p>
            {site.price}, once. No ads, in-app purchases or subscriptions. It’s also open source, so
            you can build it yourself.
          </p>
        </Question>
        <Question q="Is it on Android?">
          <p>Not yet. Android is planned for later.</p>
        </Question>
        <Question q="How do I turn it on?">
          <p>
            The app walks you through it: add Montessori Keyboard in Settings › General › Keyboard ›
            Keyboards, then tap the globe key to switch to it.
          </p>
        </Question>
        <Question q="Why lowercase, and why blue and red?">
          <p>
            Montessori classrooms start with lowercase print, and the moveable alphabet has blue
            vowels and red consonants. Capitals, cursive and QWERTY order are in the settings.
          </p>
        </Question>
        <Question q="Why does it ask for Full Access?">
          <p>
            Only for letter sounds and key clicks. It has no network access, so nothing typed can
            leave the phone. See <Link href="/privacy">Privacy</Link>.
          </p>
        </Question>
        <Question q="How do I get help or suggest something?">
          <p>
            Email <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a>, or open an issue
            on <ExternalLink href={site.githubUrl}>GitHub</ExternalLink>.
          </p>
        </Question>
      </section>
    </>
  );
}
