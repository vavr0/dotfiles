# ── Environment ──────────────────────────────────────────────

export PI_CODING_AGENT_DIR="$HOME/.config/pi"
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'

   # Personal executables. Nix manages the system PATH.
   typeset -U path
   path=("$HOME/.local/bin" "$HOME/bin" $path)

   # Keep any existing history; create a location if none is configured.
   if [[ -z "$HISTFILE" ]]; then
       mkdir -p "$HOME/.local/state/zsh"
       HISTFILE="$HOME/.local/state/zsh/history"
   fi

   HISTSIZE=100000
   SAVEHIST=100000

   setopt APPEND_HISTORY
   setopt SHARE_HISTORY
   setopt HIST_IGNORE_DUPS
   setopt HIST_FIND_NO_DUPS
   setopt HIST_REDUCE_BLANKS
   setopt HIST_IGNORE_SPACE


   # ── fzf ──────────────────────────────────────────────────────

   export FZF_DEFAULT_OPTS='
   --bind=ctrl-j:down,ctrl-k:up
   --border
   --layout=reverse
   --height=80%
   '

   export FZF_CTRL_R_OPTS='
   --sort
   --prompt="History> "
   --pointer="▶"
   --marker="✓"
   '

   if (( $+commands[fd] )); then
       export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
       export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
       export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
   fi

   # File preview: use bat when installed, otherwise plain text.
   export FZF_CTRL_T_OPTS='
   --preview "if command -v bat >/dev/null 2>&1; then
   bat --style=numbers --color=always --line-range :500 -- {}
else
    head -n 500 -- {}
    fi"
    --preview-window=right:60%
    '

   # Directory preview: eza → tree → ordinary ls.
   export FZF_ALT_C_OPTS='
   --preview "if command -v eza >/dev/null 2>&1; then
   eza --tree --level=2 --color=always --icons=always -- {}
elif command -v tree >/dev/null 2>&1; then
    tree -C -L 2 -- {}
else
    ls -la -- {}
    fi"
    --preview-window=right:50%
    '


   # ── Optional integrations ────────────────────────────────────

   # Initialize vi mode before fzf installs its keybindings.
   bindkey -v

   # Modern fzf supplies completion and keybindings through --zsh.
   if (( $+commands[fzf] )); then
       source <(fzf --zsh)
   fi

   if (( $+commands[jj] )); then
       source <(jj util completion zsh)
   fi

   if (( $+commands[zoxide] )); then
       eval "$(zoxide init zsh)"
   fi


   # ── Keybindings ──────────────────────────────────────────────

   autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
   zle -N up-line-or-beginning-search
   zle -N down-line-or-beginning-search

   # Search history using the text already typed.
   bindkey -M viins '^P' up-line-or-beginning-search
   bindkey -M viins '^N' down-line-or-beginning-search

   # NixOS loads autosuggestions; bind this only when its widget exists.
   if (( $+widgets[autosuggest-accept] )); then
       bindkey -M viins '^Y' autosuggest-accept
   fi

   # Sessionizer bindings can be added once the scripts exist:
   bindkey -M viins -s '^F' 'tmux-sessionizer\n'
   # bindkey -M viins -s '^[p' 'pdf-sessionizer\n'


   # ── Aliases ──────────────────────────────────────────────────

   alias vim='nvim'
   alias vi='nvim'
   alias v='nvim'
   alias c='clear'

   if (( $+commands[eza] )); then
       alias ls='eza --icons=always'
   fi

   if (( $+commands[fastfetch] )); then
       alias ff='fastfetch'
   fi
