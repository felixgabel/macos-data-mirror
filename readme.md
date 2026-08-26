# Backup Script Collection

_[English](readme.en.md)_

Eine Sammlung von `rsync`-basierten Backup- und Restore-Skripten für macOS, die bestimmte Ordner mit einer externen Festplatte synchronisieren.

## Struktur

Jedes Projekt hat seinen eigenen Ordner mit einem `backup.sh` (lokal → Festplatte) und einem `restore.sh` (Festplatte → lokal):

```
minecraft/
  backup.sh
  restore.sh
musik/
  mediathek/
    backup.sh
    restore.sh
  produktion/
    backup.sh
    restore.sh
```

### Was minecraft/backup.sh und minecraft/restore.sh sichern

Auf dem Mac liegen die relevanten Minecraft-Daten unter `~/Library/Application Support/minecraft/`:

| Pfad             | Inhalt                                                 |
| ---------------- | ------------------------------------------------------ |
| `config/`        | Einstellungen pro Mod                                  |
| `mods/`          | `.jar`-Mod-Dateien                                     |
| `instances/`     | Einzelne Instanzen (optional, nur falls genutzt)       |
| `options.txt`    | Vanilla-Spieleinstellungen (FOV, Tastenbelegung, etc.) |
| `resourcepacks/` | Textur-/Ressourcenpakete                               |
| `saves/`         | Eigene Welten                                          |
| `screenshots/`   | Screenshots (optional)                                 |
| `shaderpacks/`   | Shader-Dateien                                         |

## Voraussetzungen

Diese Skripte rufen rsync über einen festen Pfad auf: `/opt/homebrew/bin/rsync` (Homebrews rsync auf Apple Silicon). macOS liefert standardmäßig ein altes rsync mit, das nicht alle hier verwendeten Flags unterstützt. Daher zuerst eine aktuelle Version installieren:

```
brew install rsync
```

## Verwendung

1. Externe Festplatte anschließen. Alle Skripte erwarten sie unter `/Volumes/Externe Festplatte/...` — falls die Festplatte anders heißt, die Variable `TARGET_DIR`/`BACKUP_DIR` am Anfang des jeweiligen Skripts anpassen.
2. Das gewünschte Skript ausführen, z. B.:
   ```
   ./minecraft/backup.sh
   ./minecraft/restore.sh
   ```
3. **`backup.sh`** kopiert lokale Dateien auf die Festplatte (und löscht dort Dateien, die lokal nicht mehr existieren, um einen Spiegel zu erhalten).
4. **`restore.sh`** kopiert Dateien von der Festplatte zurück in den lokalen Ordner (ohne lokale Dateien zu löschen) und fragt vor jeder Änderung nach Eingabe von `yes`, da lokale Daten überschrieben werden können.

## In diesen Skripten verwendete `rsync`-Flags

Alle Skripte verwenden `-va` (oder `-vaAXUNH`) als Basis-Flags:

- **`-v`** verbose, zeigt an, was rsync gerade tut
- **`-a`** "archive"-Modus, eine Abkürzung für `-rlptgoD` (rekursiv, erhält Symlinks/Berechtigungen/Zeitstempel/Gruppe/Besitzer/Gerätedateien)

Die musik-Skripte fügen `AXUNH` hinzu, um macOS-spezifische Metadaten noch gründlicher zu erhalten:

- **`A`** ACLs erhalten (Access Control Lists)
- **`X`** erweiterte Attribute erhalten (Finder-Tags, Quarantäne-Flags, App-Metadaten)
- **`U`** atime erhalten (Zeitpunkt des letzten Lesezugriffs)
- **`N`** crtime erhalten (Erstellungsdatum, auf macOS getrennt vom Änderungsdatum)
- **`H`** Hardlinks erhalten

Das minecraft-Skript nutzt nur `-va`, da Minecraft-Dateien nicht auf ACLs, erweiterte Attribute oder Erstellungsdaten angewiesen sind.

Die minecraft-Skripte fügen außerdem `--ignore-missing-args` hinzu, da ihre `SOURCES`-/Restore-Liste mehrere optionale Unterordner enthält (z. B. `shaderpacks`, `instances`), die nicht jeder hat. Ohne dieses Flag würde rsync den gesamten Lauf abbrechen, sobald auch nur ein Eintrag fehlt. Die musik-Skripte sichern jeweils nur einen einzigen Ordner (dessen Existenz bereits zuvor im Skript geprüft wird), daher gibt es dort nichts Optionales zu ignorieren.
