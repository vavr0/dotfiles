#!/usr/bin/env bash

set -euo pipefail

rofi_cmd() {
  rofi -i -config "$HOME/.config/rofi/config.rasi" -dmenu -p "$1"
}

run() {
  rmpc "$@"
}

open_rmpc() {
  foot -e rmpc >/dev/null 2>&1 &
}

build_prompt() {
  local status_json song_json

  status_json="$(rmpc status 2>/dev/null || true)"
  song_json="$(rmpc song 2>/dev/null || true)"

  STATUS_JSON="$status_json" SONG_JSON="$song_json" python3 - <<'PY'
import json
import os

status_raw = os.environ.get("STATUS_JSON", "")
song_raw = os.environ.get("SONG_JSON", "")

label = "Music"

try:
    status = json.loads(status_raw) if status_raw else {}
except json.JSONDecodeError:
    status = {}

try:
    song = json.loads(song_raw) if song_raw else {}
except json.JSONDecodeError:
    song = {}

state = status.get("state", "").strip()
meta = song.get("metadata") or {}
artist = (meta.get("artist") or meta.get("albumartist") or "").strip()
title = (meta.get("title") or song.get("file") or "").strip()

parts = []
if state:
    parts.append(state)
if artist and title:
    parts.append(f"{artist} - {title}")
elif title:
    parts.append(title)

if parts:
    label = " | ".join(parts)

print(label)
PY
}

menu="Play/Pause\nNext\nPrevious\nStop\nVolume +5\nVolume -5\nToggle repeat\nToggle random\nOpen rmpc\nCancel"
choice="$(printf "%b" "$menu" | rofi_cmd "$(build_prompt)")"

case "${choice:-}" in
  "Play/Pause")
    run togglepause
    ;;
  Next)
    run next
    ;;
  Previous)
    run prev
    ;;
  Stop)
    run stop
    ;;
  "Volume +5")
    run volume +5
    ;;
  "Volume -5")
    run volume -5
    ;;
  "Toggle repeat")
    run togglerepeat
    ;;
  "Toggle random")
    run togglerandom
    ;;
  "Open rmpc")
    open_rmpc
    ;;
  *)
    exit 0
    ;;
esac
