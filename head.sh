#!/bin/sh

case $- in
    *i*) ;;
      *) return;;
esac

if command -v tmux >/dev/null && [ -z "$TMUX" ] && [ -n "$SSH_TTY" ]; then
    exec sh -c 'tmux attach-session -t X || tmux new-session -s X'
fi
