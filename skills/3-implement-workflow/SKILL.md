---
name: implement-workflow
description: Execute a single ticket in an isolated git worktree using Seam-First TDD, ticket-level grounding, and a shared Rulings & Discoveries ledger. Use when dispatched by /start-workflow or implementing a ticket.
disable-model-invocation: true
---
# Implement Workflow

Execute an assigned ticket cleanly inside its isolated worktree without redundant spec paperwork.

## Steps

1. **Ground Context:**
   - Work strictly inside `.worktrees/<ticket-id>` on branch `feat/<feature-slug>-<ticket-id>`.
   - Read the ticket (`.workflow/<feature-slug>/tickets/<ticket-id>.md` or via Jira MCP), root `CLAUDE.md`, target `<dir>/context.md`, and `.workflow/<feature-slug>/ledger.md`.
   - Inspect target files (`/how`) and recent git history (`/why`). If a genuine product/architectural decision is ambiguous, yield a `❓`/`➡️` question to the Command Center and wait for the ruling.
2. **Implement at the Seam:**
   - **Behavioral / Logic Changes (Seam-First TDD):** Write or extend a failing test at the ticket's pre-agreed **Module Seam** (never mock internal private helpers), run the single-seam test command to confirm failure, implement clean deep logic behind the interface until green, then refactor.
   - **Trivial / Config / Type-Only Changes:** Skip TDD ceremony; apply the change and verify typecheck/build.
   - **Tactical Rulings:** For minor implementation choices, make an executive ruling, log it in `ledger.md`, and keep moving.
   - **Hygiene:** Delete dead code before adding; write zero narration comments.
3. **Verify & Commit:**
   - Run typecheck, linter, and seam tests (plus runtime check if UI/CLI/extension behavior changed).
   - Append only non-obvious codebase traps or rulings to `.workflow/<feature-slug>/ledger.md`.
   - Commit cleanly to `feat/<feature-slug>-<ticket-id>` and signal completion to `/start-workflow`.

## Guardrail

- **Two-Strike Premise Rule:** If two consecutive fix attempts fail, stop guessing and invoke `/pivot-workflow`.
