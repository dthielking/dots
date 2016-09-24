# Is this sufficient?
# zstyle :compinstall filename '/home/$USERNAME/.zshrc
#zstyle ':completion:*' auto-description 'specify: %d'
#zstyle ':completion:*' completer _expand _complete _correct _approximate
#zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
#zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' use-compctl false
#zstyle ':completion:*' verbose true
#
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

#setopt histignorealldups sharehistory

# Set up the prompt
zstyle ':completion:*:*:-command-:*:commands' group-name commands
zstyle ':completion:*:*:-command-:*:functions' group-name functions
# Keep 10000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.history

# Set umask to a more restrictive one
umask 077

# Enable autocompletion for commands, hostnames etc.
autoload -Uz compinit
compinit

# Doing menu completion for arrow keys
zstyle ':completion:*' menu
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' verbose true


# Use vi keybindings even if our EDITOR is set to emacs
bindkey -v

# zsh Options
# Notify bei Backgroundjob erst nach return
setopt NO_NOTIFY 
# Beenden der Backgroundjobs durch beenden der Shell deaktiviert
setopt NO_HUP 
# "Normales" Verhalten von Arrays beginn bei 0
setopt KSH_ARRAYS
# Restore der Vorherigen Optionen/Traps bei function change
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
# Nachfrage ausschalten ob rm * löschen darf
setopt RM_STAR_SILENT
# History erweitern und in allen Shells gleich
setopt SHARE_HISTORY
# Keine doppelten Eintraege in der History
setopt HIST_IGNORE_DUPS
# Leerzeichen loeschen
setopt HIST_REDUCE_BLANKS
# Generelles Beep aus
setopt NO_BEEP
# Beep aus bei Ende der History
setopt NO_HIST_BEEP
# Ohne 'cd' in Verzeichnisse wechseln
setopt AUTO_CD

# Some Aliases
alias ll='ls -l --color=auto'
alias la='ls -lA --color=auto'
alias l='ls -CF --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias hgrep='history 0 |grep --color=auto '
alias ggrep='git grep'
alias fuck='sudo !!'
alias please='sudo !!'

# Suffix Aliases
alias -s log=vim
alias -s pl=vim

setopt PROMPT_SUBST
# Erstellen des Prompts
# Linkes Prompt
tick='\u2713'
PS1='[%n@%m:%1~]%(?..(%F{red}%?%f%))%# '
# Rechtes Prompt
RPS1='%(t.[Ding!].%(t30.[Dong!].[%T])'


# Force to clear Terminal after every Logout
TRAPEXIT() {
  if [[ ! -o login ]]; then
  fi
}
