#!/usr/bin/env bash
set -euo pipefail

RSYNC="/opt/homebrew/bin/rsync"
TARGET_DIR="/Volumes/Externe Festplatte/Backups/Minecraft"
SOURCE_DIR="$HOME/Library/Application Support/minecraft"
SOURCES=(
    "$SOURCE_DIR"/config
    "$SOURCE_DIR"/instances
    "$SOURCE_DIR"/mods
    "$SOURCE_DIR"/resourcepacks
    "$SOURCE_DIR"/saves
    "$SOURCE_DIR"/screenshots
    "$SOURCE_DIR"/shaderpacks
    "$SOURCE_DIR"/options.txt
)

if [ ! -d "$TARGET_DIR" ]; then
  echo "Fehler: Zielordner '$TARGET_DIR' nicht gefunden. Festplatte angeschlossen?"
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Fehler: Quellordner '$SOURCE_DIR' existiert nicht." >&2
  exit 1
fi

ARGS=(
  -va
  --exclude=".DS_Store"
  --exclude=".localized"
  --delete
  --ignore-missing-args
)

echo
echo "Starte Backup-Prozess..."
echo
"$RSYNC" "${ARGS[@]}" "${SOURCES[@]}" "$TARGET_DIR/"
echo
echo "Backup erfolgreich abgeschlossen."
