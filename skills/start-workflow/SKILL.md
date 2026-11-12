---
name: start-workflow
description: Command Center orchestrator for concurrent multi-agent ticket execution. Reads .workflow/<slug>/manifest.json or Jira MCP, dispatches parallel subagents in git worktrees, aggregates worker questions into one clearinghouse, and merges completed slices.
disable-model-invocation: true
---
# Start Workflow (Command Center)

Orchestrate a feature's ticket DAG across concurrent subagents in isolated `git worktree`s. Never write production code in the orchestrator session.

## Steps

1. **Load DAG & Branch:**
   - Load `.workflow/<feature-slug>/manifest.json`. If Jira keys were passed directly without a manifest, fetch them via Jira MCP and generate `manifest.json` (`tracker_mode: "jira"`). If a single small task was passed, create a 1-ticket manifest.
   - Create branch `feat/<feature-slug>` from base and initialize `.workflow/<feature-slug>/ledger.md` for cross-worker rulings and traps.
2. **Dispatch Ready Frontier Concurrently:**
   - Find all tickets in `manifest.json` whose `blocked_by` dependencies are 100% `completed`.
   - Create an isolated worktree per ready ticket (`git worktree add .worktrees/<id> -b feat/<feature-slug>-<id> feat/<feature-slug>`).
   - Spawn one concurrent subagent per ready ticket pointing only to `CLAUDE.md`, local `<dir>/context.md`, `.workflow/<feature-slug>/ledger.md`, and its ticket (`.workflow/<feature-slug>/tickets/<id>.md` or Jira key), instructing it to execute `/implement-workflow`.
3. **Centralized Question Clearinghouse:**
   - Instruct subagents: solve codebase facts silently; if blocked on a genuine human decision or pivot, yield your `❓`/`➡️` question to the orchestrator and pause.
   - Batch all active subagent questions grouped by `[Ticket ID]` into one prompt for the user. Once answered, resume the waiting workers with the rulings.
4. **Merge & Advance:**
   - As each worker finishes and passes its seam tests, merge `feat/<feature-slug>-<id>` into `feat/<feature-slug>` (`--no-ff`), remove `.worktrees/<id>`, mark `completed` in `manifest.json` (and sync Jira if active), and dispatch newly unblocked tickets.
   - Render a compact status table (`Ticket ID | Status | Gate/Notes`) on each wave transition.
5. **Complete:** Once all tickets are merged onto `feat/<feature-slug>`, invoke `/complete-workflow`.
