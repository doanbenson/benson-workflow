---
name: implement-workflow
description: Execute a single ticket in an isolated git worktree using a Pre-Flight Question Gate, Seam-First TDD, ticket-level grounding, and a shared Rulings & Discoveries ledger. Use when dispatched by /start-workflow or implementing a ticket.
---
# Implement Workflow

Execute an assigned ticket cleanly inside its isolated worktree without redundant spec paperwork. Never begin coding until all pre-flight ambiguities are resolved.

## Steps

1.  **Ground & Pre-Flight Recon (STOP Before Coding if Ambiguous):**
      - Work strictly inside `.worktrees/<ticket-id>` on branch `feat/<feature-slug>-<ticket-id>`.
      - Read the ticket (`.workflow/<feature-slug>/tickets/<ticket-id>.md` or via Jira MCP), root `CLAUDE.md`, target `<dir>/context.md`, and `.workflow/<feature-slug>/ledger.md`.
      - Inspect target files (`/how`) and recent git history (`/why`) to verify the ticket's seam contract against actual code.
      - **Pre-Flight Question Gate:** Do NOT write any test or production code yet if *any* product requirement, interface contract, or cross-ticket seam is ambiguous. Yield all `❓`/`➡️` questions back to `/start-workflow` (Command Center) immediately and pause until the user's ruling is recorded in `ledger.md`. If 100% clear, report `READY` and proceed.
2.  **Implement at the Seam:**
      - **Behavioral / Logic Changes (Seam-First TDD):** Write or extend a failing test at the ticket's pre-agreed **Module Seam** (never mock internal private helpers), run the ticket's exact single-seam test command to confirm failure, implement clean deep logic behind the interface until green, then refactor.
      - **Trivial / Config / Type-Only Changes:** Skip TDD ceremony; apply the change and verify typecheck/build.
      - **Tactical Rulings:** For minor internal implementation choices that do not alter the ticket contract, make an executive ruling, log it in `ledger.md`, and keep moving.
      - **Hygiene:** If creating a new service/module directory, create its `<dir>/context.md` and register it in `CLAUDE.md`. Delete dead code before adding; write zero narration comments.
3.  **Verify & Commit:**
      - Run typecheck, linter, and seam tests (plus runtime check if UI/CLI/extension behavior changed).
      - Append only non-obvious codebase traps or rulings to `.workflow/<feature-slug>/ledger.md`.
      - Commit cleanly to `feat/<feature-slug>-<ticket-id>` and signal completion to `/start-workflow`.

## Guardrail

  - **Two-Strike Premise Rule:** If two consecutive fix attempts fail, stop guessing and invoke `/pivot-workflow`.