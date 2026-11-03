---
name: pivot-workflow
description: Handle mid-implementation blockers, architectural mismatches, Two-Strike test failures, or scope changes without losing valid work. Use when /implement-workflow hits a roadblock, a spec assumption proves false, or requirements change mid-flight.
disable-model-invocation: true
---
# Pivot Workflow

Recover cleanly when `implement-workflow` hits a technical blocker, fails two consecutive fix attempts ("Attack the Premise"), or encounters an invalid codebase assumption in `.workflow/<feature-slug>/spec.md`.

## When to Use

- A library, API, or internal module violates an assumption in `.workflow/<feature-slug>/spec.md`
- Two consecutive attempts to fix a failing seam test or build error fail (*Attack the Premise* rule)
- The user changes scope or requirements mid-implementation

## Workflow Steps

### Step 1: Freeze & Attack the Premise

1. Stop writing speculative workaround code immediately.
2. Run a focused `/how` and `/why` investigation on the blocking module (reading actual source implementation and `git log`/`git blame`) to identify the exact root cause:
   - **Spec Premise:** What `spec.md` assumed was true.
   - **Codebase Reality:** The actual constraint, type contract, or lifecycle behavior.
   - **Salvageable Work:** Which completed vertical slices in `ledger.md` remain valid vs. which commits/files must be reverted.

### Step 2: Frontier Pivot Proposal

Present the diagnosis and a recommended path using the `❓`/`➡️` Frontier format:

```markdown
### ⚠️ Pipeline Pivot: `<feature-slug>`

**Premise Broken**: <1-2 sentences contrasting the spec assumption with codebase reality>
**Salvageable Slices**: `<Slices 1..k intact; Slice k+1 needs revert>`

❓ **How should we resolve this architectural mismatch?**
➡️ **Recommendation (Option A - Spec & Seam Patch)**: <Update affected interface/seam in `spec.md`, revert only the broken uncommitted changes, and resume `/implement-workflow`>
- **Alternative (Option B - Re-architect via 2-Candidate Sketch)**: <Stash branch changes and run a 2-candidate interface comparison before rewriting `spec.md`>
```

### Step 3: Patch Spec, Ledger & `context.md`

Once the user confirms:

1. **Surgical Git Cleanup:** Preserve valid slice commits; revert or stash only the invalidated hunks.
2. **Patch `.workflow/<feature-slug>/spec.md` & `ledger.md`:** Update the module contracts, testing seams, and slice DAG in `spec.md` so the spec stays the single source of truth, and log the pivot in `ledger.md`.
3. **Encode the Lesson in `<dir>/context.md`:** Immediately add the newly discovered codebase constraint to the relevant directory's `context.md` under `Invariants & Anti-Patterns (DO NOT)` so no future agent hits the same trap.
4. Resume `implement-workflow`.

## Gotchas

- **Never silently deviate from `spec.md`:** Coding around a broken spec without updating `spec.md` causes `complete-workflow` to fail the final spec-compliance audit.
- **Encode traps immediately:** Don't wait until the PR is finished to document a non-obvious codebase trap—write it into `<dir>/context.md` during Step 3 so it survives even if the branch is later reset.
