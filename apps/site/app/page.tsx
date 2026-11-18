import type { Metadata } from "next";
import Link from "next/link";

import { DownloadButton } from "@/components/download-button";
import { ExternalLink } from "@/components/external-link";
import { Keyboard } from "@/components/keyboard";
import { Tile } from "@/components/tile";
import { BEADS } from "@/lib/keyboard";
import { pageMeta } from "@/lib/meta";

import { site } from "../site.config";

export const metadata: Metadata = pageMeta("/");

export default function Home() {
  return (
    <>
      <section className="hero" aria-labelledby="hero-title">
        <div className="hero-text">
          <p className="eyebrow">A keyboard for iPhone, for young children</p>
          <h1 id="hero-title">The moveable alphabet, on a phone.</h1>
          <p className="lead">
            Wooden tiles on a tray, lowercase print letters, blue vowels and red consonants. The way
            Montessori classrooms start, in every app your child types in.
          </p>
          <div className="actions">
            <DownloadButton />
            <ExternalLink href={site.githubUrl} className="button">
              See the code
            </ExternalLink>
          </div>
          <p className="note">Free and open source. Made by Renaissance.</p>
        </div>
        <div className="hero-keyboard">
          <Keyboard />
          <p className="hint">Try it: tap the tiles, or a word in the strip.</p>
        </div>
      </section>

      <section className="features" aria-labelledby="features-title">
        <h2 id="features-title">What’s on the tray</h2>

        <div className="feature-grid">
          <Feature
            title="Lowercase print first"
            art={
              <div className="art-row">
                <Tile>s</Tile>
                <Tile>u</Tile>
                <Tile>n</Tile>
              </div>
            }
          >
            Children meet letters in lowercase print, so that’s what the tiles show. Capitals come
            with shift, and only if you turn them on.
          </Feature>

          <Feature
            title="QWERTY or ABC"
            art={
              <div className="art-row">
                <Tile>a</Tile>
                <Tile>b</Tile>
                <Tile>c</Tile>
                <Tile>d</Tile>
              </div>
            }
          >
            Keep the layout grown-ups use, or set the tiles out in alphabet order for a child still
            finding each letter.
          </Feature>

          <Feature
            title="Print or cursive"
            art={
              <div className="art-row art-cursive">
                <Tile>a</Tile>
                <Tile>m</Tile>
                <Tile>e</Tile>
              </div>
            }
          >
            Many Montessori classrooms teach cursive alongside print. Switch the tiles to cursive
            letters in settings.
          </Feature>

          <Feature
            title="Phonograms on a long press"
            art={
              <div className="art-phono">
                <div className="phono-pop" aria-hidden="true">
                  <Tile size="sm" tone="consonant">
                    sh
                  </Tile>
                </div>
                <Tile>s</Tile>
              </div>
            }
          >
            Hold a tile to find the sounds made of two letters: sh, ch and th on the consonants, ai
            and ee on the vowels.
          </Feature>

          <Feature
            title="Word families"
            art={
              <div className="art-strip" aria-hidden="true">
                <span>hat</span>
                <span>mat</span>
                <span>sat</span>
              </div>
            }
          >
            A strip above the tiles offers three words that rhyme with the one being typed. Tap one
            to swap it in, and hear how only the first sound changes.
          </Feature>

          <Feature
            title="Numbers in bead colors"
            art={
              <div className="art-beads" aria-hidden="true">
                {BEADS.slice(0, 9).map((b) => (
                  <span key={b.n} className="mini-key">
                    {b.n}
                    <span className="bead" style={{ background: b.color }} />
                  </span>
                ))}
              </div>
            }
          >
            The 123 keys carry the colors of the bead stair, so 3 is pink and 7 is white, as on the
            classroom shelf.
          </Feature>

          <Feature
            title="Letter sounds"
            art={
              <div className="art-row art-sound">
                <Tile>m</Tile>
                <svg width="34" height="28" viewBox="0 0 34 28" aria-hidden="true">
                  <path
                    d="M4 10v8M11 6v16M18 2v24M25 7v14M31 11v6"
                    stroke="currentColor"
                    strokeWidth="3"
                    strokeLinecap="round"
                  />
                </svg>
              </div>
            }
          >
            Each tile can say its letter sound as it’s tapped, and keys can click. Sounds need Allow
            Full Access, and they play on the phone.{" "}
            <Link href="/guide#full-access">Why Full Access?</Link>
          </Feature>

          <Feature
            title="A gate for grown-ups"
            art={
              <div className="art-gate" aria-hidden="true">
                <span className="gate-word">seventy-four</span>
                <span className="gate-answer">74</span>
              </div>
            }
          >
            The settings open only for a grown-up: type a number written in words, or use Face ID.
          </Feature>
        </div>
      </section>

      <section className="split" aria-labelledby="app-title">
        <div>
          <h2 id="app-title">A small app to set it up</h2>
          <p>
            The keyboard comes with an app for grown-ups. It walks you through turning the keyboard
            on, and holds the settings, with a live keyboard that changes as you do.
          </p>
        </div>
        <ul className="checklist">
          <li>
            <strong>Setup</strong> and a step-by-step guide to adding the keyboard
          </li>
          <li>
            <strong>Settings</strong> with a live preview of the tiles
          </li>
          <li>
            <strong>Pad</strong>, a blank page to try it out
          </li>
          <li>
            <strong>About</strong>, on who makes it and why
          </li>
        </ul>
      </section>

      <section className="panel" aria-labelledby="privacy-title">
        <h2 id="privacy-title">Nothing leaves the phone</h2>
        <p>
          Montessori Keyboard has no network access at all. What your child types stays on the
          device, and there’s nothing for us to collect.
        </p>
        <ul className="pills">
          <li>No ads</li>
          <li>No accounts</li>
          <li>No analytics</li>
          <li>No network</li>
        </ul>
        <p>
          <Link href="/privacy">Read the privacy policy</Link>
        </p>
      </section>

      <section className="split" aria-labelledby="open-title">
        <div>
          <h2 id="open-title">Free and open source</h2>
          <p>
            No price, no in-app purchases, and the whole app is on GitHub under the {site.license}{" "}
            license. Read how it works, suggest a change, or build your own.
          </p>
        </div>
        <div className="split-action">
          <ExternalLink href={site.githubUrl} className="button">
            renaissanceabc/montessori-keyboard
          </ExternalLink>
        </div>
      </section>

      <section className="cta" aria-labelledby="cta-title">
        <div className="art-row" aria-hidden="true">
          <Tile size="lg">h</Tile>
          <Tile size="lg">e</Tile>
          <Tile size="lg">l</Tile>
          <Tile size="lg">l</Tile>
          <Tile size="lg">o</Tile>
        </div>
        <h2 id="cta-title">Ready when they are</h2>
        <p>For iPhone and iPad. Android is on the way.</p>
        <div className="actions">
          <DownloadButton />
          <Link href="/guide" className="button">
            How to set it up
          </Link>
        </div>
      </section>
    </>
  );
}

function Feature({
  title,
  art,
  children,
}: {
  title: string;
  art: React.ReactNode;
  children: React.ReactNode;
}) {
  return (
    <article className="feature">
      <div className="feature-art">{art}</div>
      <h3>{title}</h3>
      <p>{children}</p>
    </article>
  );
}
