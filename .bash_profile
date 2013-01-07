env_directory="$( dirname "${BASH_SOURCE[0]}" )"

if [[ -e "$env_directory/.bashrc" ]]
then
    source "$env_directory/.bashrc"
fi


# If you will run this function in your .bash_profile-local, when you'll log to the account via ssh, it will automatically start shared screen session.
# Thanks to this - screen will be always started when you work on this account (unless you'll work around not to run it).

screen_as_shell() {
    if [[ ( -z "$STY" ) && ( ! -z "$SSH_CONNECTION" ) ]]
    then
        COUNT="$( LC_ALL=C LANG=C screen -S shell -ls | grep -E '[^[:space:]]' | wc -l )"
        if [[ "$COUNT" -lt 3 ]]
        then
            exec screen -S shell
        fi
        exec screen -S shell -xRR
    fi
}

# Function below works just as screen_as_shell(), but uses tmux instead

tmux_as_shell() {
    if [[ ( -z "$TMUX" ) && ( ! -z "$SSH_CONNECTION" ) && ( -f "$env_directory/.environment/bin/tmux-auto-reattach" ) ]]
    then
        exec "$env_directory/.environment/bin/tmux-auto-reattach" -n shell bash -l
    fi
}

# get current git branch info

get_git_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo " git:${ref#refs/heads/}"
}

USER_COLOR="0;32"
if (( $UID == 0 ))
then
    USER_COLOR="33;41"
fi

HOST_COLOR="0;32"
if [[ $OSTYPE =~ solaris ]]
then
    HOST_COLOR="0;34"
fi

if [[ "$HOST_COLOR" == "$USER_COLOR" ]]
then
    HOST_COLOR=''
else
    HOST_COLOR="\\[\033[${HOST_COLOR}m\\]"
fi

export PS1="\\[\033[0m\\]\\n\\[\033[1;30m\\]\\t \\[\033[${USER_COLOR}m\\]\u@${HOST_COLOR}\h\\[\033[0;36m\$( get_git_branch ) \\[\033[0;35m\]\\w\\[\033[0m\\]\\n=\\\$ "
export PS2="-\\\$ "

unset USER_COLOR
unset HOST_COLOR

# Turn off flow control. It's XXI century, and our terminals have scrollbar.
stty -ixon -ixoff
# Turn off flow control. It's XXI century, and our terminals have scrollbar.


if [[ -e "$env_directory/.bash_profile-local" ]]
then
    source "$env_directory/.bash_profile-local"
fi
