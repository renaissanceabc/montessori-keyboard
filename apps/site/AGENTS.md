<!-- BEGIN:nextjs-agent-rules -->

# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` (resolved from this file's directory; in monorepos the `next` package may not be visible from the repo root) before writing any code. Heed deprecation notices.

This block is written and re-added by `next dev` — verify at `node_modules/next/dist/server/lib/generate-agent-files.js`. Removing it from a diff only re-creates the uncommitted change; committing it with your work keeps the tree clean.

<!-- END:nextjs-agent-rules -->

# The site

Read [README.md](README.md) first: what's where, and the design rules.

- **Static only.** `output: "export"`: nothing that needs a server (no route handlers that run per request, no `next/font/google`, no image optimization).
- **Nothing from another host.** Fonts come from npm packages (`allo-font`, `@fontsource`) through `next/font/local`; no analytics, no third-party scripts. `vercel.json`'s Content-Security-Policy allows only the site itself.
- **Claims match the app.** What the keyboard does, and that it collects nothing and has no network access. Change the copy when the app changes.
- **Copy** is short, plain and warm, sentence case, with no em dashes.
- **A new page** goes in `lib/nav.ts` (the header, the sitemap and its metadata read it); `test/sitemap.test.ts` fails if a page is missing from it.
- Before handing off: `bun run build`, `bun run typecheck` and `bun run test` in this folder, and look at the page at 390px and 1440px in both light and dark.
