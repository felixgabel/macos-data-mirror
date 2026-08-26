#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="/Volumes/Externe Festplatte/Backups/Musik/MainStage. app"
TARGET="/Applications/MainStage.app"

if [ ! -d "$BACKUP_DIR" ]; then
  echo "Fehler: Backup-Ordner '$BACKUP_DIR' nicht gefunden. Festplatte angeschlossen?"
  exit 1
fi

# Zeitstempel im Dateinamen sortieren lexikographisch chronologisch, neuestes zuerst
BACKUPS=()
while IFS= read -r line; do
  BACKUPS+=("$line")
done < <(ls -1 "$BACKUP_DIR"/*.zip 2>/dev/null | sort -r)

if [ ${#BACKUPS[@]} -eq 0 ]; then
  echo "Fehler: Kein Backup in '$BACKUP_DIR' gefunden." >&2
  exit 1
fi

echo
echo "Verfügbare Backups:"
PS3="Nummer des Backups wählen: "
select SELECTED_ZIP in "${BACKUPS[@]}"; do
  if [ -n "$SELECTED_ZIP" ]; then
    break
  fi
  echo "Ungültige Auswahl, bitte erneut versuchen."
done

echo
echo "ACHTUNG: Dies überschreibt '$TARGET' mit dem Stand von '$SELECTED_ZIP'."
read -r -p "Zum Fortfahren 'yes' eingeben: " confirm
if [ "$confirm" != "yes" ]; then
  echo "Abgebrochen."
  exit 1
fi

echo
echo "Starte Restore-Prozess..."
echo
rm -rf "$TARGET"
ditto -v -x -k "$SELECTED_ZIP" "/Applications/"
echo
echo "Restore erfolgreich abgeschlossen."
