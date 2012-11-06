#!/bin/bash

shopt -s nullglob

QPATH=$HOME/.wgetqueue
LOCK=$QPATH/lock

mkdir -p "$QPATH" # do we need this?
mkdir -p "$QPATH/requests"
mkdir -p "$QPATH/newrequests"

for a in "$@"
do
    r=`mktemp --tmpdir="$QPATH/newrequests"`
    echo "$a" > "$r"
done

for a in "$QPATH/newrequests"/*
do
    mv "$a" "$QPATH/requests"
done

if mkdir ${LOCK}; then
  echo "Locking succeeded - we are first"
else
  echo "Lock failed - already running"
  exit 1
fi


exec >/dev/null
exec 2>/dev/null
exec < /dev/null

(
    trap "rm -rf '$LOCK'" 0
    trap "" HUP

    while [ 1 ]
    do
        for a in "$QPATH/requests"/*
        do
            url=`cat "$a"`
            rm "$a"
            wget -c "$url"
        done

        sleep 5
    done
) &
