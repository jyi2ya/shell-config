#!/bin/sh

for i in "$@"; do
    if [ -f "$i" ]; then
        cat "$i"
    fi
done
