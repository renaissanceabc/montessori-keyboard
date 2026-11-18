"use client";

import { useSyncExternalStore } from "react";

import { getTheme, setTheme, subscribeTheme, THEMES } from "@/lib/theme";

/** System, light or dark, as one row of buttons. */
export function ThemeSwitch() {
  const theme = useSyncExternalStore(subscribeTheme, getTheme, () => "system" as const);

  return (
    <div className="theme-switch" role="group" aria-label="Appearance">
      {THEMES.map((t) => (
        <button key={t.id} type="button" aria-pressed={theme === t.id} onClick={() => setTheme(t.id)}>
          {t.label}
        </button>
      ))}
    </div>
  );
}
