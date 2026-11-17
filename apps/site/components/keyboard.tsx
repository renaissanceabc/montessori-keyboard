"use client";

import { useState } from "react";

import { BEADS, familyFor, isVowel, ROWS, type Letters, type Order } from "@/lib/keyboard";

/**
 * The keyboard, drawn in HTML and CSS: a tray of wooden tiles under a word-family
 * strip, with a line above to type into. Tap the tiles to type, a word in the strip
 * to swap it in, and 123 for the number keys in bead-stair colors. QWERTY or ABC and
 * print or cursive switch below, as in the app's settings.
 */
export function Keyboard() {
  const [text, setText] = useState("the cat");
  const [order, setOrder] = useState<Order>("qwerty");
  const [letters, setLetters] = useState<Letters>("print");
  const [numbers, setNumbers] = useState(false);

  const lastWord = text.split(" ").at(-1) ?? "";
  const family = familyFor(lastWord);

  const type = (s: string) => setText((t) => (t + s).slice(-24));
  const back = () => setText((t) => t.slice(0, -1));
  const swap = (word: string) =>
    setText((t) => {
      const words = t.split(" ");
      words[words.length - 1] = word;
      return words.join(" ");
    });

  return (
    <figure className="kb" data-letters={letters}>
      <div className="kb-page">
        <span className="sr-only">Typed so far: </span>
        <output aria-live="polite">{text}</output>
        <span className="kb-caret" aria-hidden="true" />
      </div>

      <div className="tray" role="group" aria-label="Montessori Keyboard">
        <div className="strip" role="group" aria-label="Word family">
          {family.map((w) => (
            <button
              key={w}
              type="button"
              className="strip-word"
              data-current={w === lastWord || undefined}
              onClick={() => swap(w)}
            >
              {w}
            </button>
          ))}
        </div>

        {numbers ? (
          <NumberRows type={type} />
        ) : (
          ROWS[order].map((row, i) => (
            <div className="kb-row" key={i}>
              {row.map((l) => (
                <button
                  key={l}
                  type="button"
                  className="key"
                  data-tone={isVowel(l) ? "vowel" : "consonant"}
                  aria-label={l}
                  onClick={() => type(l)}
                >
                  {l}
                </button>
              ))}
              {i === 2 && (
                <button type="button" className="key key-wide key-plain" onClick={back}>
                  <span className="sr-only">Delete</span>
                  <svg width="20" height="14" viewBox="0 0 20 14" aria-hidden="true">
                    <path
                      d="M6 1h12a1 1 0 0 1 1 1v10a1 1 0 0 1-1 1H6L1 7Z M9.5 4.5l5 5m0-5-5 5"
                      fill="none"
                      stroke="currentColor"
                      strokeWidth="1.5"
                      strokeLinejoin="round"
                      strokeLinecap="round"
                    />
                  </svg>
                </button>
              )}
            </div>
          ))
        )}

        <div className="kb-row">
          <button
            type="button"
            className="key key-wide key-plain key-small"
            aria-pressed={numbers}
            onClick={() => setNumbers((n) => !n)}
          >
            {numbers ? "abc" : "123"}
          </button>
          <button type="button" className="key key-space key-plain" onClick={() => type(" ")}>
            <span className="sr-only">Space</span>
          </button>
          <button type="button" className="key key-wide key-plain key-small" onClick={() => type(". ")}>
            .
            <span className="sr-only"> (full stop)</span>
          </button>
        </div>
      </div>

      <div className="kb-controls">
        <Segmented
          label="Order"
          value={order}
          options={[
            ["qwerty", "QWERTY"],
            ["abc", "ABC"],
          ]}
          onChange={(v) => {
            setOrder(v);
            setNumbers(false);
          }}
        />
        <Segmented
          label="Letters"
          value={letters}
          options={[
            ["print", "print"],
            ["cursive", "cursive"],
          ]}
          onChange={setLetters}
        />
      </div>
    </figure>
  );
}

/** The 123 layer: 1 to 9 and 0, each with its bead's color beneath the digit. */
function NumberRows({ type }: { type: (s: string) => void }) {
  const digits = [...BEADS.slice(0, 9), { n: 0, name: "", color: "" }];

  return (
    <>
      <div className="kb-row">
        {digits.map((b) => (
          <button
            key={b.n}
            type="button"
            className="key key-number"
            aria-label={b.name ? `${b.n}, ${b.name} bead` : `${b.n}`}
            onClick={() => type(String(b.n))}
          >
            {b.n}
            {b.color && <span className="bead" style={{ background: b.color }} aria-hidden="true" />}
          </button>
        ))}
      </div>
      <div className="kb-row">
        {["+", "-", "=", "?", "!", ","].map((s) => (
          <button key={s} type="button" className="key key-plain" onClick={() => type(s)}>
            {s}
          </button>
        ))}
      </div>
      <div className="kb-row kb-row-spacer" aria-hidden="true" />
    </>
  );
}

/** Two options side by side, like the app's settings. */
function Segmented<T extends string>({
  label,
  value,
  options,
  onChange,
}: {
  label: string;
  value: T;
  options: [T, string][];
  onChange: (v: T) => void;
}) {
  return (
    <div className="segmented" role="radiogroup" aria-label={label}>
      {options.map(([v, text]) => (
        <button
          key={v}
          type="button"
          role="radio"
          aria-checked={value === v}
          onClick={() => onChange(v)}
        >
          {text}
        </button>
      ))}
    </div>
  );
}
