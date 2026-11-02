# File listings with eza
alias ls='eza --icons auto'
alias ll='eza -lh --icons --git'
alias la='eza -lah --icons auto --git'
alias tree='eza --tree --icons auto'
compdef eza=ls 2>/dev/null

# Replacements
alias cat='bat'
alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
alias vim='nvim'
alias -- -='cd -'

# Directory hopping wrapper for yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Git
alias glog='PAGER="less -F -X" git log'
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'
alias dotfiles='git --git-dir=$HOME/dotfiles/.git --work-tree=$HOME/dotfiles'
