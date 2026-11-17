import type { ReactNode } from "react";

/**
 * A link off the site: opens in a new tab (without handing it this page), and says
 * so, with a small arrow and, for screen readers, in words.
 */
export function ExternalLink({
  href,
  className,
  arrow = true,
  children,
}: {
  href: string;
  className?: string;
  arrow?: boolean;
  children: ReactNode;
}) {
  return (
    <a href={href} className={className} target="_blank" rel="noopener noreferrer">
      {children}
      {arrow && (
        <svg className="ext-arrow" width="10" height="10" viewBox="0 0 10 10" aria-hidden="true">
          <path
            d="M3 7 7 3M3.6 3H7v3.4"
            fill="none"
            stroke="currentColor"
            strokeWidth="1.4"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      )}
      <span className="sr-only"> (opens in a new tab)</span>
    </a>
  );
}
