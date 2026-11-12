---
name: complete-workflow
description: Audit the merged feature branch against tickets and context.md, strip narration comments, run fresh CLI build/lint/test verification, sync Jira if enabled, clean up .workflow/ and worktrees, and output a PR summary.
disable-model-invocation: true
---
# Complete Workflow

Verify the integrated feature branch, clean up ephemeral artifacts, and prepare the pull request.

## Steps

1. **Adversarial Diff & Seam Audit:**
   - Inspect `git diff main...feat/<feature-slug>` against `manifest.json`, ticket acceptance criteria, and `<dir>/context.md` `DO NOT` rules.
   - Flag scope drift, unrequested refactors, or brittle tests mocking internal helpers instead of testing module seams.
2. **Strip Narration Comments (`/no-comments`):**
   - Remove added comments that restate what code does or label ticket steps. Keep only non-obvious *why* invariants or external bug workarounds.
3. **Fresh CLI Evidence Gate:**
   - Run the build/typecheck, linter, full test suite, and runtime check (if applicable) from `CLAUDE.md` on `feat/<feature-slug>`. Do not proceed until fresh terminal output is 100% green.
4. **Evolve Context, Sync & Teardown:**
   - Update `<dir>/context.md` if new module boundaries or traps were discovered in `ledger.md`.
   - If `tracker_mode == "jira"`, update child tickets and parent epic via Jira MCP.
   - Prune worktrees (`git worktree prune`) and delete `.workflow/<feature-slug>/` (`rm -rf .workflow/<feature-slug>`, plus `.workflow/` if empty). Confirm clean `git status`.
5. **Output PR Package:**
   - Provide a concise PR description covering: **Summary**, **Completed Slices & Seam Changes**, **Verification Evidence** (exact commands run), and **Rollback / Door Type** (`Two-Way` vs. `One-Way`).
