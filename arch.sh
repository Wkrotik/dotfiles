#NOT DONE


#getting yay & stow
sudo pacman -S --needed git base-devel stow -y
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

cd
git clone https://github.com/Wkrotik/dotfiles
cd dotfiles
stow .
#all needed pkgs
yay -S --needed zsh brightnessctl fzf zoxite yazi kitty neovim appimagelauncher


#oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
