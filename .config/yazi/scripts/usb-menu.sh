#!/usr/bin/env bash
set -euo pipefail

# Simple udiskie menu for Yazi/i3.
# Needs: udiskie, udiskie-mount, udiskie-umount, findmnt, lsblk, fzf.

USER_NAME="${USER:-$(id -un)}"
MOUNT_ROOTS=("/run/media/$USER_NAME" "/media/$USER_NAME")
FLASH_LINK="/home/Флешки"

have() { command -v "$1" >/dev/null 2>&1; }

notify() {
  local title="$1" body="${2:-}"
  if have notify-send; then
    notify-send "$title" "$body" >/dev/null 2>&1 || true
  else
    printf '%s\n%s\n' "$title" "$body" >&2
  fi
}

pick() {
  if have fzf; then
    fzf --prompt='USB > ' --height=80% --border --reverse
  else
    cat
  fi
}

mount_roots_existing() {
  for root in "${MOUNT_ROOTS[@]}"; do
    [ -d "$root" ] && printf '%s\n' "$root"
  done
}

mounted_targets() {
  local root
  while IFS= read -r root; do
    findmnt -rn -R "$root" -o TARGET,SOURCE,FSTYPE,SIZE,USED,AVAIL 2>/dev/null || true
  done < <(mount_roots_existing) | awk 'NF { print }'
}

mounted_paths_only() {
  mounted_targets | awk '{print $1}'
}

open_mount() {
  local target
  target="$(mounted_paths_only | pick || true)"
  [ -n "${target:-}" ] || exit 0

  if have ya; then
    ya emit cd "$target"
  else
    printf '%s\n' "$target"
  fi
}

unmount_menu() {
  local target
  target="$(mounted_paths_only | pick || true)"
  [ -n "${target:-}" ] || exit 0

  sync || true
  udiskie-umount "$target"
  notify "USB unmounted" "$target"

  if have ya && [ -d "$FLASH_LINK" ]; then
    ya emit cd "$FLASH_LINK" || true
  fi
}

poweroff_menu() {
  local target
  target="$(mounted_paths_only | pick || true)"
  [ -n "${target:-}" ] || exit 0

  sync || true
  udiskie-umount --detach "$target"
  notify "USB powered off" "$target"

  if have ya && [ -d "$FLASH_LINK" ]; then
    ya emit cd "$FLASH_LINK" || true
  fi
}

mount_all() {
  udiskie-mount -a
  notify "USB mount" "Mounted all handled devices"
  if have ya && [ -d "$FLASH_LINK" ]; then
    ya emit cd "$FLASH_LINK" || true
  fi
}

clean_empty_dirs() {
  find /media/$USER_NAME /run/media/$USER_NAME \
    -mindepth 1 -maxdepth 1 -type d -empty -print -delete 2>/dev/null || true
  notify "USB cleanup" "Empty mount directories removed"
  if have ya && [ -d "$FLASH_LINK" ]; then
    ya emit cd "$FLASH_LINK" || true
  fi
}

show_status() {
  printf 'Mounted media:\n\n'
  mounted_targets || true
  printf '\nBlock devices:\n\n'
  lsblk -f
  printf '\nPress Enter to close...'
  read -r _ || true
}

main() {
  local action
  action="$(printf '%s\n' \
    'Open mounted drive' \
    'Unmount selected drive' \
    'Power off selected drive' \
    'Mount all removable drives' \
    'Clean empty mount folders' \
    'Show USB status' \
    | pick || true)"

  case "$action" in
    'Open mounted drive') open_mount ;;
    'Unmount selected drive') unmount_menu ;;
    'Power off selected drive') poweroff_menu ;;
    'Mount all removable drives') mount_all ;;
    'Clean empty mount folders') clean_empty_dirs ;;
    'Show USB status') show_status ;;
    *) exit 0 ;;
  esac
}

main "$@"
