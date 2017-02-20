# env directory is usually the same as $HOME
env_directory="$( dirname "${BASH_SOURCE[0]}" )"

# dotfiles directory is path to where dotfiles were cloned/copied to.
dotfiles_directory="$( dirname "$( readlink -f "${BASH_SOURCE[0]}" )" )"

if [[ -e "$env_directory/.bashrc" ]]
then
    source "$env_directory/.bashrc"
fi

# Helper function to attach to existing SSH Agent socket, in case environment
# got broken
steal_ssh_agent() {
    # Generate data about existing (and accessible) SSH Agent sockets
    # Format is:
    # loaded_key_count socket_creation_time socket_path list_of_loaded_keys_base64_encoded
    # Data is sorted numerically, so last line will have the most keys, and if
    # multiple sockets have the same number of keys - newest socket will be last
    sockets_data="$(
        for socket in /tmp/ssh*/*
        do
            # Gets list of loaded keys from given SSH Socket
            socket_keys="$( SSH_AUTH_SOCK="$socket" timeout 5 ssh-add -l 2> /dev/null )"
            key_count="$( echo "${socket_keys}" | wc -l )"

            # If there are no loaded keys, there is no point in showing it
            (( 0 == "$key_count" )) && continue

            # Get timestamp (seconds from epoch) for when the socket was
            # created (to pick newest one).
            socket_created="$( stat -c '%Y' "$socket" )"

            # Return formatted data
            printf "%d %d %s %s\n" "$key_count" "$socket_created" "$socket" "$( echo "${socket_keys}" | base64 | tr -d '\n' )"
        done | sort -n
        )"

    socket_count="$( echo "${sockets_data}" | wc -l )"

    # Processing makes sense only if there are some keys...
    if (( 0 == "${socket_count}" ))
    then
        echo "There are no available SSH sockets with loaded keys." >&2
    else
        if (( 1 == "${socket_count}" ))
        then
            echo "Available socket:"
        else
            echo "Available sockets:"
        fi

        # i is loop counter, to find out which key is last.
        i=0
        while read key_count socket_created socket keys_data_base64
        do
            (( i++ ))

            # Command that can be used to set this socket.
            cmd="export SSH_AUTH_SOCK=${socket}"

            # Print socket info
            printf '%2d> %-60s # Created: %s\n' "$i" "$cmd" "$( date -d "@${socket_created}" +"%Y-%m-%d %H:%M:%S %Z" )"

            # also print list of keys in this agent
            echo "$keys_data_base64" | base64 -d - | nl | sed 's/^ */  /;s/\t/. /'

            # set env if this is last socket.
            if (( "$i" == "${socket_count}" ))
            then
                $cmd
            else
                echo
            fi
        done <<< "${sockets_data}"
        printf '\nPicked last socket.\n'
    fi
}

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
    if [[ ( -z "$TMUX" ) && ( ! -z "$SSH_CONNECTION" ) && ( -f "$dotfiles_directory/bin/tmux-auto-reattach" ) ]]
    then
        exec "$dotfiles_directory/bin/tmux-auto-reattach" -s -n shell bash -l
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
stty -ixon -ixoff 2> /dev/null
# Turn off flow control. It's XXI century, and our terminals have scrollbar.

export LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2ts=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.m3u=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:"

if [[ -e "$env_directory/.bash_profile-local" ]]
then
    source "$env_directory/.bash_profile-local"
fi
