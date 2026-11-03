---
name: start-workflow
description: Initialize and orchestrate an agentic software development workflow pipeline from a PRD, feature request, or ticket. Combines /how and /why codebase grounding, Frontier Grilling (❓/➡️), optional 2-candidate /arena interface sketching, and seam-locked /to-spec generation inside an ephemeral .workflow/ workspace.
disable-model-invocation: true
---
# Start Workflow

Initialize and orchestrate the pre-code architecture and specification stages of the development lifecycle before a single line of production code is written.

## When to Use

- Starting a new feature, refactor, or bugfix from a PRD, issue, or ticket
- Grounding architectural decisions in existing codebase mechanics (`/how`) and git history (`/why`)
- Running Frontier Grilling (`❓`/`➡️`) and generating a seam-locked `.workflow/<feature-slug>/spec.md`

## Ephemeral Workspace & Two-Speed Architecture

Store all working artifacts in `.workflow/<feature-slug>/` (which is gitignored and auto-deleted by `complete-workflow`):

- `.workflow/<feature-slug>/plan.md` - Grounding notes, Frontier Grilling decisions, and optional 2-candidate interface comparison
- `.workflow/<feature-slug>/spec.md` - Seam-locked technical specification and vertical tracer-bullet slice DAG
- `.workflow/<feature-slug>/ledger.md` - Created during `implement-workflow` to track completed slices, tactical rulings, and codebase discoveries

```
[PRD / Ticket]
      │
      ▼
1. Codebase Grounding (/how + /why + context.md)
      │
      ▼
2. Frontier Grilling (❓/➡️ Rounds - Facts vs. Decisions)
      │
   [Gate 1: Human Plan Sign-off + One-Way Door Check]
      │  └─ (If One-Way Door: Optional 2-Candidate /arena Sketch)
      ▼
3. Seam-Locked Spec & Slice DAG (/to-spec) ──► .workflow/<slug>/spec.md
      │                                        (Opt-in --tracker: push GitHub Issues)
   [Gate 2: Seam & Spec Confirmation]
      │
      ▼
4. Execution (/implement-workflow) ──► /pivot-workflow (if blocked) ──► /complete-workflow
```

## Phase Execution Steps

### Phase 1: Silent Codebase Grounding (`/how` + `/why`)

1. Derive a clean `<feature-slug>` and verify `.workflow/` is in `.gitignore` (or `.git/info/exclude`).
2. Read root `CLAUDE.md` and the `<dir>/context.md` files of any affected modules.
3. Perform silent read-only investigation before asking the user any questions:
   - **`/how` (Mechanics):** Trace the current data flow, public interfaces, and call sites of the target subsystem.
   - **`/why` (History & Constraints):** Check `git log` / `git blame` on touched interfaces so historical rationale becomes an explicit constraint rather than a guess.

### Phase 2: Frontier Grilling (`❓` / `➡️`)

1. **Fact vs. Decision Split:** Never ask the user a question that can be answered by reading the codebase, tests, or docs. Look up facts silently; only ask genuine product or architectural *decisions*.
2. **Frontier Rounds:** Present only the current unblocked **Frontier** of independent decisions (never ask Question B in the same round if it depends on the answer to Question A). Format every question as:

```markdown
❓ **1. <Crisp decision question>**
➡️ **Recommendation**: <Recommended choice and 1-sentence architectural rationale>
- **Alternative**: <Trade-off of the secondary path>
```

3. **Blast-Radius & Door Classification:** Classify the change as either:
   - **Two-Way Door (Standard/Reversible):** Proceed directly to Phase 3 once questions are answered.
   - **One-Way Door (Core Schema, State Machine, Public API Contract):** Offer a **2-Candidate Interface Sketch (`/arena`)**—drafting two structurally distinct module signatures (with unimplemented bodies) and grafting the deepest interface (hiding maximum complexity behind the smallest public surface) into `.workflow/<feature-slug>/plan.md`.

### Phase 3: Seam-Locked Spec & Slice DAG (`/to-spec`)

Once the human approves the plan at Gate 1, synthesize `.workflow/<feature-slug>/spec.md` without re-interviewing:

1. **Seams Before Prose:** Explicitly define the **1 to 2 high-level module seams** where behavioral tests will run (preferring existing deep module boundaries over internal unit tests).
2. **Interface & File Contracts:** List exact type signatures, public exports, and files to create/modify. Never write full production implementation code inside `spec.md`.
3. **Tracer-Bullet Slice DAG:** Break implementation into 2 to 5 vertical end-to-end slices with explicit blocking edges (`Slice 1 -> Slice 2`).
   - *Default Mode:* Keep the slice DAG inside `.workflow/<feature-slug>/spec.md`.
   - *Tracker Mode (`--tracker`):* If requested by the user for a multi-day epic, publish the vertical slices as linked GitHub Issues via `gh issue create`.
4. **Gate 2 (Seam Confirmation):** Present the agreed testing seams and slice DAG in the dashboard. Once confirmed, hand off to `implement-workflow`.

## Dashboard Status Template

Render this compact status dashboard at phase transitions:

```markdown
### 📋 Pipeline Dashboard: `<feature-slug>`

**Target**: `<Ticket Title>` | **Door Type**: `[Two-Way | One-Way]` | **Workspace**: `.workflow/<feature-slug>/`

| Phase | Artifact | Status | Gate |
|---|---|---|---|
| 1. Ground & Grill | `.workflow/<slug>/plan.md` | `Active / Done` | `Awaiting Ruling / Approved` |
| 2. Seam Spec | `.workflow/<slug>/spec.md` | `Pending / Done` | `Seams Locked` |
| 3. Implement | `.workflow/<slug>/ledger.md` | `Pending` | `Ready for /implement-workflow` |
| 4. Verify & Ship | PR & Teardown | `Pending` | `Awaiting /complete-workflow` |
```

## Gotchas

- **No Code-in-Plan Bloat:** Keep `spec.md` focused on interfaces, seams, and slice boundaries—never write 1,000-line code dumps inside Markdown.
- **Strict Gate 1 Enforcement:** Never generate `spec.md` or start coding until the Frontier Grilling questions are settled by the human.
