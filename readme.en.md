# MacOS Data Mirror

_[Deutsch](readme.md)_

A collection of `rsync`-based backup and restore scripts for macOS, used to sync specific folders to and from an external drive.

## Structure

Each project has its own folder containing a `backup.sh` (local → drive) and a `restore.sh` (drive → local):

```
minecraft/
  backup.sh
  restore.sh
musik/
  mainstage-app/
    backup.sh
    restore.sh
  mediathek/
    backup.sh
    restore.sh
  produktion/
    backup.sh
    restore.sh
```

### What minecraft/backup.sh and minecraft/restore.sh cover

On Mac, the relevant Minecraft data lives under `~/Library/Application Support/minecraft/`:

| Path             | Contents                                              |
| ---------------- | ----------------------------------------------------- |
| `config/`        | Per-mod settings                                      |
| `mods/`          | `.jar` mod files                                      |
| `instances/`     | Individual instances (optional, only if you use them) |
| `options.txt`    | Vanilla game settings (FOV, keybinds, etc.)           |
| `resourcepacks/` | Texture/resource packs                                |
| `saves/`         | Your worlds                                           |
| `screenshots/`   | Screenshots (optional)                                |
| `shaderpacks/`   | Shader files                                          |

## Prerequisites

These scripts call rsync via a fixed path: `/opt/homebrew/bin/rsync` (Homebrew's rsync on Apple Silicon). macOS ships with an old built-in rsync that doesn't support all flags used here, so install a current version first:

```
brew install rsync
```

## Usage

1. Connect the external drive. All scripts expect it mounted at `/Volumes/Externe Festplatte/...` — if your drive has a different name, edit the `TARGET_DIR`/`BACKUP_DIR` variable at the top of the relevant script.
2. Run the script you need, e.g.:
   ```
   ./minecraft/backup.sh
   ./minecraft/restore.sh
   ```
3. **`backup.sh`** copies local files to the drive (and deletes files on the drive that no longer exist locally, to keep it a mirror).
4. **`restore.sh`** copies files from the drive back to your local folder (without deleting local-only files) and will ask you to type `yes` before making any changes, since it can overwrite local data.

## `rsync` flags used in these scripts

All scripts use `-va` (or `-vaAXUNH`) as their base rsync flags:

- **`-v`** verbose, prints what rsync is doing
- **`-a`** "archive" mode, a shortcut for `-rlptgoD` (recursive, preserve symlinks/permissions/timestamps/group/owner/device files)

The musik scripts add `AXUNH` for a more thorough preserve of macOS-specific file metadata:

- **`A`** preserve ACLs (Access Control Lists)
- **`X`** preserve extended attributes (Finder tags, quarantine flags, app metadata)
- **`U`** preserve atime (last-read timestamp)
- **`N`** preserve crtime (creation date, separate from modified date on macOS)
- **`H`** preserve hard links

The minecraft script uses plain `-va` since Minecraft's files don't rely on ACLs, extended attributes, or creation times.

The minecraft scripts also add `--ignore-missing-args`, because their `SOURCES`/restore item list contains several optional subfolders (e.g. `shaderpacks`, `instances`) that not everyone has. Without it, rsync would fail the whole run if any single item is missing. The musik scripts back up one single folder each (already checked for existence earlier in the script), so there's nothing optional to ignore.

### Special case: musik/mainstage-app

This folder doesn't rsync-mirror a folder; instead it packs the whole `/Applications/MainStage.app` bundle into a zip archive using `ditto` (instead of `zip`), since `ditto` correctly preserves resource forks, extended attributes, and the code signature of `.app` bundles. The target folder on the drive is named `MainStage.app`; each run of `backup.sh` creates a new archive named after the date (`YYYY_MM_DD.zip`) inside it instead of overwriting an existing one, so a history of multiple backups is kept. `restore.sh` shows a numbered list of all archives found (newest first) so you can pick which one to restore.
