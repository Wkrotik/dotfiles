#!/usr/bin/env python3
"""Disable Equibop's separate startup splash without tracking its runtime config."""

import json
import os
import tempfile
from pathlib import Path

settings_path = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "equibop/settings.json"

if not settings_path.exists():
    raise SystemExit(0)

settings = json.loads(settings_path.read_text())
if settings.get("enableSplashScreen") is False:
    print("Equibop splash screen is already disabled.")
    raise SystemExit(0)

settings["enableSplashScreen"] = False
with tempfile.NamedTemporaryFile("w", dir=settings_path.parent, delete=False) as output:
    json.dump(settings, output, indent=4)
    output.write("\n")
    temporary_path = Path(output.name)

temporary_path.chmod(settings_path.stat().st_mode)
temporary_path.replace(settings_path)
print("Equibop splash screen disabled.")
