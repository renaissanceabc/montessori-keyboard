"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

import { Wordmark } from "@/components/tile";
import { PAGES } from "@/lib/nav";

/** The wordmark and the pages, with the one you're on marked. */
export function SiteHeader() {
  const path = usePathname();

  return (
    <header className="site-header">
      <Link href="/" className="home-link" aria-label="Montessori Keyboard, home">
        <Wordmark />
      </Link>
      <nav aria-label="Pages">
        <ul>
          {PAGES.filter((p) => p.href !== "/").map((p) => (
            <li key={p.href}>
              <Link href={p.href} aria-current={path === p.href ? "page" : undefined}>
                {p.title}
              </Link>
            </li>
          ))}
        </ul>
      </nav>
    </header>
  );
}
