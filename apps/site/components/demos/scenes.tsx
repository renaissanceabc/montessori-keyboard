"use client";

import { useState, useSyncExternalStore, type CSSProperties, type ReactNode } from "react";

import { FAMILIES, PHONOGRAMS, type Order } from "@/lib/keyboard";
import { isDark, subscribeTheme } from "@/lib/theme";

import { Phone } from "../stageshow/phone";
import { StillContext, useReducedMotion } from "../stageshow/reduced-motion";
import { Stage } from "../stageshow/stage";
import type { Act } from "../stageshow/act";
import type { Layout } from "../stageshow/looks";
import { Tray, trayHeight, type Strip } from "./tray";

/*
 * The site's illustrations: a phone with Montessori Keyboard up, built with
 * Stageshow. Each scene is one short story told by a finger on the tiles. The
 * phone runs off the top of the frame, so the crop falls in the note above the
 * keyboard and the tray, the subject, is whole. A scene passed `onDone` (the
 * Overview figure) hands on to the next when it finishes; on its own it loops,
 * undoing what it typed with the delete key so the loop has a cause.
 */

/** The phone screen's width in points (Stageshow's iPhone). */
const SCREEN_W = 402;
const SCREEN_H = 874;

/** Walnut when the page is dark, so the phone matches the page around it. */
export function useDark() {
  return useSyncExternalStore(subscribeTheme, isDark, () => false);
}

/** The phone's size and place in each design: wide (the 600px column) and compact (a 358px phone column). */
/** An 11-inch iPad's screen in portrait, in points, and its bezel. */
const PAD_W = 820;
const PAD_H = 1180;
const PAD_BEZEL = 24;

const FRAMES = {
  keyboard: {
    wide: { w: 600, h: 470, phone: 440, gutter: 24 },
    compact: { w: 358, h: 368, phone: 326, gutter: 16 },
  },
  pad: {
    wide: { w: 600, h: 420, phone: 560, gutter: 24 },
    compact: { w: 358, h: 300, phone: 342, gutter: 16 },
  },
  app: {
    wide: { w: 600, h: 560, phone: 440, gutter: 24 },
    compact: { w: 358, h: 440, phone: 326, gutter: 16 },
  },
} as const;

/** A phone's outer height for its width (Stageshow's pro frame: the screen plus 13pt of band and glass a side). */
const phoneHeight = (w: number) => (w * (SCREEN_H + 26)) / (SCREEN_W + 26);

/** An iPad's outer height for its width. */
const padHeight = (w: number) => (w * (PAD_H + PAD_BEZEL * 2)) / (PAD_W + PAD_BEZEL * 2);

/** An iPad, drawn like Stageshow's phone: the screen laid out at true points and scaled down as a whole. */
function Pad({
  width,
  style,
  children,
}: {
  width: number;
  style: CSSProperties;
  children: ReactNode;
}) {
  const s = width / (PAD_W + PAD_BEZEL * 2);

  return (
    <div
      className="mk-pad"
      style={{
        ...style,
        width,
        height: padHeight(width),
        padding: PAD_BEZEL * s,
        borderRadius: 40 * s,
      }}
    >
      <div className="mk-pad-window" style={{ borderRadius: 18 * s }}>
        <div
          className="mk-pad-screen"
          style={{ width: PAD_W, height: PAD_H, transform: `scale(${s})` }}
        >
          {children}
        </div>
      </div>
    </div>
  );
}

type Pinned = "bottom" | "top";

/** The phone in the stage: centered, its bottom (or top) a gutter in, running off the other edge. */
function Placed({
  layout,
  kind,
  pin,
  children,
}: {
  layout: Layout;
  kind: keyof typeof FRAMES;
  pin: Pinned;
  children: ReactNode;
}) {
  const f = FRAMES[kind][layout];
  const dark = useDark();
  const height = kind === "pad" ? padHeight(f.phone) : phoneHeight(f.phone);
  const top = pin === "bottom" ? f.h - f.gutter - height : f.gutter;

  if (kind === "pad") {
    return (
      <Pad width={f.phone} style={{ position: "absolute", left: (f.w - f.phone) / 2, top }}>
        {children}
      </Pad>
    );
  }

  return (
    <Phone
      width={f.phone}
      dark={dark}
      wallpaper="var(--mk-page)"
      className="mk-phone"
      style={{ position: "absolute", left: (f.w - f.phone) / 2, top }}
    >
      {children}
    </Phone>
  );
}

/** A note being written: the line before it, and the line being typed, just above the keyboard. */
function Note({ before, text, bottom }: { before?: string; text: string; bottom: number }) {
  return (
    <div className="mk-note" style={{ bottom }}>
      {before && <div className="mk-note-line">{before}</div>}
      <div className="mk-note-line">
        {text}
        <span className="mk-caret" />
      </div>
    </div>
  );
}

/**
 * A scene with a pause button, since motion that runs on its own for more than five seconds should
 * be stoppable. Paused, the stage shows its still. With reduced motion it is already still, so
 * there's no button. The button sits outside the picture, which screen readers read as one image.
 */
function Figure({ label, children }: { label: string; children: ReactNode }) {
  const [paused, setPaused] = useState(false);
  const reduced = useReducedMotion();

  return (
    <div className="mk-figure">
      <div role="img" aria-label={label}>
        <StillContext.Provider value={paused}>{children}</StillContext.Provider>
      </div>
      {!reduced && (
        <button
          type="button"
          className="mk-pause"
          aria-label="Pause the animation"
          aria-pressed={paused}
          onClick={() => setPaused((p) => !p)}
        >
          <svg width="12" height="12" viewBox="0 0 12 12" aria-hidden="true">
            {paused ? (
              <path d="M3 1.5v9l7.5-4.5z" fill="currentColor" />
            ) : (
              <path d="M2.5 1.5h2.5v9H2.5zM7 1.5h2.5v9H7z" fill="currentColor" />
            )}
          </svg>
        </button>
      )}
    </div>
  );
}

/** The shared frame of the keyboard scenes: stage, phone, note and tray. */
function KeyboardStage<S extends KeyboardState>({
  initial,
  poster,
  script,
  label,
  device = "phone",
}: {
  initial: S;
  poster?: S;
  script: (a: Act<S>) => Promise<void>;
  label: string;
  device?: "phone" | "pad";
}) {
  const dark = useDark();
  const kind = device === "pad" ? "pad" : "keyboard";
  const f = FRAMES[kind];

  return (
    <Figure label={label}>
      <Stage<S>
        width={f.wide.w}
        height={f.wide.h}
        compact={{ below: 560, width: f.compact.w, height: f.compact.h }}
        initial={initial}
        poster={poster}
        script={script}
        theme={dark ? "dark" : "light"}
        cursor={{ at: { x: f.wide.w / 2, y: f.wide.h - 60 }, style: "touch" }}
        className="mk-stage"
      >
        {(s, _rect, layout) => (
          <Placed layout={layout} kind={kind} pin="bottom">
            <Note before={s.before} text={s.text} bottom={trayHeight() + 18} />
            <Tray
              width={device === "pad" ? PAD_W : SCREEN_W}
              className="mk-screen-tray"
              layer={s.layer}
              strip={s.strip}
              down={s.down}
              popup={s.popup}
              order={s.order ?? "abc"}
            />
          </Placed>
        )}
      </Stage>
    </Figure>
  );
}

type KeyboardState = {
  before?: string;
  text: string;
  strip: Strip;
  layer: "letters" | "numbers";
  down: string | null;
  popup: { letter: string; choices: string[]; chosen: number | null } | null;
  order?: Order;
};

const base = { strip: null, layer: "letters", down: null, popup: null } as const;

/** The strip for the word at the end of `text`: its family, with the word itself marked. */
function stripFor(text: string): Strip {
  const word = text.split(" ").at(-1) ?? "";
  const family = Object.keys(FAMILIES).find((f) => word.length > f.length && word.endsWith(f));

  return family ? { family, words: FAMILIES[family], current: word } : null;
}

/** Taps a key and types what it makes, with the strip following the word. */
async function tap<S extends KeyboardState>(a: Act<S>, key: string, typed = key) {
  await a.click(`key-${key}`);
  await a.set(((s: S) => {
    const text = s.text + typed;

    return { text, strip: stripFor(text) };
  }) as (s: S) => Partial<S>);
  await a.wait(180);
}

/** Taps delete once per character, back to `to`: what the scene typed leaves the way it came. */
async function undo<S extends KeyboardState>(a: Act<S>, to: string) {
  // Read what's typed now (a set that changes nothing hands over the state).
  let text = "";
  await a.set(((s: S) => {
    text = s.text;

    return {};
  }) as (s: S) => Partial<S>);
  while (text.length > to.length) {
    await a.click("key-delete");
    text = text.slice(0, -1);
    const t = text;
    await a.set({ text: t, strip: stripFor(t) } as Partial<S>);
    await a.wait(60);
  }
}

// Type ----------------------------------------------------------------------------------------------------

const TYPE_START: KeyboardState = { ...base, before: "we went to the farm", text: "a " };

/** Print letters under a finger: each tile sinks and lifts a bigger copy, and the strip finds the word's family. */
export function TypeScene({ onDone }: { onDone?: () => void }) {
  return (
    <KeyboardStage
      label="A phone with Montessori Keyboard: a finger types “a cat sat” on wooden tiles, blue vowels and red consonants."
      initial={TYPE_START}
      poster={{ ...TYPE_START, text: "a cat sat", strip: stripFor("a cat sat") }}
      script={async (a) => {
        await a.wait(500);

        for (const l of "cat") await tap(a, l);
        await a.wait(500);
        await tap(a, "space", " ");

        for (const l of "sat") await tap(a, l);
        await a.wait(2000);

        if (onDone) return onDone();
        await undo(a, TYPE_START.text);
        await a.wait(400);
      }}
    />
  );
}

// iPad ------------------------------------------------------------------------------------------------------

const PAD_START: KeyboardState = {
  ...base,
  before: "on the farm we saw",
  text: "a ",
  order: "qwerty",
};

/** The same tiles on an iPad, in QWERTY order: the grid stretches to the wider screen and the rows stay as tall. */
export function PadScene() {
  return (
    <KeyboardStage
      device="pad"
      label="An iPad with Montessori Keyboard in QWERTY order: a finger types “a pig” on wide wooden tiles, and the strip offers big, dig, fig, pig and wig."
      initial={PAD_START}
      poster={{ ...PAD_START, text: "a pig", strip: stripFor("a pig") }}
      script={async (a) => {
        await a.wait(500);

        for (const l of "pig") await tap(a, l);
        await a.wait(1400);
        await a.click("chip-big");
        await a.set({ text: "a big", strip: stripFor("a big") });
        await a.wait(1400);
        await tap(a, "space", " ");

        for (const l of "pig") await tap(a, l);
        await a.wait(2000);
        await undo(a, PAD_START.text);
        await a.wait(400);
      }}
    />
  );
}

// Phonograms ------------------------------------------------------------------------------------------------

const PHONO_START: KeyboardState = { ...base, before: "we went to the farm", text: "a big " };

/** Hold a tile: its letter teams open over it, the finger slides to sh and lifts, and the word goes on. */
export function PhonogramScene({ onDone }: { onDone?: () => void }) {
  const choices = ["s", ...PHONOGRAMS.s];
  const popup = (chosen: number | null) => ({ letter: "s", choices, chosen });

  return (
    <KeyboardStage
      label="Holding the s tile opens its phonogram, sh, above it. The finger slides to sh, and “a big ship” is typed."
      initial={PHONO_START}
      poster={{ ...PHONO_START, text: "a big ", down: "s", popup: popup(1) }}
      script={async (a) => {
        await a.wait(500);
        await a.move("key-s");
        const from = a.center("key-s");
        // The finger lands, holds while the teams open, then slides across to sh and lifts there.
        let opened = false;
        await a.drag(
          "pop-1",
          (_at, _from, t) => {
            if (t > 0.05 && !opened) a.put({ down: "s" } as Partial<KeyboardState>);

            if (t > 0.45 && !opened) {
              opened = true;
              a.put({ popup: popup(0) } as Partial<KeyboardState>);
            }

            if (t > 0.8) a.put({ popup: popup(1) } as Partial<KeyboardState>);
          },
          {
            duration: 1500,
            path: (p, _f, to) => {
              const k = Math.max(0, (p - 0.6) / 0.4);
              const e = k * k * (3 - 2 * k);

              return { x: from.x + (to.x - from.x) * e, y: from.y + (to.y - from.y) * e };
            },
          },
        );
        await a.wait(300);
        await a.set((s) => ({ text: s.text + "sh", down: null, popup: null, strip: null }));
        await a.wait(500);

        for (const l of "ip") await tap(a, l);
        await a.wait(2000);

        if (onDone) return onDone();
        await undo(a, PHONO_START.text);
        await a.wait(400);
      }}
    />
  );
}

// Rhymes ----------------------------------------------------------------------------------------------------

const RHYME_START: KeyboardState = {
  ...base,
  before: "we went to the farm",
  text: "the cat",
  strip: stripFor("the cat"),
};

/** The strip: tap a rhyme and it takes the word's place, so only the first sound changes. */
export function RhymeScene({ onDone }: { onDone?: () => void }) {
  const swap = async (a: Act<KeyboardState>, word: string) => {
    await a.click(`chip-${word}`);
    await a.set((s) => {
      const text = s.text.replace(/\S+$/, word);

      return { text, strip: stripFor(text) };
    });
  };

  return (
    <KeyboardStage
      label="The word-family strip above the tiles offers bat, cat, hat, mat, rat and sat. Tapping hat changes “the cat” to “the hat”."
      initial={RHYME_START}
      poster={{ ...RHYME_START, text: "the hat", strip: stripFor("the hat") }}
      script={async (a) => {
        await a.wait(700);
        await swap(a, "hat");
        await a.wait(1400);
        await swap(a, "mat");
        await a.wait(1400);
        await swap(a, "rat");
        await a.wait(2000);

        if (onDone) return onDone();
        await swap(a, "cat");
        await a.wait(1200);
      }}
    />
  );
}

// Numbers ---------------------------------------------------------------------------------------------------

const NUM_START: KeyboardState = { ...base, before: "we went to the farm", text: "and saw " };

/** 123: the digits wear their bead-stair colors, so 3 is pink and 5 light blue. */
export function NumberScene({ onDone }: { onDone?: () => void }) {
  return (
    <KeyboardStage
      label="On the 123 keys each digit has beads under it in its bead-stair color. A finger types 3."
      initial={NUM_START}
      poster={{ ...NUM_START, text: "and saw 3", layer: "numbers" }}
      script={async (a) => {
        await a.wait(500);
        await a.click("key-123");
        await a.set({ layer: "numbers" });
        await a.wait(700);
        await tap(a, "3");
        await a.wait(2400);

        if (onDone) return onDone();
        await a.click("key-delete");
        await a.set({ text: NUM_START.text });
        await a.wait(300);
        await a.click("key-123");
        await a.set({ layer: "letters" });
        await a.wait(600);
      }}
    />
  );
}

// Settings --------------------------------------------------------------------------------------------------

type SettingsState = { order: Order; cursive: boolean };

/** The app's settings: switch to cursive letters and QWERTY order, and the live keyboard above changes with them. */
export function SettingsScene() {
  const dark = useDark();
  const f = FRAMES.app;

  return (
    <Figure label="The Montessori Keyboard app’s settings: choosing cursive letters and QWERTY order changes the live keyboard at the top.">
      <Stage<SettingsState>
        width={f.wide.w}
        height={f.wide.h}
        compact={{ below: 560, width: f.compact.w, height: f.compact.h }}
        initial={{ order: "abc", cursive: false }}
        poster={{ order: "abc", cursive: true }}
        theme={dark ? "dark" : "light"}
        cursor={{ at: { x: f.wide.w / 2, y: f.wide.h - 40 }, style: "touch" }}
        className="mk-stage mk-stage--top"
        script={async (a) => {
          await a.wait(700);
          await a.click("seg-cursive");
          await a.set({ cursive: true });
          await a.wait(1600);
          await a.click("seg-qwerty");
          await a.set({ order: "qwerty" });
          await a.wait(2200);
          await a.click("seg-abc");
          await a.set({ order: "abc" });
          await a.wait(500);
          await a.click("seg-print");
          await a.set({ cursive: false });
          await a.wait(800);
        }}
      >
        {(s, _rect, layout) => (
          <Placed layout={layout} kind="app" pin="top">
            <div className="mk-app">
              <div className="mk-app-title">Settings</div>
              <div className="mk-preview">
                <Tray
                  width={SCREEN_W - 24 - 28}
                  order={s.order}
                  cursive={s.cursive}
                  noStrip
                  globe={false}
                  home={false}
                />
              </div>
              <div className="mk-group">Keyboard</div>
              <div className="mk-card">
                <div className="mk-srow">
                  Order
                  <Seg on={s.order === "abc" ? 0 : 1} a={["ABC", "abc"]} b={["QWERTY", "qwerty"]} />
                </div>
                <div className="mk-srow">
                  Letter shapes
                  <Seg on={s.cursive ? 1 : 0} a={["Print", "print"]} b={["Cursive", "cursive"]} />
                </div>
                <div className="mk-srow">
                  Capitals with shift
                  <span className="mk-toggle" />
                </div>
              </div>
            </div>
          </Placed>
        )}
      </Stage>
    </Figure>
  );
}

/** The app's two-way segmented control. */
function Seg({ on, a, b }: { on: 0 | 1; a: [string, string]; b: [string, string] }) {
  return (
    <span className="mk-seg" data-on={on}>
      <i aria-hidden="true" />
      <b data-target={`seg-${a[1]}`} data-active={on === 0 || undefined}>
        {a[0]}
      </b>
      <b data-target={`seg-${b[1]}`} data-active={on === 1 || undefined}>
        {b[0]}
      </b>
    </span>
  );
}
