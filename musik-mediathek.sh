#!/usr/bin/env bash
set -euo pipefail

RSYNC="/opt/homebrew/bin/rsync"
TARGET_DIR="/Volumes/Externe Festplatte/Backups/Mediathek"
SOURCE="$HOME/Mediathek/Musik"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Fehler: Zielverzeichnis '$TARGET_DIR' nicht gefunden. Festplatte angeschlossen?"
  exit 1
fi

if [ ! -d "$SOURCE" ]; then
  echo "Fehler: Quellordner '$SOURCE' existiert nicht." >&2
  exit 1
fi

echo
echo "Starte Backup-Prozess..."
"$RSYNC" -avP --delete "$SOURCE" "$TARGET_DIR/"
echo
echo "Backup erfolgreich abgeschlossen."
