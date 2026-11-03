---
name: complete-workflow
description: Run unified verification, adversarial spec/seam auditing, LLM narration comment unslopping (/no-comments), deterministic test suites, ephemeral .workflow/ cleanup, and PR generation. Use when implementation is finished and ready for final verification and pull request handoff.
disable-model-invocation: true
---
# Complete Workflow

Execute the unified quality gate and teardown stage of the pipeline: audit the diff against the spec and testing seams, strip LLM narration comments, verify fresh CLI test/build output, update `context.md` if boundaries evolved, delete ephemeral `.workflow/` files, and generate the pull request package.

## When to Use

- After `implement-workflow` finishes all vertical slices in `.workflow/<feature-slug>/spec.md`
- When the user asks to run `/complete-workflow`, verify, finalize, or wrap up a feature branch

## Unified Verification & Teardown Steps

### Step 1: Adversarial Spec, Seam & Context Audit

Inspect `git diff main...HEAD` (or base branch) against `.workflow/<feature-slug>/spec.md`, `.workflow/<feature-slug>/ledger.md`, and local `<dir>/context.md` files:

1. **Spec & Rulings Completeness:** Confirm every requirement in `spec.md` and every tactical ruling in `ledger.md` is properly implemented.
2. **Seam Discipline Check:** Flag and remove any brittle unit tests that mock internal private helpers instead of testing through the agreed module seams in `spec.md`.
3. **Scope Drift & Context Compliance:** Flag unrequested refactoring, stray debug logs, or violations of `<dir>/context.md` `"DO NOT"` rules.

### Step 2: Comment-Sicko Unslopping Pass (`/no-comments`)

Scan every added or modified line in `git diff` for LLM comment bloat:

- **DELETE:** Comments that narrate *what* the code does, restate function/variable names, or mark phase numbers (e.g., `// Slice 1`, `// Handle error`, `// Initialize state`).
- **KEEP:** Comments that explain non-obvious *why* constraints, performance/concurrency invariants, or external library bug workarounds.

### Step 3: Deterministic CLI Evidence Gate

Run the repository's verification commands from `CLAUDE.md` and observe fresh terminal output (never trust earlier subagent self-reports):

1. **Typecheck & Build:** Zero errors.
2. **Linter & Formatter:** Clean pass.
3. **Full Test Suite:** 100% pass across all unit/integration seam tests.
4. **Runtime Check (if applicable):** Verify the compiled application/CLI/extension runs cleanly.

Do not proceed to Step 4 until all commands succeed in the current turn.

### Step 4: Context Evolution & Ephemeral Teardown

1. **Context Update:** If this feature introduced a new architectural boundary, domain glossary term, or non-obvious trap recorded in `ledger.md`, update the corresponding `<dir>/context.md`.
2. **Extract PR Context:** Hold the summary, key architectural decisions, and rulings in memory for the PR description.
3. **Teardown `.workflow/` & Worktrees:**
   - Delete `.workflow/<feature-slug>/` (`rm -rf .workflow/<feature-slug>`), and remove `.workflow/` if empty.
   - Prune any temporary `.worktrees/` created during parallel slice execution (`git worktree prune`).
   - Run `git status` to verify the working tree is 100% clean.

### Step 5: Generate Pull Request Package

Output a clean, staff-level Pull Request summary:

```markdown
## Summary
<2-3 sentences explaining the problem solved and the architectural approach>

## Key Architectural & Seam Changes
- `<path/to/module>`: <Change summary + public seam contract>

## Verification Evidence
- [x] **Seam TDD & Full Suite**: `<exact test command>` (Passed)
- [x] **Build & Typecheck**: `<exact build/lint commands>` (Zero errors)
- [x] **Runtime Proof**: `<how runtime behavior was verified>`
- [x] **Diff Hygiene**: Stripped narration comments; verified `<dir>/context.md` invariants; cleaned up `.workflow/<feature-slug>/`

## Blast Radius & Door Classification
- **Type**: `[Two-Way Door (Reversible) | One-Way Door (Migration/API Contract)]`
- **Rollback Plan**: <1-sentence rollback safety note>
```

## Gotchas

- **Never delete `.workflow/` before green tests:** Keep `spec.md` and `ledger.md` on disk until Step 3 passes completely.
- **Distrust cached test runs:** Always execute a fresh test run *after* removing narration comments or making audit fixes in Step 2.
