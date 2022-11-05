#!/usr/bin/env zsh

TARGET_DIRECTORY=symlink

directories=($(find symlink -type d | sed -E "s@^symlink@$HOME@" | sort | uniq))
for directory in $directories
do
    mkdir -p $directory
done

files=($(find $TARGET_DIRECTORY -type f))
for file in $files
do
    link=$(echo $file | sed -E "s@^$TARGET_DIRECTORY@$HOME@")
    ln -sfnv $PWD/$file $link
done