"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useLayoutEffect, useRef, useState, type CSSProperties } from "react";

import { ThemeSwitch } from "@/components/theme-switch";
import { PAGES, type NavPage } from "@/lib/nav";

/** The site's pages, kept in view. The page you're on opens its sections beneath it, and marks the one you're reading. */
export function Sidebar() {
  const pathname = usePathname();

  const isOn = (href: string) =>
    href === "/" ? pathname === "/" : pathname === href || pathname.startsWith(`${href}/`);

  return (
    <aside className="sidebar">
      <Link className="wordmark" href="/">
        <img className="wordmark-logo" src="/logo.png" width={32} height={32} alt="" />
        Montessori Keyboard
      </Link>
      <nav className="toc" aria-label="Site">
        <ul>
          {PAGES.map((p) => (
            <li key={p.href}>
              <Link
                href={p.href}
                className={isOn(p.href) ? "is-on" : undefined}
                aria-current={isOn(p.href) ? "page" : undefined}
              >
                {p.title}
              </Link>
              {p.sections && <Sections sections={p.sections} open={isOn(p.href)} />}
            </li>
          ))}
        </ul>
      </nav>
      <ThemeSwitch />
    </aside>
  );
}

/**
 * A page's sections on a track; the dark segment follows the section you're
 * reading. Always rendered, so it can grow open (and fold away) instead of
 * popping in when you arrive on the page.
 */
function Sections({
  sections,
  open,
}: {
  sections: NonNullable<NavPage["sections"]>;
  open: boolean;
}) {
  const current = useScrollSpy(
    sections.map((s) => s.id),
    open,
  );

  const list = useRef<HTMLUListElement>(null);
  const [bar, setBar] = useState<{ top: number; height: number } | null>(null);

  useLayoutEffect(() => {
    const a = list.current?.querySelector<HTMLElement>(`a[href$="#${current}"]`);

    if (a) setBar({ top: a.offsetTop, height: a.offsetHeight });
  }, [current]);

  return (
    <div className={`toc-reveal ${open ? "is-open" : ""}`} inert={!open}>
      <div>
        <ul className="toc-sections" ref={list}>
          {bar && (
            <i
              className="toc-bar"
              style={{ transform: `translateY(${bar.top}px) scaleY(${bar.height})` }}
              aria-hidden="true"
            />
          )}
          {sections.map((s, n) => (
            // SAFETY: `--i` is a CSS custom property, which React sets with style.setProperty.
            <li key={s.id} style={{ "--i": n } as CSSProperties}>
              <a
                href={`#${s.id}`}
                className={s.id === current ? "is-on" : undefined}
                aria-current={open && s.id === current ? "location" : undefined}
              >
                {s.title}
              </a>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

/**
 * The section you're reading: the last whose block has gone up past the logo
 * (the bottom of the sidebar's wordmark), or the last one once you've scrolled
 * to the bottom (short sections at the end never get that far). Sections are
 * looked up on each pass, since the page may arrive after the sidebar does.
 */
function useScrollSpy(ids: string[], on: boolean) {
  const [current, setCurrent] = useState(ids[0]);
  const key = ids.join(" ");
  // Spying starts over at the first section when it's turned on or the sections change.
  const spying = on ? key : null;
  const [spied, setSpied] = useState(spying);

  if (spying !== spied) {
    setSpied(spying);

    if (spying !== null) setCurrent(spying.split(" ")[0]);
  }

  useEffect(() => {
    if (!on) return;
    const all = key.split(" ");
    let frame = 0;

    const update = () => {
      frame = 0;

      const sections = all
        .map((id) => document.getElementById(id))
        .filter((el): el is HTMLElement => !!el);

      if (!sections.length) return;
      const doc = document.documentElement;
      const scrolled = window.scrollY > 0;
      const atEnd = scrolled && window.innerHeight + window.scrollY >= doc.scrollHeight - 2;

      const line =
        document.querySelector(".sidebar .wordmark")?.getBoundingClientRect().bottom ?? 68;

      const passed = sections.filter((s) => s.getBoundingClientRect().top <= line);
      const el = atEnd ? sections.at(-1) : (passed.at(-1) ?? sections[0]);

      if (el) setCurrent(el.id);
    };

    const onScroll = () => {
      if (!frame) frame = requestAnimationFrame(update);
    };

    onScroll();
    // A reload restores the scroll position after this first pass, without always firing scroll.
    window.addEventListener("load", onScroll);
    window.addEventListener("scroll", onScroll, { passive: true });
    window.addEventListener("resize", onScroll);

    return () => {
      window.removeEventListener("load", onScroll);
      window.removeEventListener("scroll", onScroll);
      window.removeEventListener("resize", onScroll);
      cancelAnimationFrame(frame);
    };
  }, [key, on]);

  return current;
}
