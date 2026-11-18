/** One page of the site: its address, its name in the sidebar and a line for search results. A page with `sections` lists them beneath it while you're on it. */
export type NavPage = {
  href: string;
  title: string;
  description: string;
  sections?: { id: string; title: string }[];
};

export const INSTALL_SECTIONS = [
  { id: "requirements", title: "Requirements" },
  { id: "get", title: "Get the app" },
  { id: "source", title: "Build from source" },
];

export const FEATURE_SECTIONS = [
  { id: "tiles", title: "The tiles" },
  { id: "phonograms", title: "Phonograms" },
  { id: "rhymes", title: "Word families" },
  { id: "numbers", title: "Numbers" },
  { id: "sounds", title: "Letter sounds" },
  { id: "app", title: "Companion app" },
];

/** The pages in the sidebar, in order. */
export const PAGES: NavPage[] = [
  {
    href: "/",
    title: "Overview",
    description:
      "A keyboard for iPhone and iPad that looks like a Montessori moveable alphabet: wooden tiles, lowercase print, blue vowels and red consonants.",
  },
  {
    href: "/install",
    title: "Install",
    description:
      "What you need, where to get Montessori Keyboard, and how to build it from source.",
    sections: INSTALL_SECTIONS,
  },
  {
    href: "/features",
    title: "Features",
    description:
      "Print or cursive tiles in QWERTY or ABC order, phonograms on a long press, word families in the strip, numbers in bead-stair colors, letter sounds, and the companion app with its settings.",
    sections: FEATURE_SECTIONS,
  },
  {
    href: "/privacy",
    title: "Privacy",
    description:
      "Montessori Keyboard collects nothing. No ads, no accounts, no analytics, and no network at all.",
  },
  {
    href: "/faq",
    title: "FAQ",
    description:
      "Answers about Montessori Keyboard: ages, cursive, capitals, sounds, iPad and Android, and what it costs.",
  },
];

/** Pages linked from the footer only. */
export const FOOTER_PAGES: NavPage[] = [
  {
    href: "/credits",
    title: "Credits",
    description:
      "The fonts Montessori Keyboard uses, Allo and Playwrite US Trad, the Montessori materials it is modelled on, and Stageshow, which draws the site's demos.",
  },
];

/** Every page, for the sitemap and metadata. */
export const ALL_PAGES = [...PAGES, ...FOOTER_PAGES];
