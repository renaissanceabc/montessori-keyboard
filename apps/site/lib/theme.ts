/**
 * The look: the system's, or one pinned in the footer's switcher. A pinned look
 * is kept in this browser (localStorage) and set as `data-theme` on <html>,
 * which the CSS tokens read. Nothing leaves the device.
 */
export type Theme = "system" | "light" | "dark";

export const THEMES: { id: Theme; label: string }[] = [
  { id: "system", label: "System" },
  { id: "light", label: "Light" },
  { id: "dark", label: "Dark" },
];

const KEY = "theme";
const EVENT = "themechange";
const DARK = "(prefers-color-scheme: dark)";

/** Runs in <head> before the page paints, so a pinned look never flashes the other one. */
export const THEME_SCRIPT = `try{var t=localStorage.getItem("${KEY}");if(t==="light"||t==="dark")document.documentElement.dataset.theme=t}catch(e){}`;

export function getTheme(): Theme {
  const t = document.documentElement.dataset.theme;

  return t === "light" || t === "dark" ? t : "system";
}

export function setTheme(theme: Theme) {
  const root = document.documentElement;

  if (theme === "system") delete root.dataset.theme;
  else root.dataset.theme = theme;

  try {
    if (theme === "system") localStorage.removeItem(KEY);
    else localStorage.setItem(KEY, theme);
  } catch {
    // Storage blocked: the look still changes for this visit.
  }

  window.dispatchEvent(new Event(EVENT));
}

/** Calls back when the pinned look or the system's changes. */
export function subscribeTheme(change: () => void) {
  const mq = window.matchMedia(DARK);
  mq.addEventListener("change", change);
  window.addEventListener(EVENT, change);

  return () => {
    mq.removeEventListener("change", change);
    window.removeEventListener(EVENT, change);
  };
}

/** Whether the page is walnut right now. */
export function isDark() {
  const t = getTheme();

  return t === "system" ? window.matchMedia(DARK).matches : t === "dark";
}
