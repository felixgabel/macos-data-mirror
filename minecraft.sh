#!/usr/bin/env bash
set -euo pipefail

RSYNC="/opt/homebrew/bin/rsync"
TARGET_DIR="/Volumes/Externe Festplatte/Backups/Minecraft"
SOURCE_DIR="$HOME/Library/Application Support/minecraft"
SOURCES=(
    config
    instances
    mods
    resourcepacks
    saves
    screenshots
    shaderpacks
    options.txt
)

if [ ! -d "$TARGET_DIR" ]; then
  echo "Fehler: Zielordner '$TARGET_DIR' nicht gefunden. Festplatte angeschlossen?"
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Fehler: Quellordner '$SOURCE_DIR' existiert nicht." >&2
  exit 1
fi

EXISTING_SOURCE=()
for SOURCE in "${SOURCES[@]}"; do
    if [ -e "$SOURCE_DIR/$SOURCE" ]; then
        EXISTING_SOURCE+=("$SOURCE_DIR/$SOURCE")
    else
        echo "Achtung! '$SOURCE' nicht gefunden, überspringe..."
    fi
done

echo
echo "Starte Backup-Prozess..."
echo
"$RSYNC" -avP --delete "${EXISTING_SOURCE[@]}" "$TARGET_DIR/"
echo
echo "Backup erfolgreich abgeschlossen."
