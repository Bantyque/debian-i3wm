#!/usr/bin/env bash
set -euo pipefail

echo "== Yazi =="
command -v yazi || true
yazi --version 2>/dev/null || true

echo

echo "== Image preview environment =="
echo "XDG_SESSION_TYPE=${XDG_SESSION_TYPE:-}"
echo "DISPLAY=${DISPLAY:-}"
echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}"
echo "TERM=${TERM:-}"
echo "TERM_PROGRAM=${TERM_PROGRAM:-}"

echo

echo "== Dependencies =="
for c in file ueberzugpp ffmpeg ffprobe pdftoppm jq fd fdfind rg zoxide fzf magick convert; do
  printf '%-12s ' "$c"
  command -v "$c" || true
done

echo

echo "== Yazi debug adapter =="
yazi --debug 2>/dev/null | sed -n '/^Adapter/,+25p' || true


printf '
Archive/DjVu extras:
'
for bin in ouch fzf zoxide ddjvu ffmpeg file; do
  if command -v "$bin" >/dev/null 2>&1; then
    printf '  OK   %s -> %s
' "$bin" "$(command -v "$bin")"
  else
    printf '  MISS %s
' "$bin"
  fi
done
