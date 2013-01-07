env_directory="$( dirname "${BASH_SOURCE[0]}" )"

shopt -s checkwinsize
shopt -s histappend

export EDITOR=vim
export VISUAL=vim
export PSQL_EDITOR="/usr/bin/vim -c ':set ft=sql'"
export HISTCONTROL=ignoreboth
export HISTFILE=~/.bash_history
export HISTFILESIZE=10000
export HISTSIZE=10000
export LESS='-iMFXSx4R'
export PAGER=less
export PATH="$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/X11:/usr/games"
export SP_ENCODING=XML

alias df='df -x tmpfs -x usbfs'
alias gpg=gpg2
alias grep='LC_ALL=C grep --color=auto'
alias hsot='host'
alias la='ls -lAF --color=auto'
alias ll='ls -lF --color=auto'
alias ls='ls -lF --color=auto'
alias modver="perl -e\"eval qq{use \\\$ARGV[0];\\\\\\\$v=\\\\\\\$\\\${ARGV[0]}::VERSION;};\ print\\\$@?qq{No module found\\n}:\\\$v?qq{Version \\\$v\\n}:qq{Found.\\n};\"\$1"
alias mtr='mtr --curses'

which htop >/dev/null 2>&1 && alias top="htop"

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'


if [[ -e $env_directory/.bcrc ]]
then
    export BC_ENV_ARGS="$env_directory/.bcrc"
fi

if [[ -e "$env_directory/.bashrc-local" ]]
then
    source "$env_directory/.bashrc-local"
fi
