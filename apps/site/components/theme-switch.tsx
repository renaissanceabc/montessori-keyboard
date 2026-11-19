"use client";

import { useSyncExternalStore, type ReactNode } from "react";

import { getTheme, setTheme, subscribeTheme, THEMES, type Theme } from "@/lib/theme";

/** 16px line icons in the text color: a screen for the system's look, a sun, a moon. */
const ICONS: Record<Theme, ReactNode> = {
  system: (
    <>
      <rect x="2.5" y="3" width="11" height="8" rx="1.5" />
      <path d="M6 13.5h4M8 11v2.5" />
    </>
  ),
  light: (
    <>
      <circle cx="8" cy="8" r="2.75" />
      <path d="M8 1.75v1.5M8 12.75v1.5M1.75 8h1.5M12.75 8h1.5M3.58 3.58l1.06 1.06M11.36 11.36l1.06 1.06M3.58 12.42l1.06-1.06M11.36 4.64l1.06-1.06" />
    </>
  ),
  dark: <path d="M13.25 9.6A5.5 5.5 0 0 1 6.4 2.75a5.5 5.5 0 1 0 6.85 6.85Z" />,
};

/** System, light or dark, as a row of three icon buttons. */
export function ThemeSwitch() {
  const theme = useSyncExternalStore(subscribeTheme, getTheme, () => "system" as const);

  return (
    <div className="theme-switch" role="group" aria-label="Appearance">
      {THEMES.map((t) => (
        <button
          key={t.id}
          type="button"
          aria-label={t.label}
          title={t.label}
          aria-pressed={theme === t.id}
          onClick={() => setTheme(t.id)}
        >
          <svg
            viewBox="0 0 16 16"
            width="16"
            height="16"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.4"
            strokeLinecap="round"
            strokeLinejoin="round"
            aria-hidden="true"
          >
            {ICONS[t.id]}
          </svg>
        </button>
      ))}
    </div>
  );
}
