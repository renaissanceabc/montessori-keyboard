# montessorikeyboard.com

Montessori Keyboard's website: a static Next.js site (`output: "export"`), so `next build` writes plain HTML to `out/` that any host can serve. It follows the layout of Galley's site: a sidebar of pages and one column of text, with the product drawn in code. It asks no other host for anything: the fonts, and the keyboards drawn on its phones, are all served by the site.

```bash
bun run --cwd apps/site dev        # http://localhost:3020
bun run --cwd apps/site build      # static HTML in out/
bun run --cwd apps/site typecheck  # next typegen, then tsc
bun run --cwd apps/site test       # vitest: the sitemap and the keyboard's data
```

| Path                              | What it is                                                                                                                                           |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `site.config.ts`                  | The domain, the App Store link and whether it's live, GitHub, Renaissance, the support email                                                         |
| `lib/nav.ts`                      | Every page with its title, description and sections, in sidebar order; the footer's pages                                                            |
| `lib/meta.ts`                     | Each page's metadata, from the nav                                                                                                                   |
| `lib/keyboard.ts`                 | The rows (QWERTY and ABC), vowels, phonograms, word families and bead-stair colors, as the app has them                                              |
| `lib/fonts.ts`                    | Allo (the `allo-font` package) and Playwrite US Trad (`@fontsource`), through `next/font/local`                                                      |
| `components/sidebar.tsx`          | The wordmark and the pages; the page you're on lists its sections and marks the one you're reading                                                   |
| `components/demos/`               | The phones: `tray.tsx` draws the keyboard at true iOS points (the app's Keys.swift geometry), `scenes.tsx` the scenes, `demos.css` the app's palette |
| `components/stageshow/`           | The parts of Stageshow (MIT, Benji Taylor) the scenes use: the stage, its script and cursor, the phone                                               |
| `components/stage-figure.tsx`     | Overview's figure: the scenes one after another, with tabs                                                                                           |
| `app/`                            | One folder per page: Overview (`page.tsx`), `install`, `features`, `privacy`, `faq`, `credits`                                                       |
| `app/globals.css`                 | Every style, with the palette as tokens on `:root` (maple) and in the dark-mode block (walnut)                                                       |
| `app/robots.ts`, `app/sitemap.ts` | robots.txt and sitemap.xml, built from the nav                                                                                                       |
| `vercel.json`                     | Security headers (a CSP that allows only this site), caching for the icons, the old `/guide` redirect, and the ignore step                           |
| `scripts/ignore-build.sh`         | Vercel's Ignored Build Step: deploys only when the site changed (see below)                                                                          |

The icons (`app/icon.png`, `app/apple-icon.png`, `app/favicon.ico`) come from `scripts/icons.py` (`bun run icons`); Next picks the files up by name.

## Deploys

Vercel builds only when the site changed. Before installing, it runs `scripts/ignore-build.sh` (`ignoreCommand` in `vercel.json`), which asks `turbo query affected` whether the site's `build` task is affected since the branch's last deployment (`VERCEL_GIT_PREVIOUS_SHA`, or the parent commit on a branch's first deploy). The root `turbo.json` turns on `affectedUsingTaskInputs`, so that is decided by `build`'s `inputs` in `turbo.json` here:

- **Builds:** anything under `apps/site` except the exclusions below, a lockfile change to a package the site uses, and the root `turbo.json`.
- **Skips:** `apps/ios`, `docs/`, `.github/`, root notes and scripts, and in `apps/site` the tests, `vitest.config.ts`, `scripts/` and Markdown.

`typecheck` runs after `build` (not before), so a test-only change never pulls `build` in; `next build` type-checks the site itself. If the check fails or the previous commit isn't in Vercel's shallow clone, it builds. A new file that ends up in the deployed site but isn't under `apps/site` needs adding to `build`'s `inputs` (as `$TURBO_ROOT$/path`). To deploy anyway, redeploy from the Vercel dashboard.

## Design decisions

- **The product is the picture.** The demos are drawn in code, not screenshots: a phone with the keyboard up, where a finger types, holds a tile for its phonograms, swaps in a rhyme and opens 123. They're built with Stageshow (`components/stageshow`); its rules for framing and motion are in Galley's `.claude/skills/stageshow`. The phone runs off the top of the frame so the crop falls in the note and the tray is whole; each scene has a `compact` design for a phone-width column, and shows a still under reduced motion.
- **Galley's layout.** A sticky sidebar of pages (a bar across the top on a phone), one 600px column, sections under a small heading and a hairline.
- **The moveable alphabet's palette.** Maple tiles (`#F8E7C9` to `#F0D8B0`, a `#CDAA78` edge) on a `#EADBC0` tray, on warm paper (`#FBF8F2`). Vowels `#1650B0`, consonants `#B3141A`. Dark mode is walnut, with sky-blue vowels and coral consonants, the same as the app.
- **Allo** for everything, the font the print tiles use, with its single-storey a, tailed l and serifed I on. Playwrite US Trad only for cursive.
- **Accessible.** Real headings, a skip link, a visible focus ring, and each demo is one image with a description of what it shows. Under `prefers-reduced-motion` the demos hold a still frame and the caret stops blinking.
- **Nothing collected.** No cookies, analytics or third-party requests, matching the app's privacy policy.

To publish the App Store link, set `appStoreUrl` and `appStoreLive: true` in `site.config.ts`.
