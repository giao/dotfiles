#!/bin/bash

# This script is intended to run as:
# wget -O - -q http://svn.depesz.com/svn/environment/take-environment.sh | bash -

set -e
cd $HOME

OLDDIR=$( date '+old-%Y%m%d_%H%M%S' )
echo "Old dir: $OLDDIR"
mkdir "$OLDDIR"

if [[ -e .environment ]]
then
    mv .environment "$OLDDIR"
fi

svn co http://svn.depesz.com/svn/environment/ .environment

for dotfile in .bash_profile  .bashrc  .bcrc  .inputrc  .perltidyrc  .psqlrc  .screenrc .vim  .vimrc .tmux.conf
do
    if [[ -e "$dotfile" ]]
    then
        mv "$dotfile" "$OLDDIR"
    fi
    ln -s ".environment/$dotfile" $dotfile
done

if [[ ! -e .ssh ]]
then
    mkdir .ssh
fi

if [[ -e .ssh/config ]]
then
    echo ".ssh/config exists - skipping"
    exit
fi

cp .environment/.ssh/config .ssh
if [[ ! -e .ssh/sockets ]]
then
    mkdir .ssh/sockets
fi

echo "All done."

