#!/usr/bin/env bash
set -euo pipefail

RSYNC="/opt/homebrew/bin/rsync"
BACKUP_DIR="/Volumes/Externe Festplatte/Backups/Minecraft"
TARGET_DIR="$HOME/Library/Application Support/minecraft"
NAMES=(
    config
    instances
    mods
    resourcepacks
    saves
    screenshots
    shaderpacks
    options.txt
)

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Fehler: Backup-Ordner '$BACKUP_DIR' nicht gefunden. Festplatte angeschlossen?"
  exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
  echo "Fehler: Zielordner '$TARGET_DIR' existiert nicht." >&2
  exit 1
fi

SOURCES=()
for name in "${NAMES[@]}"; do
  SOURCES+=("$BACKUP_DIR/$name")
done

ARGS=(
  -va
  --exclude=".DS_Store"
  --exclude=".localized"
  --ignore-missing-args
)

echo
echo "ACHTUNG: Dies überschreibt lokale Dateien in '$TARGET_DIR' mit dem Stand der Festplatte."
read -r -p "Zum Fortfahren 'yes' eingeben: " confirm
if [ "$confirm" != "yes" ]; then
  echo "Abgebrochen."
  exit 1
fi

echo
echo "Starte Restore-Prozess..."
echo
"$RSYNC" "${ARGS[@]}" "${SOURCES[@]}" "$TARGET_DIR/"
echo
echo "Restore erfolgreich abgeschlossen."
