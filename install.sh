#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"

# Default target directories (override by passing a custom path as $1, or setting AGENT_SKILLS_DIR)
if [ $# -ge 1 ]; then
  TARGET_DIRS=("$1")
elif [ -n "${AGENT_SKILLS_DIR:-}" ]; then
  TARGET_DIRS=("$AGENT_SKILLS_DIR")
else
  TARGET_DIRS=("$HOME/.claude/skills")
  # Also update ~/.agents/skills or ~/.codex/skills if they exist on the machine
  [ -d "$HOME/.agents/skills" ] && TARGET_DIRS+=("$HOME/.agents/skills")
  [ -d "$HOME/.codex/skills" ] && TARGET_DIRS+=("$HOME/.codex/skills")
fi

echo "Installing benson-workflow skills from: $SKILLS_SRC"

for TARGET_Root in "${TARGET_DIRS[@]}"; do
  mkdir -p "$TARGET_Root"
  echo ""
  echo "Target directory: $TARGET_Root"

  for src_dir in "$SKILLS_SRC"/*/; do
    [ -d "$src_dir" ] || continue
    skill_md="$src_dir/SKILL.md"
    [ -f "$skill_md" ] || continue

    folder_name="$(basename "$src_dir")"
    # Extract canonical skill name from YAML frontmatter (fallback to stripped folder name)
    skill_name="$(awk '/^name:[[:space:]]*/ {sub(/^name:[[:space:]]*/, ""); gsub(/["'\''\r]/, ""); print; exit}' "$skill_md")"
    if [ -z "$skill_name" ]; then
      skill_name="$(echo "$folder_name" | sed -E 's/^[0-9]+(\.[0-9]+)?-//')"
    fi

    # 1. Remove any existing folders matching the numbered folder name OR canonical skill name
    rm -rf "$TARGET_Root/$folder_name"
    rm -rf "$TARGET_Root/$skill_name"

    # 2. Scan all other subdirectories in TARGET_Root and remove any stale directory
    #    whose SKILL.md declares the same `name: <skill_name>` (eliminates hidden duplicates)
    for existing_dir in "$TARGET_Root"/*/; do
      [ -d "$existing_dir" ] || continue
      existing_md="$existing_dir/SKILL.md"
      if [ -f "$existing_md" ]; then
        existing_name="$(awk '/^name:[[:space:]]*/ {sub(/^name:[[:space:]]*/, ""); gsub(/["'\''\r]/, ""); print; exit}' "$existing_md")"
        if [ "$existing_name" = "$skill_name" ]; then
          echo "  - Removing duplicate/stale skill folder: $(basename "$existing_dir")"
          rm -rf "$existing_dir"
        fi
      fi
    done

    # 3. Copy fresh skill into canonical directory name: <TARGET_Root>/<skill_name>
    dest_dir="$TARGET_Root/$skill_name"
    mkdir -p "$dest_dir"
    cp -R "$src_dir"/. "$dest_dir"/
    echo "  ✓ Installed $skill_name (overwrote previous version)"
  done
done

echo ""
echo "Done! All benson-workflow skills are up to date with zero duplicates."