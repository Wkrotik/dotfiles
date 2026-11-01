# Dotfiles

GNU Stow packages for the current Niri, Noctalia, Alacritty, Starship, tmux and LazyVim setup.

## Install on Arch Linux

```bash
git clone https://github.com/Wkrotik/dotfiles ~/.dotfiles
cd ~/.dotfiles
./scripts/bootstrap-arch.sh
```

The bootstrap script installs the required packages, keeps Oh My Zsh and its plugins outside this repository, and stows the active configuration packages.

## Stow manually

```bash
stow --no-folding --restow --target="$HOME" \
  shell starship alacritty tmux niri noctalia nvim \
  fastfetch rmpc swaylock
```

Each top-level application directory is an independent Stow package. `--no-folding` keeps runtime-generated files out of the repository unless the file is explicitly tracked.

## Wallpaper colors

Noctalia uses the current wallpaper with the `m3-tonal-spot` scheme and generates colors for Niri, Alacritty, Starship, tmux, GTK, Qt and btop. Wallpapers remain in `wallpapers/` because Noctalia reads them directly from the repository.
