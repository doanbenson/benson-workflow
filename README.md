# Benson's Agentic Engineering Harness (`benson-workflow`)

A portable, 5-skill software development lifecycle (SDLC) harness for Claude Code, Cursor, and `.agents`-compatible coding agents. Synthesizes the highest-leverage practices from `mattpocock/skills` (Frontier Grilling & Seam TDD), `pstack` (`/how` + `/why` grounding, `/arena` 2-candidate design sketches, & `comment-sicko` unslopping), and `obra/superpowers` (Execution Ledgers & Rulings over Stalls).

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

## The 5 Lifecycle Skills

| Command | Stage | What It Does |
| :--- | :--- | :--- |
| `/setup-benson-workflow` | **0. Repo Bootstrap** | Scaffolds root `CLAUDE.md` (<100 lines) and `<dir>/context.md` (<50 lines) in high-leverage directories, configures `.gitignore` for `.workflow/`, and locks in build/test/runtime commands. |
| `/start-workflow` | **1. Ground, Grill & Spec** | Runs silent `/how` + `/why` grounding, executes Frontier Grilling (`❓`/`➡️`), classifies Two-Way vs. One-Way Doors (optional 2-candidate `/arena` sketch), and writes a seam-locked `.workflow/<slug>/spec.md`. |
| `/implement-workflow` | **2. Seam-First Execution** | Executes vertical tracer-bullet slices using Contractual Seam TDD (`RED -> GREEN -> REFACTOR`), logs tactical rulings in `.workflow/<slug>/ledger.md`, and runs runtime checks. |
| `/pivot-workflow` | **3. Blocker Recovery** | Triggered on mid-flight blockers or Two-Strike test failures ("Attack the Premise"). Diagnoses spec vs. reality, patches `spec.md`, and encodes the trap into `<dir>/context.md`. |
| `/complete-workflow` | **4. Audit, Unslop & Ship** | Runs adversarial Spec/Seam/Context diff audit, strips LLM narration comments (`/no-comments`), verifies fresh CLI test/build output, deletes `.workflow/<slug>/`, and generates the PR package. |
