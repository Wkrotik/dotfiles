# Dotfiles

## What you will need
- Git
- Stow
- Oh my zsh

```sudo apt install git stow```
## Instructions to use
- ```git clone https://github.com/Wkrotik/dotfiles```
- cd into the cloned directory
- ```stow .```
- ```stow noctalia```

Noctalia is a separate Stow package because it shares `~/.config/noctalia` with runtime-managed files.

I gotta make a script for this, because it is now a dependency hell
