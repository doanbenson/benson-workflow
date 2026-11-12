# Benson's Agentic Engineering Harness (`benson-workflow`)

A lean, 6-skill software development lifecycle (SDLC) harness for Claude Code, Cursor, and `.agents`-compatible coding agents. Designed around Karpathy-style minimalism: high-leverage architectural guardrails without prompt bloat or micro-management.

## Quick Install (Any Laptop)

### Option A: Git Clone + Symlink Installer (Recommended — auto-updates on `git pull`)
```bash
git clone git@github.com:<your-github-username>/benson-workflow.git ~/.benson-workflow
~/.benson-workflow/install.sh
```

### Option B: Via `npx skills` CLI
```bash
npx skills@latest add <your-github-username>/benson-workflow -g
```

---

## The 6 Lifecycle Skills

| Command | Stage | Purpose |
| :--- | :--- | :--- |
| `/setup-benson-workflow` | **0. Repo Bootstrap** | Scaffolds lean root `CLAUDE.md` (<80 lines) and `<dir>/context.md` (<40 lines), ignores `.workflow/` & `.worktrees/`, and locks in build/test commands. |
| `/breakdown-feature` | **1. Feature Architect** | Grounds a PRD or Jira epic (`/how` + `/why`), runs Frontier Grilling (`❓`/`➡️`), and cuts vertical tracer-bullet tickets into `.workflow/<slug>/tickets/` or Jira MCP. |
| `/start-workflow` | **2. Command Center** | Dispatches ready frontier tickets concurrently in isolated `git worktree`s, batches worker questions into one human clearinghouse, and merges slices onto `feat/<slug>`. |
| `/implement-workflow` | **3. Ticket Worker** | Executes a ticket in its worktree using Seam-First TDD (with an escape hatch for trivial config edits) and logs traps in `ledger.md`. |
| `/pivot-workflow` | **4. Blocker Recovery** | Stops Two-Strike debug spirals ("Attack the Premise"), patches the ticket contract, and encodes the trap into `<dir>/context.md`. |
| `/complete-workflow` | **5. Audit & Ship** | Audits merged diff against tickets/`context.md`, strips narration comments, verifies fresh CLI tests, deletes `.workflow/<slug>/`, and drafts the PR. |
