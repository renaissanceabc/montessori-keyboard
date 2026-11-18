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

      <section className="faq-group" aria-labelledby="basics">
        <h2 id="basics">Basics</h2>
        <Question q="What is Montessori Keyboard?">
          <p>
            A keyboard for iPhone that looks like the moveable alphabet from Montessori classrooms:
            wooden tiles on a tray, lowercase print letters, blue vowels and red consonants. Once
            it’s on, a child can use it in any app with somewhere to type.
          </p>
        </Question>
        <Question q="Who is it for?">
          <p>
            Young children who are learning their letters and starting to build words, and the
            grown-ups and teachers helping them.
          </p>
        </Question>
        <Question q="What does it cost?">
          <p>
            {site.price} on the App Store, once. There are no ads, in-app purchases or
            subscriptions. The code is open source under the {site.license} license, so you can also
            build it yourself.
          </p>
        </Question>
        <Question q="Does it work on iPad or Android?">
          <p>It works on iPhone and iPad. Android is planned for later.</p>
        </Question>
        <Question q="How do I turn it on?">
          <p>
            In Settings, go to General › Keyboard › Keyboards › Add New Keyboard and pick Montessori
            Keyboard. Then tap the globe key to switch to it. The app walks you through this the
            first time you open it.
          </p>
        </Question>
      </section>

      <section className="faq-group" aria-labelledby="letters">
        <h2 id="letters">The letters</h2>
        <Question q="Why lowercase, and why blue and red?">
          <p>
            Montessori classrooms start with lowercase print, since that’s most of what children
            read. In the moveable alphabet, vowels are blue and consonants are red, so a child can
            see how words are put together.
          </p>
        </Question>
        <Question q="Can it show capitals?">
          <p>
            Yes. Turn on capitals in the app’s settings, then use shift. They’re off to start
            with.
          </p>
        </Question>
        <Question q="Can it show cursive?">
          <p>Yes. Choose print or cursive letters in the settings.</p>
        </Question>
        <Question q="Can the letters be in alphabet order?">
          <p>Yes. Pick QWERTY or ABC order in the settings.</p>
        </Question>
        <Question q="What are phonograms?">
          <p>
            Sounds written with more than one letter, like sh, ch, th, ai and ee. Touch and hold a
            tile to see the ones that start with it.
          </p>
        </Question>
        <Question q="What’s the strip above the keys?">
          <p>
            Word families. As a word is typed, the strip shows words that rhyme with it, like cat,
            hat and mat. Tap one to swap it in.
          </p>
        </Question>
        <Question q="What are the colors on the number keys?">
          <p>
            The colors of the Montessori bead stair: 1 is red, 2 green, 3 pink, 4 yellow, 5 light
            blue, 6 purple, 7 white, 8 brown and 9 dark blue.
          </p>
        </Question>
      </section>

      <section className="faq-group" aria-labelledby="privacy">
        <h2 id="privacy">Privacy and settings</h2>
        <Question q="Why does it ask for Full Access?">
          <p>
            Only to play letter sounds and key clicks: iOS doesn’t let a keyboard make sounds
            without it. Everything else works with it off. The keyboard has no network access, so
            nothing typed can leave the phone. See <Link href="/privacy">Privacy</Link>.
          </p>
        </Question>
        <Question q="Does it collect anything?">
          <p>No. No ads, no accounts, no analytics, and no network at all.</p>
        </Question>
        <Question q="How do I keep my child out of the settings?">
          <p>
            The settings are behind a grown-ups gate. To open them, type a number that’s written
            out in words, or use Face ID.
          </p>
        </Question>
        <Question q="Can I help, or suggest something?">
          <p>
            Yes. The code and its issues are on{" "}
            <ExternalLink href={site.githubUrl}>GitHub</ExternalLink>.
          </p>
        </Question>
      </section>

      <section className="faq-group" aria-labelledby="help">
        <h2 id="help">Help</h2>
        <Question q="How do I get help?">
          <p>
            Email <a href={`mailto:${site.supportEmail}`}>{site.supportEmail}</a> with what you
            see and which iPhone or iPad you use. A person reads every message.
          </p>
        </Question>
      </section>
    </>
  );
}
