---
name: complete-workflow
description: Audit the merged feature branch against tickets and context.md, strip narration comments, run fresh CLI build/lint/test verification, sync Jira if enabled, clean up .workflow/ and worktrees, push the branch, and explicitly create a GitHub Pull Request.
---
# Complete Workflow

Verify the integrated feature branch, clean up ephemeral artifacts, push the branch, and explicitly open the Pull Request.

## Steps

1.  **Adversarial Diff & Seam Audit:**
      - Inspect `git diff main...feat/<feature-slug>` (or the repo's default base branch) against `manifest.json`, ticket acceptance criteria, and `<dir>/context.md` `DO NOT` rules.
      - Ensure any newly created service/module directory includes its `<dir>/context.md` and is mapped in root `CLAUDE.md`.
      - Flag and fix scope drift, unrequested refactors, or brittle tests mocking internal helpers instead of testing module seams.
2.  **Strip Narration Comments (`/no-comments`):**
      - Remove added comments that restate what code does or label ticket steps. Keep only non-obvious *why* invariants or external bug workarounds.
3.  **Fresh CLI Evidence Gate:**
      - Run the build/typecheck, linter, full test suite, and runtime check (if applicable) from `CLAUDE.md` on `feat/<feature-slug>`. Do not proceed until fresh terminal output is 100% green.
4.  **Evolve Context, Sync & Teardown:**
      - Update `<dir>/context.md` if new module boundaries or traps were discovered in `ledger.md`, and commit any context/cleanup changes to `feat/<feature-slug>`.
      - If `tracker_mode == "jira"`, update child tickets and parent epic via Jira MCP.
      - Prune worktrees (`git worktree prune`) and delete `.workflow/<feature-slug>/` (`rm -rf .workflow/<feature-slug>`, plus `.workflow/` if empty). Confirm clean `git status`.
5.  **Push & Explicitly Create Pull Request:**
      - Push the integration branch to the remote repository: `git push -u origin feat/<feature-slug>`.
      - **Create the Pull Request via GitHub CLI (`gh pr create`):**
          - Run `gh pr create --base <base-branch> --head feat/<feature-slug> --title "<concise title>" --body "<PR body>"` where the body includes: **Summary**, **Completed Slices & Seam Changes**, **Verification Evidence** (exact commands run), and **Rollback / Door Type** (`Two-Way` vs. `One-Way`).
          - Never stop after `git push` without attempting `gh pr create`. If `gh` CLI is not installed or unauthenticated, output the exact `gh pr create` command, the remote compare URL (`https://github.com/<owner>/<repo>/compare/<base>...feat/<feature-slug>?expand=1`), and the formatted Markdown PR body so the user can open it in one click.
      - Output the live Pull Request URL as the final step.