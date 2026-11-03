---
name: setup-benson-workflow
description: Bootstrap a repository or machine with Benson's agentic engineering harness. Use when running /setup-benson-workflow, initializing a project for AI agents, scaffolding CLAUDE.md and directory context.md files, configuring .workflow/ gitignore rules, or detecting verification commands.
disable-model-invocation: true
---
# Setup Benson Workflow

Initialize and configure any codebase for high-leverage agentic development. Scaffolds hierarchical context (`CLAUDE.md` + `<dir>/context.md`), configures ephemeral `.workflow/` state hygiene, and locks in deterministic build, test, and runtime verification commands.

## When to Use

- Running `/setup-benson-workflow` on a new or existing repository
- Bootstrapping or auditing `CLAUDE.md` and directory-level `context.md` files
- Configuring test runners, linters, runtime verification commands, and issue-tracker settings

## Core Principles

1. **Progressive Context Disclosure:** Keep root `CLAUDE.md` under 100 lines. Push domain boundaries, public interfaces, and "DO NOT" anti-patterns into `<dir>/context.md` (under 50 lines each) inside high-leverage directories.
2. **Invariants Over File Lists:** Never list every file in a directory (static file lists rot on the next commit). Document *what the module owns*, *its public seam*, and *what must never happen inside it*.
3. **Zero Repo Clutter:** Ensure `.workflow/` is ignored so ephemeral plans, specs, and task ledgers never pollute project documentation or git history.

## Setup Steps

### Step 1: Workspace & Git Hygiene

1. Check `.gitignore` (or `.git/info/exclude`). Ensure `.workflow/` and `.worktrees/` are ignored so ephemeral pipeline artifacts and parallel subagent worktrees are never accidentally committed.
2. Inspect `package.json`, `Makefile`, `Cargo.toml`, `pyproject.toml`, or CI workflows to auto-detect exact commands for:
   - **Typecheck & Build**
   - **Linter & Formatter**
   - **Test Suite (Full & Single-File/Seam)**
   - **Runtime Verification** (how to boot or invoke the compiled app/CLI/extension locally)

### Step 2: Map High-Leverage Directories

Scan the repository tree (`tree -L 3 -I 'node_modules|.git|dist|build|.next|venv|__pycache__|.workflow'`) and select 4 to 10 high-leverage architectural directories (core domain modules, API/routes, state/db layers, shared primitives). Skip trivial leaf folders, static assets, and generated directories.

### Step 3: Scaffold Root `CLAUDE.md`

Create or update the root `CLAUDE.md` (and sync `.cursorrules` or `AGENTS.md` if used in the repo):

```markdown
# Project Context & Agent Operating Rules

## Verification & Build Commands
- **Build / Typecheck**: `<exact command>`
- **Lint / Format**: `<exact command>`
- **Test (Single Seam)**: `<exact command>`
- **Test (Full Suite)**: `<exact command>`
- **Runtime Check**: `<command or method to verify compiled behavior>`

## Architecture & Module Map
- `<dir>/` - <1-line ownership summary> (see `<dir>/context.md`)

## Core Engineering Principles
- **Context Routing**: Before modifying files in any subdirectory, read its local `context.md`. Update `context.md` whenever you introduce or change a module boundary.
- **Deep Modules & Seams**: Prefer deep modules (complex logic hidden behind a small public interface). Write tests at high-level module seams, never against mocked internal helpers.
- **Subtract Before You Add**: Delete dead code and simplify before extending.
- **No Narration Comments**: Write zero comments that restate what the code does. Only comment non-obvious invariants, why a constraint exists, or external bug workarounds.
```

### Step 4: Scaffold Directory `<dir>/context.md` Files

For each high-leverage directory from Step 2, inspect its entry-point files and create `<dir>/context.md` (max 50 lines):

```markdown
# Context: `<directory-name>`

## Ownership & Public Seam
- **Owns**: <Domain state, business logic, or responsibility>
- **Public Seam**: <Exact entry-point file(s) or interfaces external callers and seam tests should target>
- **Domain Glossary**: <1-3 key domain terms and their strict definitions in this module>

## Local Conventions
- <Canonical pattern, e.g., "Follow error handling in `src/api/auth.ts`">

## Invariants & Anti-Patterns (DO NOT)
- **DO NOT** import from `<forbidden-layer>`.
- **DO NOT** <specific trap or regression risk in this module>.
```

### Step 5: Drift Audit (When Re-run on Existing Repos)

If `CLAUDE.md` and `context.md` already exist:

1. Verify every listed command and file reference still exists and works.
2. Prune stale rules and add traps discovered during recent `pivot-workflow` or `complete-workflow` runs.
3. Confirm with a concise summary table of created/updated context files.

## Gotchas

- **Never spam every folder:** Only place `context.md` at true architectural boundaries (4 to 10 per repo).
- **Never copy code blocks into `context.md`:** Point to a canonical file in the repo instead of pasting code snippets that will go out of date.
