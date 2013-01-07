#!/usr/bin/env bash

set -e
script_name="${BASH_SOURCE[0]}"
script_dir="$( dirname "$script_name" )"

cd "$script_dir"
script_dir="$( pwd -P )"

cd $HOME

OLDDIR=$( date '+old-%Y%m%d_%H%M%S' )
echo "Old dir: $OLDDIR"
mkdir "$OLDDIR"

while read dotfile
do
    just_name="$( basename "$dotfile" )"
    if [[ -e "$just_name" ]]
    then
        mv "$just_name" "$OLDDIR"
    fi
    ln -s "$dotfile" "$just_name"
done < <( find "$script_dir" -mindepth 1 -maxdepth 1 -name '.*' ! -name .ssh ! -name .git )

if [[ -e .ssh ]]
then
    echo ".ssh exists, modifications skipped"
else
    mkdir -pv .ssh/sockets
    cp -v "$script_dir"/.ssh/* .ssh/
    chmod go-rwx .ssh/*
fi

mkdir -p bin/
while read dotfile
do
    just_name="$( basename "$dotfile" )"
    if [[ -e bin/"$just_name" ]]
    then
        mv "$just_name" "$OLDDIR"
    fi
    ln -s "$dotfile" bin/"$just_name"
done < <( find "$script_dir"/bin -mindepth 1 -maxdepth 1 -type f )

echo "All done."

