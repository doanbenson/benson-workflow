---
name: implement-workflow
description: Execute a finalized .workflow/<slug>/spec.md using Seam-First TDD, tracer-bullet vertical slices, isolated git worktrees, and a live Rulings & Discoveries ledger. Use when running /implement-workflow or /implement on an approved spec.
disable-model-invocation: true
---
# Implement Workflow

Execute `.workflow/<feature-slug>/spec.md` through disciplined, slice-by-slice Seam-First TDD while maintaining a live ledger of execution rulings and codebase discoveries.

## When to Use

- Running `/implement-workflow` or `/implement` after `start-workflow` produces an approved `.workflow/<feature-slug>/spec.md`
- Executing vertical tracer-bullet tasks sequentially or across parallel `git worktree` workers

## Core Execution Principles

1. **Seam-First TDD (Contractual, Not Dogmatic):** Write failing tests strictly at the pre-agreed **Module Seams** defined in `spec.md`. Never write mock-heavy unit tests for internal private helpers.
2. **Rulings, Not Stalls:** Do not pause between tasks to ask "Should I continue?". Treat `spec.md` and `<dir>/context.md` as binding authority. For minor tactical ambiguities, make an executive ruling, log it in `.workflow/<feature-slug>/ledger.md`, and keep moving. Only invoke `pivot-workflow` if a core spec contract is impossible or broken.
3. **Engineering Hygiene (Poteto Discipline):**
   - **Subtract Before You Add:** Remove dead code or redundant abstractions before adding new logic.
   - **Zero Narration Comments:** Do not write comments explaining *what* the code does; only document non-obvious *why* invariants.

## Execution Steps

### Step 1: Initialize Branch & Execution Ledger

1. Load `.workflow/<feature-slug>/spec.md` and read the `context.md` files for all target directories.
2. Ensure you are on a dedicated branch (`feat/<feature-slug>` or `fix/<feature-slug>`). If executing independent DAG slices in parallel, isolate each worker in `.worktrees/<slice-slug>` and merge back cleanly.
3. Create `.workflow/<feature-slug>/ledger.md` to prevent subagent isolation amnesia:

```markdown
# Execution Ledger: `<feature-slug>`

## Completed Slices
- [ ] Slice 1: <Title>

## Rulings (Tactical Decisions Made Without Stalling)
- None yet.

## Codebase Discoveries (Quirks/Gotchas for Subsequent Slices)
- None yet.
```

### Step 2: Execute Tracer-Bullet Slices (Red-Green-Refactor at the Seam)

For each vertical slice in `.workflow/<feature-slug>/spec.md`:

1. **RED (Failing Seam Test):** Write or extend the test at the agreed module seam (`spec.md -> Testing Seams`). Run the single-seam test command from `CLAUDE.md` and watch it fail for the expected reason.
2. **GREEN (Minimal Deep Implementation):** Implement the production logic behind the module interface. Keep public signatures minimal and hide internal complexity. Run the seam test until it passes.
3. **REFACTOR & Compile Check:** Clean up duplication, run the typechecker/linter, and record any newly discovered codebase quirks in `.workflow/<feature-slug>/ledger.md`.
4. **Commit Slice:** Make a clean, atomic git commit for the completed vertical slice and mark it `[x]` in `ledger.md`.

### Step 3: Runtime Proof (For UI, CLI, or Extension Changes)

If the feature affects runtime behavior (UI rendering, CLI commands, VS Code extension host, API server), execute the `Runtime Check` command from `CLAUDE.md` against the compiled build to verify real execution before declaring implementation finished.

### Step 4: Handoff to `/complete-workflow`

Once all slices in `spec.md` are marked `[x]` in `ledger.md` and compile cleanly, transition immediately to `complete-workflow` for adversarial diff auditing, comment unslopping, full test suite verification, and `.workflow/` teardown.

## Gotchas

- **Two-Strike Premise Rule:** If two consecutive attempts to fix a test or build error fail, stop guessing. Read the underlying module source or invoke `pivot-workflow` to attack the flawed premise.
- **No Unapproved Seams:** Do not invent new public exports solely to test internal functions. Test through the seam agreed in `spec.md`.
