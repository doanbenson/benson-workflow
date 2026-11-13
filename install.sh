#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$REPO_DIR/skills"

# 1. Canonical install roots (one per CLI ecosystem so Codex never sees two copies)
INSTALL_ROOTS=(
  "$HOME/.claude/skills"
  "$HOME/.agents/skills"
  "$HOME/.kiro/skills"
)
[ -d "$HOME/.kiro/crew" ] && INSTALL_ROOTS+=("$HOME/.kiro/crew/skills")

# 2. All locations where stale/duplicate copies might hide (especially ~/.codex/skills)
CLEANUP_ROOTS=(
  "${INSTALL_ROOTS[@]}"
  "${CODEX_HOME:-$HOME/.codex}/skills"
  "$HOME/.codex/skills"
  "$HOME/.cursor/skills"
  "$REPO_DIR/.agents/skills"
  "$REPO_DIR/.codex/skills"
  "$REPO_DIR/.claude/skills"
  "$REPO_DIR/.kiro/skills"
)

extract_skill_name() {
  local md_file="$1"
  awk '/^name:[[:space:]]*/ {sub(/^name:[[:space:]]*/, ""); gsub(/["'\''\r]/, ""); print; exit}' "$md_file"
}

echo "Syncing benson-workflow skills (Single Source of Truth: $SKILLS_SRC)"

for src_dir in "$SKILLS_SRC"/*/; do
  [ -d "$src_dir" ] || continue
  src_dir="${src_dir%/}"
  skill_md="$src_dir/SKILL.md"
  [ -f "$skill_md" ] || continue

  folder_name="$(basename "$src_dir")"
  skill_name="$(extract_skill_name "$skill_md")"
  if [ -z "$skill_name" ]; then
    skill_name="$(echo "$folder_name" | sed -E 's/^[0-9]+(\.[0-9]+)?-//')"
  fi

  echo ""
  echo "==> Skill: $skill_name (source: skills/$folder_name)"

  # Step A: Purge ALL existing copies/symlinks across all known CLI and legacy Codex paths
  for root in "${CLEANUP_ROOTS[@]}"; do
    [ -d "$root" ] || continue

    # Remove direct matches (both numbered e.g. 0-setup-... and canonical e.g. setup-...)
    for candidate in "$root/$folder_name" "$root/$skill_name"; do
      if [ -e "$candidate" ] || [ -L "$candidate" ]; then
        rm -rf "$candidate"
        echo "  - Cleaned old entry: $candidate"
      fi
    done

    # Scan every subfolder in $root (including symlinks) for matching `name:` in SKILL.md
    for existing_dir in "$root"/* "$root"/.*; do
      [ -e "$existing_dir" ] || [ -L "$existing_dir" ] || continue
      base="$(basename "$existing_dir")"
      [[ "$base" == "." || "$base" == ".." ]] && continue

      if [ -f "$existing_dir/SKILL.md" ]; then
        existing_name="$(extract_skill_name "$existing_dir/SKILL.md")"
        if [ "$existing_name" = "$skill_name" ]; then
          rm -rf "$existing_dir"
          echo "  - Removed duplicate skill folder: $existing_dir"
        fi
      fi
    done
  done

  # Step B: Symlink canonical folder directly to the repo's skill directory
  for target_root in "${INSTALL_ROOTS[@]}"; do
    mkdir -p "$target_root"
    ln -sfn "$src_dir" "$target_root/$skill_name"
    echo "  ✓ Linked $target_root/$skill_name -> $src_dir"
  done
done

echo ""
echo "Done! All duplicates purged from ~/.codex/skills, and skills are now symlinked to your repo."
echo "Note: Restart Codex CLI (or run a fresh session) so it reloads the skill index."