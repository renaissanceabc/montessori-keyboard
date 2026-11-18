"use client";

import { useEffect, useLayoutEffect, useRef, useState } from "react";

import { PHONOGRAMS, rhymesFor, type Order } from "@/lib/keyboard";

import { Tray, trayHeight } from "./tray";

/** The tray's width in points: an iPhone's (Stageshow's iPhone, as on the demos). */
const WIDTH = 402;
/** How long a finger rests on a tile before its letter teams open (the app's long press). */
const HOLD_MS = 450;
/** How much fits on the line being typed before it moves up. */
const LINE = 22;

/**
 * Montessori Keyboard to try, on Overview: the same tray the demos draw, with real buttons. Tap the
 * tiles to type, hold one for its letter teams, tap a rhyme to swap it in, and 123 for the bead
 * keys. QWERTY or ABC and print or cursive switch underneath, as in the companion app.
 */
export function LiveKeyboard() {
  const [before, setBefore] = useState("we went to the farm");
  const [text, setText] = useState("the cat");
  const [order, setOrder] = useState<Order>("abc");
  const [cursive, setCursive] = useState(false);
  const [layer, setLayer] = useState<"letters" | "numbers">("letters");
  const [caps, setCaps] = useState(false);
  const [popup, setPopup] = useState<{ letter: string; choices: string[] } | null>(null);

  // A hold opens the teams, and the tap that ends it doesn't type the letter too.
  const timer = useRef(0);
  const held = useRef(false);
  useEffect(() => () => window.clearTimeout(timer.current), []);

  // The tray keeps its true size and scales down to fit a narrow column.
  const box = useRef<HTMLDivElement>(null);
  const [scale, setScale] = useState(1);
  useLayoutEffect(() => {
    const el = box.current;

    if (!el) return;
    const fit = () => setScale(Math.min(1, el.clientWidth / WIDTH));
    fit();
    const ro = new ResizeObserver(fit);
    ro.observe(el);

    return () => ro.disconnect();
  }, []);

  const type = (s: string) => {
    setPopup(null);
    const next = text + s;

    if (next.length <= LINE) return setText(next);
    setBefore(text.trimEnd());
    setText(s.trimStart());
  };

  const onKey = (id: string) => {
    if (held.current) {
      held.current = false;

      return;
    }

    switch (id) {
      case "shift":
        return setCaps((c) => !c);
      case "delete":
        setPopup(null);

        return setText((t) => t.slice(0, -1));
      case "123":
        return setLayer((l) => (l === "letters" ? "numbers" : "letters"));
      case "space":
        return type(" ");
      case "return":
        setPopup(null);
        setBefore(text);

        return setText("");
      default:
        if (id.length === 1 && /[a-z]/.test(id) && caps) {
          setCaps(false);

          return type(id.toUpperCase());
        }

        return type(id);
    }
  };

  const word = text.split(" ").at(-1) ?? "";

  return (
    <figure className="mk-live">
      <div className="mk-live-card">
        <div className="mk-live-page" aria-live="polite">
          <span className="sr-only">Typed so far: </span>
          <div className="mk-note-line">{before}</div>
          <div className="mk-note-line">
            {text}
            <span className="mk-caret" aria-hidden="true" />
          </div>
        </div>
        <div
          ref={box}
          className="mk-live-fit"
          style={{ height: trayHeight({ home: false }) * scale }}
        >
          <div style={{ transform: `scale(${scale})`, transformOrigin: "0 0", width: WIDTH }}>
            <Tray
              width={WIDTH}
              order={order}
              cursive={cursive}
              shifted={caps}
              layer={layer}
              strip={layer === "letters" ? rhymesFor(word) : []}
              popup={popup && { ...popup, chosen: null }}
              globe={false}
              home={false}
              live={{
                onKey,
                onDown: (id) => {
                  window.clearTimeout(timer.current);
                  const teams = PHONOGRAMS[id];

                  if (!teams || layer !== "letters") return;
                  timer.current = window.setTimeout(() => {
                    held.current = true;
                    setPopup({ letter: id, choices: [id, ...teams] });
                  }, HOLD_MS);
                },
                onUp: () => window.clearTimeout(timer.current),
                onWord: (w) => {
                  setPopup(null);
                  setText((t) => t.replace(/\S*$/, w));
                },
                onPick: (team) => {
                  held.current = false;
                  type(team);
                },
              }}
            />
          </div>
        </div>
      </div>
      <div className="mk-live-controls">
        <Choice
          label="Order"
          value={order}
          options={[
            ["abc", "ABC"],
            ["qwerty", "QWERTY"],
          ]}
          onChange={(v) => {
            setOrder(v);
            setPopup(null);
          }}
        />
        <Choice
          label="Letters"
          value={cursive ? "cursive" : "print"}
          options={[
            ["print", "Print"],
            ["cursive", "Cursive"],
          ]}
          onChange={(v) => setCursive(v === "cursive")}
        />
      </div>
    </figure>
  );
}

/** Two options side by side, like the companion app's settings. */
function Choice<T extends string>({
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
    <fieldset className="stage-tabs" aria-label={label}>
      {options.map(([v, text]) => (
        <button key={v} type="button" aria-pressed={value === v} onClick={() => onChange(v)}>
          {text}
        </button>
      ))}
    </fieldset>
  );
}
