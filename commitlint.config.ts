// Conventional commits: `type(scope): subject`. The commit-msg hook (.githooks/commit-msg) runs
// this on every commit; pull request titles follow the same rule. Merge commits ("Merge branch …") and reverts are skipped by
// commitlint's defaults (`defaultIgnores`). Dependabot's own commits are skipped below.
// The rules, with examples: CONTRIBUTING.md › Commit messages.

// The workspaces and areas. A warning only, so a new area doesn't block a commit.
const scopes = ["ios", "keyboard", "app", "kit", "site", "icons", "docs", "ci", "deps"];

// A body is optional and short. Trailers (`Co-Authored-By: …`, `Signed-off-by: …`) don't count.
const maxBodyLines = 10;

const trailer = /^[A-Za-z][\w-]*: \S/;

// Dependabot commit (ec6f480), the raw string `ignores` receives: a conventional
// subject, a changelog body (markdown table and release links; more than 10
// lines, some over 100 characters), then a footer whose last line is this
// trailer. The matcher keys on that line. Human commits are still checked.
const dependabotSignoff = /^Signed-off-by: dependabot\[bot\] <support@github.com>$/m;

type Commit = { subject: string | null; body: string | null; footer: string | null };

export default {
  extends: ["@commitlint/config-conventional"],
  defaultIgnores: true,
  ignores: [(message: string) => dependabotSignoff.test(message)],
  plugins: [
    {
      rules: {
        "subject-lowercase-start": ({ subject }: Commit) => {
          const first = subject?.charAt(0) ?? "";

          return [
            first === first.toLowerCase(),
            "start the subject with a lowercase letter (names inside it keep their case)",
          ];
        },
        "body-max-lines": ({ body, footer }: Commit, _when: string, max = maxBodyLines) => {
          const lines = `${body ?? ""}\n${footer ?? ""}`
            .split("\n")
            .filter((line) => line.trim() !== "" && !trailer.test(line));

          return [lines.length <= max, `keep the body to ${max} lines or fewer`];
        },
      },
    },
  ],
  rules: {
    "type-enum": [
      2,
      "always",
      [
        "feat",
        "fix",
        "docs",
        "style",
        "refactor",
        "perf",
        "test",
        "build",
        "ci",
        "chore",
        "revert",
      ],
    ],
    "scope-case": [2, "always", "lower-case"],
    "scope-enum": [1, "always", scopes],
    "header-max-length": [2, "always", 72],
    "subject-case": [0],
    "subject-lowercase-start": [2, "always"],
    "subject-full-stop": [2, "never", "."],
    "body-max-line-length": [2, "always", 100],
    "body-max-lines": [2, "always", maxBodyLines],
    "footer-max-line-length": [2, "always", 100],
  },
};
