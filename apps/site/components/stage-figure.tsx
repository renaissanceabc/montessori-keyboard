"use client";

import { useLayoutEffect, useRef, useState } from "react";

import { NumberScene, PhonogramScene, RhymeScene, TypeScene } from "./demos/scenes";

/** The scenes on Overview, in the order a child meets them. */
const TABS = [
  {
    key: "type",
    name: "Type",
    line: "Lowercase print on wooden tiles, blue vowels and red consonants. Each tile lifts a bigger copy under the finger.",
    Scene: TypeScene,
  },
  {
    key: "phonograms",
    name: "Phonograms",
    line: "Hold a tile to find the sounds made of two letters, like sh, ch and ee, and slide onto one.",
    Scene: PhonogramScene,
  },
  {
    key: "rhymes",
    name: "Rhymes",
    line: "The strip offers words from the same family. Tap one to swap it in and only the first sound changes.",
    Scene: RhymeScene,
  },
  {
    key: "numbers",
    name: "Numbers",
    line: "On 123 each digit carries its beads in the bead stair’s colors.",
    Scene: NumberScene,
  },
] as const;

type Key = (typeof TABS)[number]["key"];

/**
 * Montessori Keyboard on a phone, on Overview. It plays each scene and hands
 * on to the next, round and round; the tabs beneath jump between them.
 */
export function StageFigure() {
  const [key, setKey] = useState<Key>("type");
  const i = TABS.findIndex((t) => t.key === key);
  const tab = TABS[i];
  const next = () => setKey(TABS[(i + 1) % TABS.length].key);

  // One highlight that slides to the tab showing, clipped to it so it moves on clip-path alone.
  const group = useRef<HTMLFieldSetElement>(null);
  const [pill, setPill] = useState<{ left: number; right: number; span: number } | null>(null);
  useLayoutEffect(() => {
    const el = group.current;

    if (!el) return;

    const measure = () => {
      const on = el.querySelector<HTMLElement>(`button[data-key="${key}"]`);

      if (!on) return;
      const span = el.scrollWidth;
      setPill({ left: on.offsetLeft, right: span - on.offsetLeft - on.offsetWidth, span });
    };

    measure();
    const ro = new ResizeObserver(measure);
    ro.observe(el);

    return () => ro.disconnect();
  }, [key]);

  return (
    <figure className="fig">
      <div className="fig-stage">
        <tab.Scene key={key} onDone={next} />
      </div>
      <fieldset className="stage-tabs" aria-label="Show" ref={group}>
        {pill && (
          <i
            className="stage-pill"
            style={{
              width: pill.span,
              clipPath: `inset(0 ${pill.right}px 0 ${pill.left}px round 999px)`,
            }}
            aria-hidden="true"
          />
        )}
        {TABS.map((t) => (
          <button
            key={t.key}
            type="button"
            data-key={t.key}
            aria-pressed={t.key === key}
            onClick={() => setKey(t.key)}
          >
            {t.name}
          </button>
        ))}
      </fieldset>
      <figcaption key={key} className="ex-hint is-keyed">
        {tab.line}
      </figcaption>
    </figure>
  );
}
