eval (/opt/homebrew/bin/brew shellenv)

fish_add_path /opt/homebrew/opt/rustup/bin
fish_add_path /Users/iagorodrigues/.local/bin

function _aichat_fish
    set -l _old (commandline)
    echo "RODOU"
    if test -n $_old
        echo -n "⌛"
        commandline -f repaint
        commandline (aichat -e $_old)
    end
end
bind \ee _aichat_fish

if status --is-interactive
    fnm env --use-on-cd --shell fish | source
    starship init fish | source
    zoxide init fish | source
    mise activate fish | source
end

# pnpm
set -gx PNPM_HOME "/Users/iagorodrigues/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

alias create-venv 'python3 -m venv .venv'
