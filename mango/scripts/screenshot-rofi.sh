#!/usr/bin/env bash

set -euo pipefail

menu="Full\nArea\nClipboard\nCancel"
choice="$(printf "%b" "$menu" | rofi -i -config "$HOME/.config/rofi/config.rasi" -dmenu -p "Screenshot")"

timestamp="$(date +%F_%H-%M-%S)"
dir="$HOME/Pictures/Screenshots"
file="$dir/$timestamp.png"

select_region() {
  slurp
}

case "$choice" in
  Full)
    mkdir -p "$dir"
    grim "$file"
    ;;
  Area)
    region="$(select_region)" || exit 0
    [ -n "$region" ] || exit 0
    mkdir -p "$dir"
    grim -g "$region" "$file"
    ;;
  Clipboard)
    region="$(select_region)" || exit 0
    [ -n "$region" ] || exit 0
    grim -g "$region" - | wl-copy
    ;;
  *)
    exit 0
    ;;
esac
