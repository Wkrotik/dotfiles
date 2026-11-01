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
| `niri` | `~/.config/niri` |
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

Noctalia derives the active palette from the current wallpaper using the `m3-tonal-spot` scheme. It generates colors for:

- Niri
- Alacritty
- Starship
- tmux
- GTK 3 and GTK 4
- Qt
- btop

Noctalia's GUI-managed runtime state under `~/.local/state/noctalia` is intentionally not tracked.

## Local-only programs

The Niri configuration contains shortcuts for programs that are not installed by the bootstrap script:

- LibreWolf
- Nautilus
- Handy at `~/Applications/handy.appimage`

Adjust or remove those bindings in `niri/.config/niri/config.kdl` when using the configuration on another machine.
