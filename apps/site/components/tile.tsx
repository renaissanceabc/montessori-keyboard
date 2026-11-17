import type { ReactNode } from "react";

import { isVowel } from "@/lib/keyboard";

/**
 * One wooden tile, drawn in CSS: maple in light mode, walnut in dark. A single letter
 * takes its color (blue vowel, red consonant); anything longer is a phonogram or word,
 * colored by its first letter unless `tone` says otherwise.
 */
export function Tile({
  children,
  tone,
  size = "md",
  className,
}: {
  children: ReactNode;
  tone?: "vowel" | "consonant" | "plain";
  size?: "sm" | "md" | "lg";
  className?: string;
}) {
  const t = tone ?? (typeof children === "string" && isVowel(children[0]) ? "vowel" : "consonant");

  return (
    <span className={["tile", `tile-${size}`, className].filter(Boolean).join(" ")} data-tone={t}>
      {children}
    </span>
  );
}

/** The site's mark: the a tile, beside the name. */
export function Wordmark() {
  return (
    <span className="wordmark">
      <span className="tile tile-mark" data-tone="vowel" aria-hidden="true">
        a
      </span>
      <span>Montessori Keyboard</span>
    </span>
  );
}
