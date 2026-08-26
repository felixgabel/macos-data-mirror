#!/usr/bin/env bash
set -euo pipefail

RSYNC="/opt/homebrew/bin/rsync"
BACKUP_DIR="/Volumes/Externe Festplatte/Backups/Musik/Mediathek"
TARGET="$HOME/Mediathek/Musik/"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Fehler: Backup-Ordner '$BACKUP_DIR' nicht gefunden. Festplatte angeschlossen?"
  exit 1
fi

if [ ! -d "$TARGET" ]; then
  echo "Fehler: Zielordner '$TARGET' existiert nicht." >&2
  exit 1
fi

ARGS=(
  -vaAXUNH
  --exclude=".DS_Store"
  --exclude=".localized"
)

echo
echo "ACHTUNG: Dies überschreibt lokale Dateien in '$TARGET' mit dem Stand der Festplatte."
read -r -p "Zum Fortfahren 'yes' eingeben: " confirm
if [ "$confirm" != "yes" ]; then
  echo "Abgebrochen."
  exit 1
fi

echo
echo "Starte Restore-Prozess..."
echo
"$RSYNC" "${ARGS[@]}" "$BACKUP_DIR/" "$TARGET"
echo
echo "Restore erfolgreich abgeschlossen."
