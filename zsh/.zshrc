# ============================================================
#  ~/.zshrc
# ============================================================
#
export QT_QPA_PLATFORMTHEME=kde
export PATH="$HOME/.local/path:$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export TERMINAL=kitty

# -- Zinit install (single copy) --
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME/.git" ]]; then
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# -- History --
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_SPACE

# -- Shell options --
setopt autocd
setopt extendedglob
setopt notify
setopt hist_fcntl_lock
setopt interactivecomments
# -- dropped beep btw

# -- Key bindings --
bindkey -e
# -- Word-movement tiers --
# Ctrl+Arrow: stop at punctuation (/, \, ., , etc. act as separators)
my-forward-word-strict() { local WORDCHARS=''; zle forward-word }
my-backward-word-strict() { local WORDCHARS=''; zle backward-word }
my-backward-kill-word-strict() { local WORDCHARS=''; zle backward-kill-word }
my-kill-word-strict() { local WORDCHARS=''; zle kill-word }

zle -N my-forward-word-strict
zle -N my-backward-word-strict
zle -N my-backward-kill-word-strict
zle -N my-kill-word-strict

my-backward-kill-word-loose() { local WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'; zle backward-kill-word }
my-kill-word-loose() { local WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'; zle kill-word }
my-forward-word-loose() { local WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'; zle forward-word }
my-backward-word-loose() { local WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'; zle backward-word }
zle -N my-forward-word-loose
zle -N my-backward-word-loose
zle -N my-backward-kill-word-loose
zle -N my-kill-word-loose

bindkey '^[[1;5C' my-forward-word-strict    # Ctrl+Right
bindkey '^[[1;5D' my-backward-word-strict   # Ctrl+Left
bindkey '^[[1;2C' my-forward-word-loose     # Shift+Right
bindkey '^[[1;2D' my-backward-word-loose    # Shift+Left

bindkey '^H' my-backward-kill-word-strict      # Ctrl+Backspace
bindkey '^[[3;5~' my-kill-word-strict          # Ctrl+Delete
bindkey '^[[1;2~' my-backward-kill-word-loose  # Shift+Backspace (if kitty sends this)
bindkey '^[[3;2~' my-kill-word-loose           # Shift+Delete

# and ofc the obv
bindkey '^?'     backward-delete-char   # Backspace: delete one char back
bindkey '^[[3~'  delete-char            # Delete: delete one char forward

# -- Plugins (syntax-highlighting MUST be last) --
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit ice lucid wait'0'
zinit light joshskidmore/zsh-fzf-history-search

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=#585b70'
zinit light zsh-users/zsh-syntax-highlighting

bindkey '^[[Z' autosuggest-accept

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# -- Zinit annexes (required for annexes to work) --
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
(( ${+_comps} )) || compinit

command -v starship >/dev/null && eval "$(starship init zsh)"

# -- opam (OCaml) --
[[ -r "$HOME/.opam/opam-init/init.zsh" ]] && source "$HOME/.opam/opam-init/init.zsh" >/dev/null 2>&1
