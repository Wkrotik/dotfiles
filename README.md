# Dotfiles

Personal Arch Linux configuration managed as independent [GNU Stow](https://www.gnu.org/software/stow/) packages.

The active desktop uses:

- Niri and Noctalia
- Alacritty and Starship
- Zsh with Oh My Zsh
- tmux
- LazyVim

## Packages

| Stow package | Installed configuration |
| --- | --- |
| `shell` | `~/.zshrc` |
| `starship` | `~/.config/starship` |
| `alacritty` | `~/.config/alacritty` |
| `tmux` | `~/.config/tmux` |
| `niri` | `~/.config/niri`, Niri-aware Steam launcher |
| `noctalia` | Noctalia theme and application templates |
| `nvim` | LazyVim configuration |
| `fastfetch` | Fastfetch configuration |
| `rmpc` | RMPC configuration |
| `swaylock` | Swaylock configuration |

Wallpapers are kept in `wallpapers/` and read directly from the repository.

## Install on Arch Linux

> The bootstrap script installs packages with `sudo pacman` and may conflict with existing files at the managed paths. Back up existing configuration first.

```bash
git clone https://github.com/Wkrotik/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./scripts/bootstrap-arch.sh
```

The script:

1. Installs the required Arch packages.
2. Installs Oh My Zsh and the configured plugins outside this repository.
3. Stows every active configuration package into `$HOME`.

## Stow manually

From the repository root:

```bash
stow --no-folding --restow --target="$HOME" \
  shell starship alacritty tmux niri noctalia nvim \
  fastfetch rmpc swaylock
```

`--no-folding` creates links for managed files instead of replacing whole application directories. This allows applications to keep runtime-generated files beside the managed configuration.

To remove the links without deleting the repository files:

```bash
stow --no-folding --delete --target="$HOME" \
  shell starship alacritty tmux niri noctalia nvim \
  fastfetch rmpc swaylock
```

## Wallpaper-generated colors

Noctalia derives the active palette from the current wallpaper using the `m3-tonal-spot` scheme. Tracked template configuration regenerates colors for:

- Niri, Alacritty, Starship, tmux, GTK 3/4, Qt, and btop
- fzf, Obsidian, Code OSS, Thunderbird, LibreWolf/Pywalfox, OBS, and Telegram/AyuGram
- LibreOffice, Blender, Prism Launcher, Heroic Games Launcher, and Equibop
- Brave Origin Nightly through a local unpacked Chromium theme

Apply every template after installation or after closing an app that blocked an update:

```bash
noctalia msg templates-apply
```

The core Niri, Alacritty, Starship, and tmux palette outputs are tracked so the desktop still has usable colors before Noctalia starts. Other generated application files and Noctalia's GUI-managed state under `~/.local/state/noctalia` are not tracked. Community templates are fetched by Noctalia; the Equibop and Brave Origin Nightly templates are kept in this repository.

### One-time application setup

| Application | One-time step |
| --- | --- |
| Obsidian | Set **Base color scheme** to **Adapt to system**. The `noctalia` CSS snippet is generated and enabled automatically. |
| fzf | Start a new Zsh session; `.zshrc` sources the generated theme. |
| Code OSS | Install/select **NoctaliaTheme**. The bootstrap script installs the extension when `code` is already available. |
| Thunderbird | Restart after the first template application. |
| LibreWolf | Install the [Pywalfox extension](https://addons.mozilla.org/firefox/addon/pywalfox/), then restart LibreWolf once. No separate native host package is needed. |
| Sidebery | Set **Settings → Appearance → Color scheme** to **Firefox**. It then follows LibreWolf's Pywalfox theme automatically; custom CSS is unnecessary. |
| Brave Origin Nightly | Open `brave://extensions`, enable Developer mode, and load unpacked from `~/.local/share/noctalia/brave-origin-nightly-theme`. Reload that extension after palette changes. |
| OBS Studio | Select **Matugen** in the theme settings. |
| LibreOffice | The bootstrap configures the **Noctalia** theme and Office-like **Tabbed** interface. With LibreOffice closed, run `./scripts/configure-libreoffice.py` to reapply those settings; restart after palette updates. |
| Blender | No manual step; the template updates Blender preferences headlessly. |
| Prism Launcher | Select **Matugen** in the theme settings. |
| Heroic Games Launcher | Set **Custom Themes Path** to `~/.config/heroic/themes`, then select `matugen.css`. |
| Equibop | Enable `noctalia-material.theme.css` under **Settings → Themes**. The bootstrap disables its separate splash screen; `./scripts/configure-equibop.py` reapplies that setting. Its main window opens at the same two-thirds width as one `Mod+D` press. |
| AyuGram / Telegram | Import `~/.config/telegram-desktop/themes/noctalia.tdesktop-theme` through **Choose from file**. Restart after palette changes; re-import only if AyuGram keeps the cached colors. |

Optional GUI applications are not installed by the bootstrap script; their templates remain ready and apply when the applications are present.

The local Steam desktop entry uses `~/.local/bin/niri-launch-on-workspace` to temporarily preserve the launch workspace and move replacement startup windows back there without following focus. This works around Steam replacing its loading window with a new main window; Steam does not provide a reliable way to disable that splash while still opening the client.

## Local-only programs

The Niri configuration contains shortcuts for programs that are not installed by the bootstrap script:

- LibreWolf
- Nautilus
- Handy at `~/Applications/handy.appimage`

Adjust or remove those bindings in `niri/.config/niri/config.kdl` when using the configuration on another machine.
