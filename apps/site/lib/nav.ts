/** One page of the site: its address, its name in the header and a line for search results. */
export type NavPage = { href: string; title: string; description: string };

/** The pages in the header, in order. */
export const PAGES: NavPage[] = [
  {
    href: "/",
    title: "Home",
    description:
      "A free iPhone keyboard for young children that looks like a Montessori moveable alphabet: wooden tiles, lowercase print, blue vowels and red consonants.",
  },
  {
    href: "/guide",
    title: "Set up",
    description:
      "How to turn on Montessori Keyboard in Settings, switch to it with the globe key, and what Allow Full Access does.",
  },
  {
    href: "/faq",
    title: "FAQ",
    description:
      "Answers about Montessori Keyboard: ages, cursive, capitals, sounds, iPad and Android, and what it costs.",
  },
  {
    href: "/privacy",
    title: "Privacy",
    description:
      "Montessori Keyboard collects nothing. No ads, no accounts, no analytics, and no network at all.",
  },
];

/** Pages linked from the footer only. */
export const FOOTER_PAGES: NavPage[] = [
  {
    href: "/credits",
    title: "Credits",
    description:
      "The fonts Montessori Keyboard uses, Allo and Playwrite US Trad, and the Montessori materials it is modelled on.",
  },
];

/** Every page, for the sitemap and metadata. */
export const ALL_PAGES = [...PAGES, ...FOOTER_PAGES];
