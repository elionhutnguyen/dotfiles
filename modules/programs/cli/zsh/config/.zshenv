# Centralize XDG base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Editors
export EDITOR="nvim"
export VISUAL="nvim"

# Pager with bat integration
if command -v bat >/dev/null 2>&1; then
  export MANPAGER="bat -l man -p"
fi

# GPG configuration
export GPG_TTY=$(tty)

# Starship Prompt configuration pointing to the XDG folder
export STARSHIP_CONFIG="$ZDOTDIR/starship.toml"

# Local user binaries
export PATH="$HOME/.local/bin:$PATH"

# Source AI environment credentials if present
if [[ -f "$XDG_STATE_HOME/secrets/ai.env" ]]; then
  source "$XDG_STATE_HOME/secrets/ai.env"
fi
