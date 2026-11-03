#!/usr/bin/env bash
set -euo pipefail

source_dir="/usr/share/icons/Adwaita/scalable/places"
theme_dir="${XDG_DATA_HOME:-$HOME/.local/share}/icons/Noctalia-Adwaita"
target_dir="$theme_dir/scalable/places"

if [[ ! -d "$source_dir" ]]; then
  printf 'Adwaita scalable icons not found at %s; skipping folder recoloring.\n' "$source_dir" >&2
  exit 0
fi

shopt -s nullglob
sources=(
  "$source_dir"/folder*.svg
  "$source_dir"/user-{bookmarks,desktop,home}.svg
)
if (( ${#sources[@]} == 0 )); then
  printf 'No Adwaita folder icons found; skipping folder recoloring.\n' >&2
  exit 0
fi

install -d "$target_dir"
rm -f \
  "$target_dir"/folder*.svg \
  "$target_dir"/user-{bookmarks,desktop,home}.svg

for source in "${sources[@]}"; do
  sed \
    -e 's/#438de6/{{colors.primary_container.default.hex}}/gi' \
    -e 's/#62a0ea/{{colors.inverse_primary.default.hex}}/gi' \
    -e 's/#a4caee/{{colors.primary.default.hex}}/gi' \
    -e 's/#afd4ff/{{colors.secondary.default.hex}}/gi' \
    -e 's/#c0d5ea/{{colors.primary_fixed.default.hex}}/gi' \
    "$source" > "$target_dir/${source##*/}"
done

cat > "$theme_dir/index.theme" <<'EOF'
[Icon Theme]
Name=Noctalia Adwaita
Comment=Adwaita with wallpaper-colored folder icons
Inherits=Adwaita,hicolor
Directories=scalable/places

[scalable/places]
Size=128
MinSize=8
MaxSize=512
Type=Scalable
Context=Places
EOF

if command -v gtk-update-icon-cache >/dev/null; then
  gtk-update-icon-cache --force "$theme_dir" >/dev/null 2>&1 || true
fi

if command -v gsettings >/dev/null; then
  current_theme="$(gsettings get org.gnome.desktop.interface icon-theme | tr -d "'")"
  if [[ "$current_theme" == "Noctalia-Adwaita" ]]; then
    # Notify running apps after replacing files under the same theme name.
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
    sleep 0.1
  fi
  gsettings set org.gnome.desktop.interface icon-theme 'Noctalia-Adwaita'
fi
