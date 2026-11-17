import "./globals.css";
import type { Metadata, Viewport } from "next";
import Link from "next/link";

import { ExternalLink } from "@/components/external-link";
import { SiteHeader } from "@/components/site-header";
import { andika, playwrite } from "@/lib/fonts";
import { HOME_TITLE } from "@/lib/meta";

import { site } from "../site.config";

export const metadata: Metadata = {
  metadataBase: new URL(site.url),
  title: { default: HOME_TITLE, template: `%s · ${site.name}` },
  description:
    "A free iPhone keyboard for young children that looks like a Montessori moveable alphabet: wooden tiles, lowercase print, blue vowels and red consonants.",
  applicationName: site.name,
  openGraph: {
    title: HOME_TITLE,
    description:
      "Wooden tiles, lowercase print, blue vowels and red consonants. Free, open source, and nothing leaves the phone.",
    siteName: site.name,
    type: "website",
  },
};

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: light)", color: "#FBF8F2" },
    { media: "(prefers-color-scheme: dark)", color: "#14100C" },
  ],
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en" className={`${andika.variable} ${playwrite.variable}`}>
      <body>
        <a className="skip" href="#content">
          Skip to content
        </a>
        <SiteHeader />
        <main className="content" id="content" tabIndex={-1}>
          {children}
        </main>
        <footer className="footer">
          <p>
            Free and open source. Made by{" "}
            <ExternalLink href={site.maker.url} arrow={false}>
              {site.maker.name}
            </ExternalLink>
            .
          </p>
          <nav aria-label="More">
            <Link href="/privacy">Privacy</Link>
            <Link href="/credits">Credits</Link>
            <ExternalLink href={site.githubUrl} arrow={false}>
              GitHub
            </ExternalLink>
          </nav>
        </footer>
      </body>
    </html>
  );
}
