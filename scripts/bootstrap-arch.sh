#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
packages=(shell starship alacritty tmux niri noctalia nvim fastfetch rmpc swaylock)

sudo pacman -S --needed \
  git stow zsh zoxide starship alacritty tmux neovim niri noctalia \
  fastfetch rmpc swaylock brightnessctl cliphist wl-clipboard wireplumber uv

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  case "$plugin" in
    zsh-autosuggestions) repo="https://github.com/zsh-users/zsh-autosuggestions.git" ;;
    zsh-syntax-highlighting) repo="https://github.com/zsh-users/zsh-syntax-highlighting.git" ;;
  esac

  destination="$HOME/.oh-my-zsh/custom/plugins/$plugin"
  [[ -d "$destination" ]] || git clone --depth=1 "$repo" "$destination"
done

stow --no-folding --restow --dir="$repo_dir" --target="$HOME" "${packages[@]}"
