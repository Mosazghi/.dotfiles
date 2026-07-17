# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="lambda"
source $ZSH/oh-my-zsh.sh



# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="/usr/local/MATLAB/R2023b/bin:$PATH"
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
export PATH="$PATH:/opt/nvim-linux64/bin"
export VCPKG_ROOT="$HOME/vcpkg"
export PATH=$VCPKG_ROOT:$PATH

zstyle ':omz:update' frequency 13

# ENABLE_CORRECTION="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="mm/dd/yyyy"

plugins=(git themes zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

# User configuration

export MANPATH="/usr/local/man:$MANPATH"

_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet
#source "$HOME/.cargo/env"
. "$HOME/.cargo/env"   
export PATH="$PATH:/home/mosa/.local/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export HISTFILESIZE=10000000
export HISTSIZE=10000000
export HISTFILE=~/.zsh_history

setopt HIST_FIND_NO_DUPS
# following should be turned off, if sharing history via setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

zstyle ':completion:*' list-prompt   ''
zstyle ':completion:*' select-prompt ''
zstyle ':fzf-tab:complete:cd:*' fzf-preview "ls --color $realpath"
fpath+=${ZDOTDIR:-~}/.zsh_functions
export BAT_THEME=gruvbox-dark
export QT_QPA_PLATFORM=xcb
export IDF_PATH=~/esp/esp-idf
export PATH=~/esp/xtensa-esp32-elf/bin:$PATH
export PATH=/path/to/mxe/usr/bin:$PATH
export PATH=$PATH:/usr/local/go/bin
#[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#source <(fzf --zsh)
# Aliases 
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias n="nvim"
alias ls="eza -lh --icons --git"
alias tree="eza --tree"
alias cat="bat"
alias kittyupdate="curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
alias get_idf='. $HOME/esp/esp-idf/export.sh'
alias idf="idf.py"
alias lg="lazygit"
alias idfb="idf build -DCMAKE_EXPORT_COMPILE_COMMANDS=1"
alias idff="idf flash"
alias idfr="idfb && idff"
alias idfrm="idfr && idf monitor"
alias lg="lazygit"
alias mr="mosquitto -v -c /etc/mosquitto/conf.conf"
alias py="python"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias ff="fastfetch"
alias open="xdg-open"


# fnm
FNM_PATH="/home/mosa/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

# pnpm
export PNPM_HOME="/home/mosa/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
eval "$(starship init zsh)"

export PATH="$(go env GOPATH)/bin:$PATH"

export EDITOR=nvim # for yazi


export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
eval "$(fnm env --use-on-cd)"

# fnm
FNM_PATH="/home/mosa/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi
