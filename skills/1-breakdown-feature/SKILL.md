---
name: breakdown-feature
description: Decompose a feature, PRD, or parent Jira epic into a vertical tracer-bullet ticket DAG before implementation. Uses Jira MCP when a Jira ticket is passed, or writes ephemeral tickets to .workflow/<slug>/tickets/ otherwise.
---
# Breakdown Feature

Turn a feature request, PRD, or parent Jira issue into right-sized, self-sufficient vertical tracer-bullet tickets so concurrent subagents can each execute a slice in one clean context window without colliding.

## Steps

1.  **Ingest & Ground:**
      - If a Jira key/URL is passed, fetch the issue and comments via Jira MCP; otherwise parse the prompt/PRD.
      - Derive `<feature-slug>`, ensure `.workflow/` and `.worktrees/` are gitignored, and read root `CLAUDE.md` plus affected `<dir>/context.md` files.
      - Silently trace existing code mechanics (`/how`) and `git log`/`git blame` (`/why`) on touched modules before asking questions.
2.  **Frontier Grilling (`❓` / `➡️`):**
      - Look up codebase facts silently; only ask genuine product or architectural decisions.
      - Present only unblocked independent decisions using `❓` followed by `➡️` recommended default and trade-offs.
      - **One-Way Door Check:** If introducing a core schema, public API contract, or shared state machine, compare 2 structurally distinct interface sketches and lock the cleanest signature before slicing.
3.  **Cut Vertical Tracer-Bullet DAG:**
      - Slice into 2-6 vertical end-to-end tickets (never horizontal layers like "DB only" or "tests only").
      - Slice 1 is the minimal walking skeleton proving the primary seam; Slices 2..N are parallelizable expansions with non-overlapping file edits where possible.
      - **Ticket Self-Sufficiency Gate:** Every ticket MUST specify:
          - `id`, `title`, and `blocked_by` dependencies.
          - **Target Module Seam & Contract:** Exact function signatures, route payloads, or types expected at the seam so parallel subagents agree on interfaces.
          - **Exact Files in Scope:** Explicit file paths to create or modify (preventing concurrent workers in the same wave from editing the same files).
          - **Seam Test Command:** The exact single-test CLI command the subagent must run to verify its slice.
          - **Falsifiable Acceptance Criteria:** Concrete behavioral assertions.
4.  **Persist & Handoff:**
      - Write `.workflow/<feature-slug>/manifest.json` (`feature_slug`, `tracker_mode: "local" | "jira"`, `parent_jira_key`, `integration_branch: "feat/<feature-slug>"`, and `tickets` array with `id`, `jira_key`, `title`, `blocked_by`, `status`, `seam`, `files_in_scope`).
      - **Local Mode (no Jira ticket passed):** Write each ticket to `.workflow/<feature-slug>/tickets/<id>.md`.
      - **Jira Mode (Jira ticket passed):** Create linked child tickets via Jira MCP and store their `jira_key`s in `manifest.json`.
      - Output the DAG table and prompt the user to run `/start-workflow <feature-slug>`.