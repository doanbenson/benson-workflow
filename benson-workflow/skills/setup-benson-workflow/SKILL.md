---
name: setup-benson-workflow
description: Bootstrap a repository with hierarchical agent context (CLAUDE.md + directory context.md), .gitignore rules for .workflow/ and .worktrees/, and project verification commands. Use when running /setup-benson-workflow or auditing codebase agent context.
disable-model-invocation: true
---
# Setup Benson Workflow

Configure a repository with minimal, high-signal context files so agents respect module boundaries without context bloat.

## Steps

1. **Git Hygiene:** Ensure `.workflow/` and `.worktrees/` are in `.gitignore` (or `.git/info/exclude`).
2. **Detect Commands:** Inspect `package.json`, `Makefile`, `pyproject.toml`, `Cargo.toml`, or CI configs to find exact commands for: build/typecheck, lint, single-test run, full test suite, and local runtime check.
3. **Scaffold Root `CLAUDE.md` (<80 lines):** Create or update `CLAUDE.md` (and symlink/sync `AGENTS.md` or `.cursorrules` if used):
   - Exact verification commands from Step 2.
   - 1-line module map pointing to 4-10 high-leverage architectural directories (`<dir>/context.md`). Skip trivial folders and generated code.
   - Core rules: read local `context.md` before editing a directory; test at module seams rather than mocking internals; delete dead code before adding; write zero narration comments (only document non-obvious *why* invariants).
4. **Scaffold `<dir>/context.md` (<40 lines each):** For each mapped architectural directory, inspect its entry points and document:
   - **Owns & Public Seam:** Responsibility, exact public entry file(s)/interfaces, and 1-3 domain glossary terms.
   - **Conventions:** Pointer to 1 canonical example file (never paste code blocks).
   - **DO NOT:** Forbidden imports and non-obvious module traps.
5. **Drift Audit (On Re-run):** Verify existing commands and paths still match the repo, prune stale rules, and report a summary table of created/updated files.
