---
name: pivot-workflow
description: Recover from mid-implementation blockers, Two-Strike test failures, or broken ticket assumptions without losing valid work. Supports concurrent Command Center workers and standalone runs.
---
# Pivot Workflow

Stop speculative fixes when a ticket hits an invalid codebase assumption or fails two consecutive fix attempts ("Attack the Premise").

## Steps

1.  **Freeze & Diagnose:**
      - Halt edits in `.worktrees/<ticket-id>` and inspect the blocking module's actual implementation and `git log`/`git blame`.
      - Identify: (a) what the ticket assumed, (b) what the codebase actually enforces, and (c) whether sibling tickets in `manifest.json` are affected.
2.  **Propose Pivot (`❓` / `➡️`):**
      - Yield to the Command Center clearinghouse (if concurrent) or present in chat (if standalone) and wait for user approval before writing new code:
          - **Option A (Recommended - Surgical Patch):** Update the ticket contract/seam, revert only invalidated uncommitted hunks, and resume.
          - **Option B (Re-slice DAG):** Pause dependent tickets and re-run `/breakdown-feature` on the affected slice.
3.  **Patch & Encode Trap:**
      - Revert broken hunks while preserving valid commits.
      - Update the ticket file / `manifest.json` and log the pivot in `.workflow/<feature-slug>/ledger.md`.
      - Immediately add the newly discovered codebase constraint to `<dir>/context.md` under `DO NOT` so sibling workers and future sessions avoid the trap, then resume `/implement-workflow`.