#!/usr/bin/env python3
"""Enable the Noctalia theme and LibreOffice's Office-like tabbed UI."""

from __future__ import annotations

import socket
import subprocess
import sys
import time

import uno
from com.sun.star.beans import PropertyValue


def update_access(provider, path: str):
    node = PropertyValue()
    node.Name = "nodepath"
    node.Value = path
    return provider.createInstanceWithArguments(
        "com.sun.star.configuration.ConfigurationUpdateAccess", (node,)
    )


def set_properties(provider, path: str, values: dict[str, object]) -> None:
    access = update_access(provider, path)
    for name, value in values.items():
        access.setPropertyValue(name, value)
    access.commitChanges()


def main() -> int:
    if subprocess.run(
        ["pgrep", "-x", "soffice.bin"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    ).returncode == 0:
        print("Close LibreOffice before applying its theme and UI settings.", file=sys.stderr)
        return 1

    with socket.socket() as sock:
        sock.bind(("127.0.0.1", 0))
        port = sock.getsockname()[1]

    process = subprocess.Popen(
        [
            "libreoffice",
            "--headless",
            "--invisible",
            "--nologo",
            "--nodefault",
            "--nofirststartwizard",
            "--norestore",
            f"--accept=socket,host=127.0.0.1,port={port};urp;StarOffice.ComponentContext",
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

    desktop = None
    try:
        local_context = uno.getComponentContext()
        resolver = local_context.ServiceManager.createInstanceWithContext(
            "com.sun.star.bridge.UnoUrlResolver", local_context
        )
        connection = (
            f"uno:socket,host=127.0.0.1,port={port};urp;StarOffice.ComponentContext"
        )

        for _ in range(100):
            try:
                context = resolver.resolve(connection)
                break
            except Exception:
                if process.poll() is not None:
                    raise RuntimeError("LibreOffice exited before accepting the UNO connection")
                time.sleep(0.1)
        else:
            raise RuntimeError("Timed out connecting to LibreOffice")

        services = context.ServiceManager
        provider = services.createInstanceWithContext(
            "com.sun.star.configuration.ConfigurationProvider", context
        )
        desktop = services.createInstanceWithContext(
            "com.sun.star.frame.Desktop", context
        )

        set_properties(
            provider,
            "/org.openoffice.Office.Common/Appearance",
            {"LibreOfficeTheme": uno.Any("short", 1)},
        )
        set_properties(
            provider,
            "/org.openoffice.Office.UI/ColorScheme",
            {"CurrentColorScheme": "Noctalia"},
        )
        set_properties(
            provider,
            "/org.openoffice.Office.UI.ToolbarMode",
            {
                "ActiveWriter": "notebookbar.ui",
                "ActiveCalc": "notebookbar.ui",
                "ActiveImpress": "notebookbar.ui",
                "ActiveDraw": "notebookbar.ui",
            },
        )
        for application in ("Writer", "Calc", "Impress", "Draw"):
            set_properties(
                provider,
                f"/org.openoffice.Office.UI.ToolbarMode/Applications/{application}",
                {"Active": "Tabbed"},
            )

        print("LibreOffice now uses the Noctalia theme and Tabbed interface.")
        return 0
    finally:
        if desktop is not None:
            try:
                desktop.terminate()
            except Exception:
                pass
        try:
            process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            process.terminate()
            process.wait(timeout=5)


if __name__ == "__main__":
    raise SystemExit(main())
