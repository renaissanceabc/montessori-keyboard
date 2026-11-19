"use client";

import { useEffect, useState, type ReactNode } from "react";

/** Set once the first page has hydrated: every page after it came from a navigation. */
let navigated = false;

/**
 * Remounts on each navigation, so the new page settles in (.page-in) while the sidebar opens its sections.
 * Not the page you land on: it paints at once (the server's HTML has no .page-in).
 */
export default function Template({ children }: { children: ReactNode }) {
  const [settle] = useState(() => navigated);

  useEffect(() => {
    navigated = true;
  }, []);

  return <div className={settle ? "page-in" : undefined}>{children}</div>;
}
