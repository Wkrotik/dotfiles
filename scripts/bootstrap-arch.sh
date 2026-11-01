#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
packages=(shell starship alacritty tmux niri noctalia nvim fastfetch rmpc swaylock)

sudo pacman -S --needed \
  git stow zsh zoxide starship alacritty tmux neovim niri noctalia \
  fastfetch rmpc swaylock brightnessctl cliphist fzf python-pillow wl-clipboard wireplumber uv

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

if command -v code >/dev/null; then
  code --install-extension noctalia.noctaliatheme --force ||
    printf 'Could not install NoctaliaTheme for Code OSS; install noctalia.noctaliatheme manually.\n' >&2
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

"$repo_dir/scripts/configure-equibop.py"

if command -v libreoffice >/dev/null; then
  "$repo_dir/scripts/configure-libreoffice.py" ||
    printf 'Could not configure LibreOffice; close it and run scripts/configure-libreoffice.py again.\n' >&2
fi
