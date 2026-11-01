export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
zstyle ':omz:update' mode reminder
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

alias vim="nvim"
alias lserver="llama-server --models-preset $HOME/.config/llama.cpp/config.ini --models-max 1 --sleep-idle-seconds 900"

command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
command -v uv >/dev/null && eval "$(uv generate-shell-completion zsh)"
[[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/themes/noctalia.sh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/fzf/themes/noctalia.sh"

export EDITOR="nvim"
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
command -v starship >/dev/null && eval "$(starship init zsh)"

[[ -r "$HOME/.llama-completion.bash" ]] && source "$HOME/.llama-completion.bash"
