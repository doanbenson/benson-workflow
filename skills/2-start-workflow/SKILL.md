---
name: start-workflow
description: Lean Command Center orchestrator for concurrent multi-agent ticket execution. Reads .workflow/<slug>/manifest.json or Jira MCP, runs a pre-implementation question gate across subagents so they never start coding before user answers, and merges completed slices.
---
# Start Workflow (Command Center)

Orchestrate a feature's ticket DAG across concurrent subagents in isolated `git worktree`s. Keep the orchestrator context ultra-lean: never write production code in the orchestrator session, and gate all implementation behind a centralized pre-flight question clearinghouse.

## Steps

1.  **Load DAG & Branch:**
      - Load `.workflow/<feature-slug>/manifest.json`. If Jira keys were passed directly without a manifest, fetch them via Jira MCP and generate `manifest.json` (`tracker_mode: "jira"`). If a single small task was passed, create a 1-ticket manifest.
      - Create branch `feat/<feature-slug>` from base and initialize `.workflow/<feature-slug>/ledger.md` for cross-worker rulings and traps.
2.  **Phase 2A — Recon & Pre-Flight Question Harvest (No Code Yet):**
      - Find all tickets in `manifest.json` whose `blocked_by` dependencies are 100% `completed`.
      - Create an isolated worktree per ready ticket (`git worktree add .worktrees/<id> -b feat/<feature-slug>-<id> feat/<feature-slug>`).
      - Spawn one concurrent subagent per ready ticket pointing only to `CLAUDE.md`, local `<dir>/context.md`, `.workflow/<feature-slug>/ledger.md`, and its ticket.
      - **Pre-Flight Gate Instruction:** Instruct each subagent to run **Step 1 (Ground & Pre-Flight Recon) of `/implement-workflow` ONLY**—inspect the files in scope, verify the seam contract, and return either `READY` or a list of `❓`/`➡️` clarifying questions. **Strictly forbid subagents from writing tests or implementation code before questions are resolved.**
3.  **Phase 2B — Centralized Question Clearinghouse:**
      - If *any* subagent returns `❓`/`➡️` questions, aggregate all questions from all active subagents into a single, lean clearinghouse prompt grouped by `[Ticket ID]` and wait for the user's answers.
      - Once the user answers, record the rulings in `.workflow/<feature-slug>/ledger.md` and greenlight the waiting subagents to execute Steps 2–3 of `/implement-workflow`. (Subagents that returned `READY` with zero blocking questions may proceed immediately if independent).
      - If a subagent hits a mid-implementation blocker or `/pivot-workflow` trigger later, surface its `❓`/`➡️` question through the same clearinghouse.
4.  **Merge & Advance:**
      - As each worker finishes and passes its seam tests, merge `feat/<feature-slug>-<id>` into `feat/<feature-slug>` (`--no-ff`), remove `.worktrees/<id>`, mark `completed` in `manifest.json` (and sync Jira if active), and repeat Phase 2A for newly unblocked tickets.
      - Render only a compact status table (`Ticket ID | Status | Gate/Notes`) on each wave transition to keep the Command Center lean.
5.  **Complete:** Once all tickets are merged onto `feat/<feature-slug>`, invoke `/complete-workflow`.