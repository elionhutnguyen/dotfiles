# Basic Aliases
alias ll="ls -la"
alias rebuild="sudo nixos-rebuild switch --flake ~/dotfiles#elio"

# History Configuration
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
