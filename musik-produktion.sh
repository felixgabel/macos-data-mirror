#!/usr/bin/env bash
set -euo pipefail

RSYNC="/opt/homebrew/bin/rsync"
TARGET_DIR="/Volumes/Externe Festplatte/Backups/Musik/Produktion"
SOURCE="$HOME/Music/"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Fehler: Zielordner '$TARGET_DIR' nicht gefunden. Festplatte angeschlossen?"
  exit 1
fi

if [ ! -d "$SOURCE" ]; then
  echo "Fehler: Quellordner '$SOURCE' existiert nicht." >&2
  exit 1
fi

ARGS=(
  -av
  --exclude=".DS_Store"
  --exclude=".localized"
  --exclude="Spitfire Audio/Settings/App/Helper/"
  --delete
)

echo
echo "Starte Backup-Prozess..."
echo
"$RSYNC" "${ARGS[@]}" "$SOURCE" "$TARGET_DIR/"
echo
echo "Backup erfolgreich abgeschlossen."
