#!/usr/bin/env bash
set -euo pipefail

gtk_dir="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-4.0"
gtk_css="$gtk_dir/gtk.css"
import='@import url("noctalia-libadwaita.css");'

mkdir -p "$gtk_dir"
touch "$gtk_css"
grep -Fqx "$import" "$gtk_css" || printf '\n%s\n' "$import" >> "$gtk_css"
