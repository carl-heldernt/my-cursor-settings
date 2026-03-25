#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${REPO_ROOT}/skills"
DEST_DIR="${HOME}/.cursor/skills"

usage() {
  cat <<EOF
Usage: $(basename "$0") [--force] [--dry-run] [--merge]

By default, replace/create a symlink:
- Symlink "${SRC_DIR}" to "${DEST_DIR}".

Notes:
- This script is idempotent: running it multiple times is safe.
- If destination exists and is not the expected symlink:
  - Without --force: it will abort.
  - With --force: it will replace the destination symlink/path.
- If --merge is set: it will symlink each skill under "${SRC_DIR}" into
  "${DEST_DIR}" (without removing other skills already inside "${DEST_DIR}").
EOF
}

FORCE=0
DRY_RUN=0
MERGE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force) FORCE=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    --merge) MERGE=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 2 ;;
  esac
done

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }
run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "DRY-RUN: $*"
  else
    log "RUN: $*"
    eval "$@"
  fi
}

if [[ ! -d "$SRC_DIR" ]]; then
  echo "Source skills dir not found: $SRC_DIR" >&2
  exit 1
fi

mkdir -p "$(dirname "$DEST_DIR")"

if [[ -L "$DEST_DIR" ]]; then
  current_target="$(readlink "$DEST_DIR" || true)"
  # readlink returns a relative target sometimes; normalize by resolving.
  resolved_target="$(cd "$(dirname "$DEST_DIR")" && realpath -m "$current_target" 2>/dev/null || true)"
  resolved_src="$(realpath -m "$SRC_DIR")"
  if [[ "$resolved_target" == "$resolved_src" ]]; then
    log "Destination already points to the correct source."
    exit 0
  fi
fi

if [[ -e "$DEST_DIR" ]]; then
  if [[ "$FORCE" -eq 0 ]]; then
    if [[ "$MERGE" -eq 1 ]]; then
      log "Destination exists (not a symlink). Using --merge mode."
    else
      echo "Destination exists: $DEST_DIR" >&2
      echo "Run with --force to replace it, or --merge to add symlinks." >&2
      exit 1
    fi
  fi
  if [[ "$FORCE" -eq 1 && "$MERGE" -eq 0 ]]; then
    run "rm -rf \"$DEST_DIR\""
  fi
fi

if [[ "$MERGE" -eq 1 ]]; then
  mkdir -p "$DEST_DIR"
  for entry in "$SRC_DIR"/*; do
    [[ -e "$entry" ]] || continue
    name="$(basename "$entry")"
    dest_entry="${DEST_DIR}/${name}"

    if [[ -e "$dest_entry" ]]; then
      # If it already points to the same source, keep it.
      if [[ -L "$dest_entry" ]]; then
        cur_link_target="$(readlink "$dest_entry" || true)"
        resolved_cur_link_target="$(cd "$(dirname "$dest_entry")" && realpath -m "$cur_link_target" 2>/dev/null || true)"
        resolved_src="$(realpath -m "$entry")"
        if [[ "$resolved_cur_link_target" == "$resolved_src" ]]; then
          log "Skill already symlinked: $name"
          continue
        fi
      fi
      # If it is a regular directory, skip when SKILL.md matches byte-for-byte.
      if [[ -d "$dest_entry" && -d "$entry" ]]; then
        dest_skill_md="${dest_entry}/SKILL.md"
        src_skill_md="${entry}/SKILL.md"
        if [[ -f "$dest_skill_md" && -f "$src_skill_md" ]]; then
          if cmp -s "$src_skill_md" "$dest_skill_md"; then
            log "Skill already matches: $name (SKILL.md identical)"
            continue
          fi
        fi
      fi

      if [[ "$FORCE" -eq 0 ]]; then
        echo "Destination already has: $dest_entry" >&2
        echo "Run with --force to replace it, or remove it manually." >&2
        exit 1
      fi

      run "rm -rf \"$dest_entry\""
    fi

    run "ln -s \"$entry\" \"$dest_entry\""
    log "Linked skill: $name"
  done
  log "Done. Cursor skills updated in: $DEST_DIR"
  exit 0
fi

run "ln -s \"$SRC_DIR\" \"$DEST_DIR\""
log "Done. Cursor skills should be available in: $DEST_DIR"

