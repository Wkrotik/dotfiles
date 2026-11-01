#!/usr/bin/env bash
set -euo pipefail

theme_dir="${XDG_DATA_HOME:-$HOME/.local/share}/noctalia/brave-origin-nightly-theme"
manifest="$theme_dir/manifest.json"

[[ -f "$manifest" ]] || exit 0

THEME_DIR="$theme_dir" python3 - <<'PY'
import json
import os
from pathlib import Path

from PIL import Image

theme_dir = Path(os.environ["THEME_DIR"])
manifest = json.loads((theme_dir / "manifest.json").read_text())
colors = manifest["theme"]["colors"]
images = theme_dir / "images"
images.mkdir(parents=True, exist_ok=True)


def rgb(name):
    return tuple(int(value) for value in colors[name][:3])


def write(name, color, size):
    Image.new("RGB", size, color).save(images / name, "PNG")


write("theme_frame.png", rgb("frame"), (80, 60))
write("theme_frame_inactive.png", rgb("frame_inactive"), (80, 60))
write("theme_frame_incognito.png", rgb("frame_incognito"), (80, 60))
write("theme_toolbar.png", rgb("toolbar"), (320, 120))
write("theme_tab_background.png", rgb("frame"), (64, 64))
write("theme_ntp_background.png", rgb("ntp_background"), (1920, 1080))
PY
