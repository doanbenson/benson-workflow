---
name: setup-benson-workflow
description: Bootstrap or expand a repository with modular app/service scaffolding, hierarchical agent context (CLAUDE.md + directory context.md), .gitignore rules for .workflow/ and .worktrees/, and project verification commands. Use when running /setup-benson-workflow, starting a new app, adding a new service, or auditing codebase agent context.
---
# Setup Benson Workflow

Bootstrap a new codebase, register newly added services, or audit an existing repository with minimal, high-signal context files so agents respect module boundaries without context bloat.

## Steps

1.  **Git Hygiene:** Ensure `.workflow/` and `.worktrees/` are in `.gitignore` (or `.git/info/exclude`).
2.  **Mode Detection (Greenfield vs. Existing / Service Expansion):**
      - **Greenfield Repo (No existing app structure):** Ask the user for their target stack and initial services/packages (e.g., `apps/web`, `apps/api`, `packages/shared`) using a brief `❓`/`➡️` prompt. Once confirmed, scaffold the initial directory tree, root config (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.), and minimal entry-point stubs so the app runs and tests cleanly out of the box.
      - **Existing Repo or New Service Added:** Inspect `package.json`, `Makefile`, `pyproject.toml`, `Cargo.toml`, or CI configs to detect all architectural directories/services (especially any newly added service folders missing a `context.md`) and find exact commands for: build/typecheck, lint, single-test run, full test suite, and local runtime check.
3.  **Scaffold Root `CLAUDE.md` (<80 lines):** Create or update `CLAUDE.md` (and symlink/sync `AGENTS.md` or `.cursorrules` if used):
      - Exact verification commands from Step 2 (overall and per-service).
      - 1-line module map pointing to 4-10 high-leverage architectural/service directories (`<dir>/context.md`). Skip trivial folders and generated code.
      - Core rules:
          - Read local `<dir>/context.md` before editing any directory.
          - **New Service Rule:** Whenever a new service, app, or top-level package is created, immediately create its `<dir>/context.md` and register it in `CLAUDE.md` before writing feature code.
          - Test at module seams rather than mocking internals.
          - Delete dead code before adding; write zero narration comments (only document non-obvious *why* invariants).
4.  **Scaffold `<dir>/context.md` (<40 lines each):** For every mapped service or architectural directory (existing or newly added), inspect its entry points and document:
      - **Owns & Public Seam:** Responsibility, exact public entry file(s)/interfaces, and 1-3 domain glossary terms.
      - **Conventions:** Pointer to 1 canonical example file (never paste code blocks).
      - **DO NOT:** Forbidden imports, cross-service boundary violations, and non-obvious module traps.
5.  **Drift Audit (On Re-run):** Verify existing commands and paths still match the repo, scaffold `context.md` for any newly added services, prune stale rules, and report a summary table of created/updated files.