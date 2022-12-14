#!/bin/sh

case $- in
    *i*) ;;
      *) return;;
esac

umask 022

# safety
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias rm='rm -I --preserve-root'
alias chown='chown'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Git
alias cg='cd `git rev-parse --show-toplevel || echo .`'
alias gaA='git add -A'
alias gad='git add'
alias gbc='git branch'
alias gcm='git commit'
alias gco='git checkout'
alias gst='git status'
alias glg='git log --graph'
alias gmg='git merge'
alias gdf='git diff'
alias gps='git push'
alias gpl='git pull'
alias gin='git init'
alias gbl='git blame'
alias grm='git rm'

if command -v xclip >/dev/null; then
    gcl() {
        if [ -n "$1" ]; then
            git clone "$@"
        else
            git clone "$(xclip -selection clipboard -o)"
        fi
    }
else
    alias gcl='git clone'
fi


# gcc
alias cc='cc -std=c11 -Wall -Werror -Wshadow -Og -g -fsanitize=address -pedantic'

# rust
alias cr='cargo run'
alias crr='cargo run --release'
alias co='cargo doc --open'
alias cb='cargo build --release'
alias ci='cargo init'
alias cl='cargo rustc -- --emit=llvm-ir'
alias cu='cargo update'
alias rc='rustc'

rr() {
	[ $# = 0 ] && return

    (
    rr_fname="/tmp/rust_run_$$.bin"
    rustc "$@" -o "$rr_fname" || return
    eval "$rr_fname"
    rm -f "$rr_fname"
    )
}

cn() {
	[ $# = 0 ] && return
	cargo new "$@"
	for cn_opt in "$@"; do
		if [ -d "$cn_opt" ]; then
			cd "$cn_opt" || return # make shellcheck happy
			return
		fi
	done
}

# apt
alias apt='sudo apt'
alias sa='apt'
alias au='sudo apt update && sudo apt upgrade && sudo apt full-upgrade && sudo apt-file update && apt autoremove'
alias ai='sudo apt install'
alias ali='apt list --installed'
alias al='apt list'
alias af='apt-file -x find'
alias ap='apt purge'
alias aar='apt autoremove'

# docker
alias dr='docker run'
alias dps='docker ps'
alias sd='sudo docker'
alias sdr='sudo docker run'
alias dl='docker load'
alias di='docker image'
alias dc='docker container'

# poweroff & reboot
alias reboot='sudo reboot'
alias rbt='reboot'
alias poweroff='sudo poweroff'

# ls
alias la='ls -A'
alias ll='ls -lh'
alias lt='ls -hsS1'
alias ls='ls -F'

# grep
alias xg='xargs -0 grep'
alias gv='grep -v'
alias gi='grep -i'
alias giv='grep -vi'
alias ge='egrep'

# Single-char aliases
alias a='ls -A'

c() {
	if [ -t 0 ] && [ "$#" -ge 2 ]; then
		cp "$@"
	else
		clip "$@"
	fi
}

alias d='docker'
alias e='unar'

f() {
	if [ -t 0 ]; then
        if [ $# -eq 0 ]; then
            find .
        elif [ $# -eq 1 ] && [ -d "$1" ]; then
            find "$@"
        else
            f_want_find=n
            for f_local_i in "$@"; do
                if [ "${f_local_i%"${f_local_i#?}"}" != '-' ] && ! [ -e "$f_local_i" ] && ! [ -h "$f_local_i" ]; then
                    f_want_find=y
                    break
                fi
            done
            if [ "$f_want_find" = y ]; then
                find "$@"
            else
                file "$@"
            fi
        fi
    else
		file -
    fi
}

alias g='grep'
alias h='head'
alias i='sudo apt install'

j() {
    if [ $# = 0 ]; then
        jobs -l
    else
        jrnl "$@"
    fi
}

alias l='ls'

m() {
	if [ $# = 0 ]; then
		echo too few arguments
	elif [ $# = 1 ]; then
		mv "$1" .
	else
		mv "$@"
	fi
}

o() {
    for o_i in "$@"; do
        xdg-open "$o_i" &
    done
}

p() {
	if [ -t 0 ]; then
        if [ $# = 0 ]; then
            pueue status
        elif [ -r "$1" ]; then
            less -F "$@"
        else
            pueue "$@"
        fi
	else
		less -F "$@"
	fi
}

alias r='rm'

s() {
    if [ -t 0 ]; then
        ssh "$@"
    else
        sort "$@"
    fi
}

t() {
    if [ -t 0 ]; then
        task "$@"
    else
        tail "$@"
    fi
}

u() {
    if [ -t 0 ]; then
        au "$@"
    else
        uniq "$@"
    fi
}

alias v='vi'

w() {
	if [ $# = 0 ]; then
        command w
	else
        command -v "$@"
	fi
}

alias x='xargs '

# Tools
alias ....='cd ../../../'
alias ...='cd ../..'
alias bc='bc -lq'
alias chomp='tr -d "\n"'
alias cls='clear'
alias cow='curseofwar -W18 -H20'
alias cpv='rsync -ah --info=progress2'
alias cr='cargo run'
alias ct='column -t'
alias fmt='fmt -s'
alias gb='iconv -fgb18030 -tutf8'
alias ipa='ip a'
alias jt='jrnl @tech'
alias mkd='mkdir'
alias nms='nms -cs -f white'
alias nsend='nc -Nnvlp 6737 -q 1'
alias pad='pueue add '
alias rl='exec dash'
alias root='sudo su -'
alias sck='shellcheck -Cauto -s sh'
alias sr='sort -R'
alias tf='tail -f'
alias vdf='vimdiff'
alias wk='genact -m cc'
alias wl='wc -l'

vw() {
    vi "$(which "$@")"
}

fw() {
    file "$(which "$@")"
}

ag() {
    ag_pattern="$1"
    [ -z "$ag_pattern" ] && return
    shift
    if [ -z "$*" ]; then
        find . -type f -exec grep -P -H "$ag_pattern" '{}' \;
    else
        find . -type f -a \( "$@" \) -exec grep -P -H "$ag_pattern" '{}' \;
    fi
}

md()
{
	if [ -z "$2" ]; then
		mkdir "$1" || return
		cd "$1" || return # make shellcheck happy
	else
		mkdir "$@"
	fi
}

fk() {
    if command -v fzf; then
        fk_pid=$(ps -ef | sed 1d | fzf -m --tac | awk '{print $2}')

        if [ -n "$fk_pid" ]; then
            echo "$fk_pid" | xargs kill -"${1:-9}"
        fi
    fi
}

oe() {
    [ -z "$1" ] && return 1
    nohup xdg-open "$@" >/dev/null 2>&1 &
    exit
}

# Vim
if command -v vim >/dev/null; then
    EDITOR="vim"
    alias vi='vim'
fi

if command -v vi >/dev/null; then
    EDITOR="vi"
fi

export EDITOR

# Fix typo
alias lw='wl'
alias sl='ls'
alias iv='vi'
alias josb='jobs'
alias lr='rl'
alias dm='md'
alias ig='gi'
alias oo='o'
alias ooo='o'
alias cla='cal'

for path in "$HOME/.bin" "$HOME/.local/bin" "$HOME/bin"; do
    PATH="$path${PATH:+":"}$PATH"
done

export PATH

PS1="$USER@$(uname -n)"
if [ "$(id -u)" = 0 ]; then
    PS1="$PS1 # "
else
    PS1="$PS1 \$ "
fi
