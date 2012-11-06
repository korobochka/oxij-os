#!/bin/bash
# Find script

shopt -s dotglob
shopt -s nocasematch
shopt -s extglob

check_and_print()
{
    if [[ "${1##*/}" != $match ]];
    then
        return
    fi
    
    if [[ $type == "" ]] ||
       [[ ($type == "l" || ! -h $1) &&
       (($type == "c" && -c $1) ||
        ($type == "l" && -h $1) ||
        ($type == "p" && -p $1) ||
        ($type == "f" && -f $1) ||
        ($type == "d" && -d $1) ||
        ($type == "b" && -b $1) ||
        ($type == "s" && -S $1)) ]];
    then
       echo "${1//\/\///}"
    fi
}

list()
{
    for file in "$1"/*
    do
        check_and_print "$file"
        if [[ -d "$file" ]]
        then
            list "$file"
        fi
    done
}

match="*"


if [[ $2 == "-iname" ]]
then
    match=$3
fi
if [[ $4 == "-iname" ]]
then
    match=$5
fi
if [[ $2 == "-type" ]]
then
    type=$3
fi
if [[ $4 == "-type" ]]
then
    type=$5
fi

list "$1"
