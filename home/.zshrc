# VARS
export VISUAL="${EDITOR}"
export EDITOR='nvim'
export TERMINAL='alacritty'
export BROWSER='firefox'
export HISTORY_IGNORE="(ls|cd|pwd|exit|startx|reboot|shutdown|sudo su|sudo reboot|history|cd -|cd ..)"

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

# HISTORY
HISTFILE=$HOME/.config/zsh/zhistory
HISTSIZE=5000
SAVEHIST=5000

# ZSH OPTIONS
setopt AUTOCD              # change directory just by typing its name
setopt PROMPT_SUBST        # enable command substitution in prompt
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED		     # The completion menu takes less space.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt HIST_IGNORE_DUPS	   # Do not write events to history that are duplicates of previous events
setopt HIST_FIND_NO_DUPS   # When searching history don't display results already cycled through twice
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.

# PROMPT
eval "$(starship init zsh)"

# PLUGINS
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-autoswitch-virtualenv/zsh-autoswitch-virtualenv.plugin.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ALIAS
alias mirrors="sudo reflector --verbose --latest 5 --country 'India' --age 6 --sort rate --save /etc/pacman.d/mirrorlist"

alias clean="paru -Sc --noconfirm && sudo pacman -Scc --noconfirm"
alias purga="sudo pacman -Rns $(pacman -Qtdq) ; sudo fstrim -av"
alias update="Updates --update-system"
alias autoremove="sudo pacman -R $(pacman -Qdtq)"
alias checkupdates="Updates --get-updates"
alias list="Updates --print-updates"
alias config="code ~/.dotfiles/"

alias scan_wifi="nmcli dev wifi rescan && nmcli dev wifi"

# tools
alias h='htop'
alias v='nvim'
alias c='bat'
alias f='ranger'
alias p='poetry'

# git
alias g='git'
alias ga='git add'
alias gcl='git clone'
alias gc='git commit'
alias gm='git merge'
alias gl='git pull'
alias gp='git push'

# ls
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Python
alias penv="python -m venv .venv"
alias activate="source .venv/bin/activate"
alias pi="python -m pip install"
alias pl="python -m pip list"
alias pf="python -m pip freeze"
alias pu="python -m pip install --upgrade pip"
alias pti="poetry install"

# helpers
alias smk='sudo make install'
alias wt='curl wttr.in'
alias tar='tar -xf'
alias wget="wget -c"
alias fr="free -h --si"
alias fs="df --si"
alias lg="lazygit"
alias zshrc="v ~/.zshrc"

# AUTO START
if [[ $WM != "bspwm" ]]; then
 clear && startx
fi
