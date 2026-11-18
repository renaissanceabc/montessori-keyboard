import type { CSSProperties, ReactNode } from "react";

import { BEADS_BY_DIGIT, isVowel, ROWS, type Order } from "@/lib/keyboard";

/*
 * The keyboard as the app draws it, at true iOS points, for the demos on the
 * site's phones: the strip, the ten-tile grid (KeyRow in Keys.swift), the
 * function keys and the phonogram popup. Nothing here is interactive: a demo's
 * script decides what's pressed, held and typed, and names each part with
 * data-target so its pointer can find it.
 */

/** The strip above the tiles: up to three rhymes for the word being typed, or blank. */
export type Strip = string[];

export type TrayProps = {
  /** The keyboard's width in points: the phone screen's (402), or less in the app's settings preview. */
  width: number;
  order?: Order;
  cursive?: boolean;
  layer?: "letters" | "numbers";
  strip?: Strip;
  /** No strip row at all (the settings preview), rather than an empty one. */
  noStrip?: boolean;
  /** The key a finger is on: it sinks, and a letter lifts a larger copy above the finger. */
  down?: string | null;
  /** The phonogram popup over a held letter: the letter, then its teams; `chosen` is lit. */
  popup?: { letter: string; choices: string[]; chosen: number | null } | null;
  /** The globe key: the real keyboard has it, the settings preview doesn't. */
  globe?: boolean;
  /** Draw the home indicator's strip under the keys (the keyboard at the foot of a screen). */
  home?: boolean;
  className?: string;
};

const GAP = 6;
const ROW_H = 46;
const ROW_GAP = 11;
const STRIP_H = 44;

/** A word in tile colors: blue vowels, red consonants. */
export function Colored({ word }: { word: string }) {
  return (
    <>
      {[...word].map((ch, i) => (
        <span key={i} className={isVowel(ch.toLowerCase()) ? "mk-v" : "mk-c"}>
          {ch}
        </span>
      ))}
    </>
  );
}

type Key = {
  id: string;
  w?: number;
  node: ReactNode;
  kind: "letter" | "fn" | "digit" | "mark";
  letter?: string;
};

/** Lays a row on the app's ten-tile grid: tiles one unit wide, wider keys in units, the row centered. */
function layout(width: number, keys: Key[]) {
  const W = width - 6;
  const weights = keys.map((k) => k.w ?? 1);
  const gaps = GAP * (keys.length - 1);
  const sum = weights.reduce((a, b) => a + b, 0);
  let unit = (W - GAP * 9) / 10;

  if (sum * unit + gaps > W) unit = (W - gaps) / sum;
  let x = 3 + (W - (sum * unit + gaps)) / 2;

  return keys.map((k, i) => {
    const w = weights[i] * unit;
    const at = { ...k, x, w };
    x += w + GAP;

    return at;
  });
}

const ICONS = {
  shift: (
    <svg
      width="22"
      height="22"
      viewBox="0 0 20 20"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.6"
      strokeLinejoin="round"
    >
      <path d="M10 3 3 10.5h4V17h6v-6.5h4Z" />
    </svg>
  ),
  delete: (
    <svg
      width="25"
      height="19"
      viewBox="0 0 24 18"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.6"
      strokeLinejoin="round"
      strokeLinecap="round"
    >
      <path d="M8 2h13a1.5 1.5 0 0 1 1.5 1.5v11A1.5 1.5 0 0 1 21 16H8L1.5 9Z" />
      <path d="m11.5 6 6 6m0-6-6 6" />
    </svg>
  ),
  return: (
    <svg
      width="22"
      height="18"
      viewBox="0 0 22 18"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.7"
      strokeLinejoin="round"
      strokeLinecap="round"
    >
      <path d="M19 2v7a2 2 0 0 1-2 2H4" />
      <path d="m8 6.5-4.5 4.5L8 15.5" />
    </svg>
  ),
  globe: (
    <svg
      width="20"
      height="20"
      viewBox="0 0 20 20"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.5"
    >
      <circle cx="10" cy="10" r="8" />
      <ellipse cx="10" cy="10" rx="3.6" ry="8" />
      <path d="M2 10h16M3.5 5.5h13M3.5 14.5h13" />
    </svg>
  ),
};

/** The quantity under a digit: its beads, in the bead stair's color. */
function Beads({ n }: { n: number }) {
  const color = BEADS_BY_DIGIT[n];

  if (!color) return null;

  return (
    <span
      className="mk-beads"
      style={{ gridTemplateColumns: `repeat(${Math.min(n, 5)}, 4px)` }}
      aria-hidden="true"
    >
      {Array.from({ length: n }, (_, i) => (
        <i key={i} style={{ background: color }} data-pale={n === 7 || undefined} />
      ))}
    </span>
  );
}

function rows(order: Order, layer: "letters" | "numbers", globe: boolean): Key[][] {
  const out: Key[][] = [];
  const fw = order === "abc" ? 1 : 1.45;

  if (layer === "letters") {
    ROWS[order].forEach((letters, i) => {
      const keys: Key[] = letters.map((l) => ({ id: l, kind: "letter", letter: l, node: l }));

      if (i === 2) {
        keys.unshift({ id: "shift", w: fw, kind: "fn", node: ICONS.shift });
        keys.push({ id: "delete", w: fw, kind: "fn", node: ICONS.delete });
      }
      out.push(keys);
    });
  } else {
    out.push(
      [1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((d) => ({
        id: String(d),
        kind: "digit",
        node: (
          <>
            <span>{d}</span>
            <Beads n={d} />
          </>
        ),
      })),
    );
    out.push([..."-/:;()$&@"].map((s) => ({ id: s, kind: "mark", node: s })));
    out.push([
      ...[...".,?!'"].map((s): Key => ({ id: s, w: 1.4, kind: "mark", node: s })),
      { id: "delete", w: 1.45, kind: "fn", node: ICONS.delete },
    ]);
  }

  out.push([
    { id: "123", w: globe ? 1.5 : 2.3, kind: "fn", node: layer === "letters" ? "123" : "abc" },
    ...(globe ? [{ id: "globe", w: 1.2, kind: "fn" as const, node: ICONS.globe }] : []),
    { id: "space", w: globe ? 4.6 : 5, kind: "fn", node: "space" },
    { id: "return", w: globe ? 2 : 2.3, kind: "fn", node: ICONS.return },
  ]);

  return out;
}

/** Where the phonogram popup sits over the held key (PopupLayout in PhonogramPopup.swift). */
function popupLayout(anchor: { x: number; y: number; w: number }, count: number, width: number) {
  const chip = { w: 38, h: 44 };
  const gap = 5;
  const inset = 6;
  const margin = 4;
  const room = (width - 2 * margin - 2 * inset - (count - 1) * gap) / count;
  const cw = Math.min(chip.w, room);
  const w = count * cw + (count - 1) * gap + 2 * inset;
  const h = chip.h + 2 * inset + 2;
  const x = Math.min(
    Math.max(anchor.x + anchor.w / 2 - inset - cw / 2, margin),
    width - margin - w,
  );
  const y = Math.max(anchor.y - 4 - h, 0);

  // Where the held key's middle falls in the popup, so it grows out of the key, not its own corner.
  const ox = anchor.x + anchor.w / 2 - x;

  return { x, y, w, h, ox, cw, chipH: chip.h, inset, gap };
}

export function Tray({
  width,
  order = "qwerty",
  cursive = false,
  layer = "letters",
  strip = [],
  noStrip = false,
  down = null,
  popup = null,
  globe = true,
  home = true,
  className,
}: TrayProps) {
  const grid = rows(order, layer, globe).map((r) => layout(width, r));
  const top = noStrip ? 0 : STRIP_H;
  const rowsH = grid.length * ROW_H + (grid.length + 1) * ROW_GAP;
  const height = top + rowsH + (home ? 34 : 0);

  // The popup sits over the held key, in the keyboard's own space (it can't draw above the keyboard's top).
  let pop: ReturnType<typeof popupLayout> | null = null;

  if (popup) {
    grid.forEach((r, ri) =>
      r.forEach((k) => {
        if (k.id === popup.letter) {
          pop = popupLayout(
            { x: k.x, y: top + ROW_GAP + ri * (ROW_H + ROW_GAP), w: k.w },
            popup.choices.length,
            width,
          );
        }
      }),
    );
  }

  const p = pop as ReturnType<typeof popupLayout> | null;

  return (
    <div
      className={["mk-tray", className].filter(Boolean).join(" ")}
      data-cursive={cursive || undefined}
      style={{ width, height } as CSSProperties}
    >
      {!noStrip && (
        <div className="mk-strip" data-target="strip">
          {strip.length > 0 &&
            [0, 1, 2].map((i) => {
              const w = strip[i];

              return (
                <span key={w ?? `blank-${i}`} className="mk-slot" data-target={w && `chip-${w}`}>
                  {w && <Colored word={w} />}
                </span>
              );
            })}
        </div>
      )}
      {grid.map((r, ri) => (
        <div key={ri} className="mk-row" style={{ top: top + ROW_GAP + ri * (ROW_H + ROW_GAP) }}>
          {r.map((k) => (
            <span
              key={k.id}
              className={`mk-key mk-${k.kind}`}
              data-target={`key-${k.id}`}
              data-tone={k.letter ? (isVowel(k.letter) ? "v" : "c") : undefined}
              data-down={down === k.id || undefined}
              data-letter={k.kind === "letter" && !popup ? k.letter : undefined}
              style={{ left: k.x, width: k.w }}
            >
              <span className="mk-face">{k.node}</span>
            </span>
          ))}
        </div>
      ))}
      {p && popup && (
        <div
          className="mk-popup"
          style={{
            left: p.x,
            top: p.y,
            width: p.w,
            height: p.h,
            transformOrigin: `${p.ox}px 100%`,
          }}
        >
          {popup.choices.map((c, i) => (
            <span
              key={c}
              className="mk-pchip"
              data-target={`pop-${i}`}
              data-on={popup.chosen === i || undefined}
              style={{
                left: p.inset + i * (p.cw + p.gap),
                top: p.inset,
                width: p.cw,
                height: p.chipH,
              }}
            >
              <Colored word={c} />
            </span>
          ))}
        </div>
      )}
      {home && <div className="mk-home" style={{ top: top + rowsH }} />}
    </div>
  );
}

/** The tray's height in points, for laying out the screen above it. */
export function trayHeight({
  noStrip = false,
  home = true,
}: { noStrip?: boolean; home?: boolean } = {}) {
  return (noStrip ? 0 : STRIP_H) + 4 * ROW_H + 5 * ROW_GAP + (home ? 34 : 0);
}
