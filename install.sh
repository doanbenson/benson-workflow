#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"

TARGET_DIRS=(
  "$HOME/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.cursor/skills"
)

echo "⚡ Installing Benson's Agentic Workflow Harness..."

for target in "${TARGET_DIRS[@]}"; do
  mkdir -p "$target"
  for skill_path in "$SKILLS_SRC"/*; do
    if [ -d "$skill_path" ]; then
      skill_name="$(basename "$skill_path")"
      ln -sfn "$skill_path" "$target/$skill_name"
      echo "  ✓ Linked $skill_name -> $target/$skill_name"
    fi
  done
done

echo ""
echo "✅ All 5 skills installed globally across Claude Code, Cursor, and .agents!"
echo "👉 Run '/setup-benson-workflow' inside any project repository to bootstrap its context.md harness."
