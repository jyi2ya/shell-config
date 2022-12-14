#!/bin/sh

if [ -r /proc/version ] && grep -q microsoft /proc/version; then
	alias xdg-open='explorer.exe'
	alias n='notepad.exe'
	PATH="$PATH:/mnt/d/bin:/mnt/c/Program Files (x86)/Arduino"
fi

mkdir -p ~/.local/share/vim/shada/
mkdir -p ~/.local/share/vim/swap/
mkdir -p ~/.local/share/vim/undo/

if command -v perl > /dev/null; then
    mkdir -p ~/.local/bin
    PATH="$HOME/.local/bin${PATH:+:${PATH}}"
    PERL5LIB="$HOME/.local/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
    PERL_LOCAL_LIB_ROOT="$HOME/.local${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
    PERL_MB_OPT="--install_base \"$HOME/.local\""
    PERL_MM_OPT="INSTALL_BASE=$HOME/.local"
    export PERL5LIB PERL_LOCAL_LIB_ROOT PERL_MB_OPT PERL_MM_OPT PATH
fi

if [ -r "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

export WINEDEBUG=-all
export GOPATH="$HOME/.cargo/target"
