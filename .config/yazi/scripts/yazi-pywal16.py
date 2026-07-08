#!/usr/bin/env python3
"""Keep Yazi colors live with pywal/wpgtk terminal palette.

This script DOES NOT write RGB/hex colors from ~/.cache/wal.
It writes ANSI color names like blue, magenta, yellow, cyan into theme.toml.
Those names follow the terminal's live 16-color palette, so an already-open
Yazi can change colors when pywal/wpgtk updates the terminal palette.

Edit these two lines if you want all icons one terminal color:
    ICON_MODE = "mono"
    ICON_MONO_COLOR = "blue"
"""
from __future__ import annotations

import hashlib
import os
import re
import shutil
import sys
from pathlib import Path

# category = different terminal colors by file type
# mono     = all icons use ICON_MONO_COLOR
ICON_MODE = "category"
ICON_MONO_COLOR = "blue"

VALID_COLORS = {
    "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white",
    "gray", "grey", "darkgray", "darkgrey",
    "lightred", "lightgreen", "lightyellow", "lightblue", "lightmagenta", "lightcyan", "lightgray", "lightgrey",
}
INDEX_TO_NAME = [
    "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white",
    "darkgray", "lightred", "lightgreen", "lightyellow", "lightblue", "lightmagenta", "lightcyan", "white",
]

KNOWN_HEX_TO_NAME = {
    "#1d2021": "black", "#cc241d": "red", "#98971a": "green", "#d79921": "yellow",
    "#458588": "blue", "#b16286": "magenta", "#689d6a": "cyan", "#a89984": "white",
    "#928374": "darkgray", "#fb4934": "lightred", "#b8bb26": "lightgreen", "#fabd2f": "lightyellow",
    "#83a598": "cyan", "#d3869b": "lightmagenta", "#8ec07c": "lightcyan", "#ebdbb2": "white",
    "#03a9f4": "blue", "#8bc34a": "green", "#cddc39": "yellow", "#f44336": "red",
    "#9e9e9e": "darkgray", "#ffffff": "white", "#000000": "black",
}

IMAGE_EXTS = {"jpg","jpeg","png","gif","bmp","webp","avif","heic","heif","jxl","svg","ico","tif","tiff","xcf","psd","raw"}
VIDEO_EXTS = {"3gp","avi","m4v","mkv","mov","mp4","mpeg","mpg","ogv","webm","wmv","flv","ts","mts","m2ts"}
AUDIO_EXTS = {"aac","aif","aiff","ape","flac","m4a","mp3","oga","ogg","opus","wav","wma","wv","mid","midi"}
ARCHIVE_EXTS = {"7z","arj","bz","bz2","gz","lz","lzma","rar","tar","tbz","tgz","txz","xz","zip","zst","zstd","cab","cpio","deb","rpm"}
DOC_EXTS = {"pdf","doc","docx","odt","ods","odp","rtf","txt","md","markdown","org","epub","mobi","djvu","tex","csv","tsv","xls","xlsx","ppt","pptx"}
CONFIG_NAMES = {".bashrc",".zshrc",".vimrc","init.lua","config","makefile","dockerfile","compose.yaml","compose.yml","yazi.toml","theme.toml","keymap.toml","i3config","i3status.conf","i3blocks.conf","sxhkdrc","tmux.conf"}
CATEGORY_PALETTE = ["red", "green", "yellow", "blue", "magenta", "cyan", "lightred", "lightgreen", "lightyellow", "lightcyan", "lightmagenta"]


def config_dir() -> Path:
    return Path(os.environ.get("YAZI_CONFIG_HOME", Path.home() / ".config" / "yazi")).expanduser()


def normalize_color_name(value: str, default: str = "blue") -> str:
    v = value.strip().strip('"\'').lower()
    if v.isdigit():
        return INDEX_TO_NAME[int(v) % len(INDEX_TO_NAME)]
    if v in VALID_COLORS:
        return v
    return default


def stable_color(name: str) -> str:
    digest = hashlib.blake2b(name.encode("utf-8", "ignore"), digest_size=2).digest()
    return CATEGORY_PALETTE[int.from_bytes(digest, "big") % len(CATEGORY_PALETTE)]


def icon_mode() -> str:
    return os.environ.get("YAZI_ICON_MODE", ICON_MODE).lower()


def mono_color() -> str:
    return normalize_color_name(os.environ.get("YAZI_ICON_COLOR", ICON_MONO_COLOR), ICON_MONO_COLOR)


def pick_icon_color(name: str, group: str) -> str:
    if icon_mode() == "mono":
        return mono_color()

    n = name.lower().strip()
    if group == "dirs":
        return "cyan" if n.startswith(".") else "blue"

    ext = n.rsplit(".", 1)[-1] if "." in n else n
    if ext in IMAGE_EXTS:
        return "yellow"
    if ext in VIDEO_EXTS:
        return "magenta"
    if ext in AUDIO_EXTS:
        return "cyan"
    if ext in ARCHIVE_EXTS:
        return "red"
    if ext in DOC_EXTS:
        return "lightcyan"
    if n in CONFIG_NAMES or n.startswith("."):
        return "yellow"
    if ext in {"sh","bash","zsh","fish","py","lua","js","ts","tsx","jsx","go","rs","c","cpp","h","hpp","java","rb","php"}:
        return "green"
    return stable_color(n)


def pick_cond_color(cond: str) -> str:
    c = cond.lower()
    if "dir" in c and "!dir" not in c:
        return "blue"
    if "exec" in c:
        return "green"
    if "link" in c:
        return "cyan"
    if "orphan" in c or "dummy" in c:
        return "red"
    if any(x in c for x in ["block", "char", "fifo", "sock", "sticky"]):
        return "yellow"
    if "!dir" in c:
        return "white"
    return "white"


HEX_RE = re.compile(r'"(#[0-9a-fA-F]{6})"')
NAME_ENTRY_RE = re.compile(r'(\{[^\n]*?name\s*=\s*"([^"]+)"[^\n]*?fg\s*=\s*")([^"\n]+)("[^\n]*\})')
COND_ENTRY_RE = re.compile(r'(\{[^\n]*?if\s*=\s*"([^"]+)"[^\n]*?fg\s*=\s*")([^"\n]+)("[^\n]*\})')


def known_hex_to_names(line: str) -> str:
    def repl(m: re.Match[str]) -> str:
        color = KNOWN_HEX_TO_NAME.get(m.group(1).lower())
        return f'"{color}"' if color else m.group(0)
    return HEX_RE.sub(repl, line)


def render_theme(template_text: str) -> str:
    out: list[str] = []
    in_icon = False
    group = ""

    for line in template_text.splitlines():
        stripped = line.strip()
        line = known_hex_to_names(line)

        if stripped == "[icon]":
            in_icon = True
            group = ""
            out.append(line)
            continue
        if in_icon and stripped.startswith("[") and stripped != "[icon]":
            in_icon = False
            group = ""

        if in_icon:
            if re.match(r"^globs\s*=\s*\[", stripped):
                group = "globs"
            elif re.match(r"^dirs\s*=\s*\[", stripped):
                group = "dirs"
            elif re.match(r"^files\s*=\s*\[", stripped):
                group = "files"
            elif re.match(r"^exts\s*=\s*\[", stripped):
                group = "exts"
            elif re.match(r"^conds\s*=\s*\[", stripped):
                group = "conds"
            elif stripped == "]":
                group = ""

            def repl_name(m: re.Match[str]) -> str:
                return m.group(1) + pick_icon_color(m.group(2), group) + m.group(4)

            def repl_cond(m: re.Match[str]) -> str:
                return m.group(1) + pick_cond_color(m.group(2)) + m.group(4)

            line = NAME_ENTRY_RE.sub(repl_name, line)
            line = COND_ENTRY_RE.sub(repl_cond, line)

        out.append(line)

    return "\n".join(out) + "\n"


def main() -> int:
    cfg = config_dir()
    template = cfg / "theme.pywal16.template.toml"
    theme = cfg / "theme.toml"
    if not template.exists():
        print(f"[yazi-ansi-icons] Template not found: {template}", file=sys.stderr)
        return 1

    text = render_theme(template.read_text(errors="ignore"))
    if theme.exists():
        backup = theme.with_suffix(".toml.bak")
        if not backup.exists():
            shutil.copy2(theme, backup)
    theme.write_text(text)
    print(f"[yazi-ansi-icons] Wrote {theme}")
    print("[yazi-ansi-icons] mode: ANSI named colors; icons follow terminal palette live")
    print(f"[yazi-ansi-icons] icon mode: {icon_mode()}, mono color: {mono_color()}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
