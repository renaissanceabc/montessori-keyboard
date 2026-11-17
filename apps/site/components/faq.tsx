import type { ReactNode } from "react";

/** One question; the answer opens beneath it (a plain <details>, so it works without JavaScript). */
export function Question({ q, children }: { q: string; children: ReactNode }) {
  return (
    <details className="qa">
      <summary>
        <span>{q}</span>
        <svg width="12" height="12" viewBox="0 0 12 12" aria-hidden="true">
          <path
            d="M3 4.5 6 7.5 9 4.5"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.4"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      </summary>
      <div className="qa-answer">{children}</div>
    </details>
  );
}
