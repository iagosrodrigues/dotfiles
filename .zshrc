# Enable colors and change prompt
autoload -U colors && colors

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_EXPIRE_DUPS_FIRST # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS       # Don't record an entry that was just recorded again
setopt HIST_IGNORE_SPACE      # Don't record entries starting with a space
setopt HIST_VERIFY           # Show command with history expansion before running it
setopt HIST_FIND_NO_DUPS     # Do not display duplicates when searching

# Basic auto/tab completion
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # Include hidden files in completion

# vi mode
# bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# Better searching in command mode
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Directory navigation
setopt AUTO_PUSHD           # Push the current directory visited on the stack
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT        # Do not print the directory stack after pushd or popd

# General options
setopt AUTO_CD              # If a command is issued that can't be executed as a normal command,
                           # and the command is the name of a directory, perform the cd command to that directory
setopt EXTENDED_GLOB        # Use extended globbing syntax
setopt NO_CASE_GLOB        # Case insensitive globbing
setopt NUMERIC_GLOB_SORT   # Sort filenames numerically when it makes sense

# Custom functions

# Extract various archive formats
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2) tar xjf $1 ;;
            *.tar.gz)  tar xzf $1 ;;
            *.bz2)     bunzip2 $1 ;;
            *.rar)     unrar x $1 ;;
            *.gz)      gunzip $1 ;;
            *.tar)     tar xf $1 ;;
            *.tbz2)    tar xjf $1 ;;
            *.tgz)     tar xzf $1 ;;
            *.zip)     unzip $1 ;;
            *.Z)       uncompress $1 ;;
            *.7z)      7z x $1 ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

. "$HOME/.atuin/bin/env"

eval "$(mise activate zsh)"

if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

# Load external tools
if [[ -o interactive ]]
then
    # Initialize starship prompt
    eval "$(starship init zsh)"
    
    # Initialize zoxide for smart directory jumping
    eval "$(zoxide init zsh)"

    eval "$(atuin init zsh --disable-up-arrow)"
    
    # Add syntax highlighting if installed
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi
    
    # Add autosuggestions if installed
    if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi

    _aichat_zsh() {
        if [[ -n "$BUFFER" ]]; then
            local _old=$BUFFER
            BUFFER+="⌛"
            zle -I && zle redisplay
            BUFFER=$(aichat -e "$_old")
            zle end-of-line
        fi
    }

    zle -N _aichat_zsh
    bindkey '^e' _aichat_zsh
fi

