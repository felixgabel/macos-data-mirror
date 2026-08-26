#!/usr/bin/env bash
set -euo pipefail

SOURCE="/Applications/MainStage.app"
# Ordner endet auf ". app" (Leerzeichen), sonst hält Finder ihn für eine .app-Bundle
TARGET_DIR="/Volumes/Externe Festplatte/Backups/Musik/MainStage. app"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Fehler: Zielordner '$TARGET_DIR' nicht gefunden. Festplatte angeschlossen?"
  exit 1
fi

if [ ! -d "$SOURCE" ]; then
  echo "Fehler: Quellordner '$SOURCE' existiert nicht." >&2
  exit 1
fi

TIMESTAMP="$(date +%Y_%m_%d)"
ZIP_NAME="${TIMESTAMP}.zip"

echo
echo "Starte Backup-Prozess..."
echo
# ditto statt zip, um Resource Forks/xattrs/Codesignatur der .app zu erhalten
ditto -v -c -k --sequesterRsrc --keepParent "$SOURCE" "$TARGET_DIR/$ZIP_NAME"
echo
echo "Backup erfolgreich abgeschlossen: $ZIP_NAME"
