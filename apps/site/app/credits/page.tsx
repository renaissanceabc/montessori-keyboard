import type { Metadata } from "next";

import { ExternalLink } from "@/components/external-link";
import { PageHead } from "@/components/page-head";
import { pageMeta } from "@/lib/meta";

export const metadata: Metadata = pageMeta("/credits");

export default function Credits() {
  return (
    <div className="prose">
      <PageHead title="Credits" line="The type and the ideas Montessori Keyboard is built on." />

      <h2 id="fonts">Fonts</h2>

      <section className="credit" aria-labelledby="allo">
        <h3 id="allo">Allo</h3>
        <p className="sample" aria-hidden="true">
          a b c d e f g
        </p>
        <p>
          A friendly sans by Josh Puckett. We turn on its single-storey a, its tailed l and its
          serifed I, so the letters look the way children learn to write them. The print tiles, the
          app and this site use it.
        </p>
        <p>
          <ExternalLink href="https://allo.joshpuckett.me">allo.joshpuckett.me</ExternalLink>{" "}
          · SIL Open Font License 1.1
        </p>
      </section>

      <section className="credit" aria-labelledby="playwrite">
        <h3 id="playwrite">Playwrite US Trad</h3>
        <p className="sample sample-cursive" aria-hidden="true">
          a b c d e f g
        </p>
        <p>
          Part of TypeTogether’s Playwrite family of handwriting fonts, modeled on how children are
          taught to write in schools around the world. The cursive tiles use it.
        </p>
        <p>
          <ExternalLink href="https://github.com/TypeTogether/Playwrite">
            github.com/TypeTogether/Playwrite
          </ExternalLink>{" "}
          · SIL Open Font License 1.1
        </p>
      </section>

      <p>
        Both fonts are served from this site: Allo from its own package, Playwrite through{" "}
        <ExternalLink href="https://fontsource.org">Fontsource</ExternalLink>.
      </p>

      <h2 id="materials">The Montessori materials</h2>
      <p>
        Maria Montessori developed her method in Rome in the early 1900s, starting with the first
        Casa dei Bambini in 1907. Children there learned letters by touch and sound before writing
        them with a pencil.
      </p>
      <p>
        The moveable alphabet is a box of loose cutout letters, often wooden, with vowels in blue and
        consonants in red. Children use it to build words from the sounds they hear, well before
        their hands are ready to write. The keyboard’s tiles are modeled on it.
      </p>
      <p>
        The bead stair is a set of bead bars from 1 to 9, each its own color, used to show quantity.
        Its colors are on the keyboard’s number keys.
      </p>
      <p>
        Montessori Keyboard isn’t affiliated with or endorsed by any Montessori organization. The
        name describes the method it follows.
      </p>
    </div>
  );
}
