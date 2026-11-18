import "./globals.css";
import type { Metadata, Viewport } from "next";
import Link from "next/link";

import { ExternalLink } from "@/components/external-link";
import { Sidebar } from "@/components/sidebar";
import { allo, playwrite } from "@/lib/fonts";
import { HOME_TITLE } from "@/lib/meta";
import { THEME_SCRIPT } from "@/lib/theme";

import { site } from "../site.config";

export const metadata: Metadata = {
  metadataBase: new URL(site.url),
  title: { default: HOME_TITLE, template: `%s · ${site.name}` },
  description:
    "An iPhone and iPad keyboard for young children that looks like a Montessori moveable alphabet: wooden tiles, lowercase print, blue vowels and red consonants.",
  applicationName: site.name,
  openGraph: {
    title: HOME_TITLE,
    description:
      "Wooden tiles, lowercase print, blue vowels and red consonants. Open source, and nothing leaves the phone.",
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
    <html lang="en" data-scroll-behavior="smooth" className={`${allo.variable} ${playwrite.variable}`}
      suppressHydrationWarning
    >
      <head>
        <script dangerouslySetInnerHTML={{ __html: THEME_SCRIPT }} />
      </head>
      <body>
        <a className="skip" href="#content">
          Skip to content
        </a>
        <div className="layout">
          <Sidebar />
          <main className="content" id="content" tabIndex={-1}>
            {children}
            <footer className="footer">
              Made by{" "}
              <ExternalLink href={site.author.url} arrow={false}>
                {site.author.name}
              </ExternalLink>{" "}
              via{" "}
              <ExternalLink href={site.maker.url} arrow={false}>
                {site.maker.name}
              </ExternalLink>
              . Open source · <Link href="/credits">Credits</Link> ·{" "}
              <ExternalLink href={site.githubUrl} arrow={false}>
                GitHub
              </ExternalLink>
            </footer>
          </main>
        </div>
      </body>
    </html>
  );
}
