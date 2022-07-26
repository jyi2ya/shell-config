[ -z "$(echo "X$-" | tr -dc i)" ] && return

umask 077

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
alias cc='cc -std=c99 -Wall -Werror -Wshadow -g -fsanitize=address -O0 -pedantic'

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
	[ -z "$1" ] && return

    (
    rr_fname="/tmp/rust_run_$$.bin"
    rustc "$@" -o "$rr_fname" || return
    eval "$rr_fname"
    rm -f "$rr_fname"
    )
}

cn() {
	[ -z "$1" ] && return
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
alias docker='sudo docker'
alias dr='docker run'
alias dps='docker ps'
alias sd='sudo docker'
alias sdr='sudo docker run'
alias dl='docker load'
alias di='docker image'
alias dc='docker container'

# sudos
alias reboot='sudo reboot'
alias poweroff='sudo poweroff'

# ls
alias la='ls -A'
alias ll='ls -lh'
alias lt='ls -hsS1'
alias ls='ls -F'

# grep
alias xg='xargs grep'
alias gv='grep -v'
alias gi='grep -i'
alias giv='grep -vi'
alias eg='egrep'

# Single-char aliases
alias a='ls -A'

c() {
	if [ -t 0 ] && [ "$#" -ge 2 ]; then
		cp "$@"
	else
		clip "$@"
	fi
}

alias d='sudo docker'
alias e='unar'

f() {
    unset f_expect_find
	if ! [ -t 0 ]; then
		file -
	elif [ -z "$1" ]; then
		find .
	else
		for f_local_i in "$@"; do
            if [ "$(echo "$f_local_i" | cut -c1-1)" = '-' ]; then
                f_expect_find=y
				break
			fi
		done
		if [ -n "$f_expect_find" ]; then
			find "$@"
		else
			file "$@"
		fi
	fi
}

alias g='grep'
alias h='head'
alias i='sudo apt install'
alias j='jobs -l'
alias l='ls'

m() {
	if [ -z "$1" ]; then
		echo too few arguments
	elif [ -z "$2" ]; then
		mv "$1" .
	else
		mv "$@"
	fi
}

o() {
    for o_i in "$@"; do
        xdg-open "$o_i"
    done
}

p() {
	if [ -z "$1" ] && [ -t 0 ]; then
		pwd
	else
		less -F "$@"
	fi
}

alias r='rm'
alias s='sort'
alias t='task'
alias u='au'
alias v='vi'

w() {
	if [ -z "$1" ]; then
        command w
	else
        which "$@"
	fi
}

alias x='xargs '

# Tools
alias ....='cd ../../../'
alias ...='cd ../..'
alias bc='bc -lq'
alias cow='curseofwar -W18 -H20'
alias cpv='rsync -ah --info=progress2'
alias cr='cargo run'
alias ct='column -t'
alias gb='iconv -fgb18030 -tutf8'
alias mkd='mkdir'
alias nms='nms -cs -f white'
alias nsend='nc -l -p 6737 -q 1'
alias rl='exec dash'
alias root='sudo su -'
alias sck='shellcheck -Cauto -s sh'
alias vdf='vimdiff'
alias wl='wc -l'

saveshot() {
    saveshot_cnt=0
    while [ -f "$(printf '%03d' $saveshot_cnt).png"  ]; do
	    saveshot_cnt=$((saveshot_cnt + 1))
    done
    xclip -selection clipboard -t image/png -o > "$(printf '%03d' $saveshot_cnt).png"
}

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
alias vi='vim'

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

EDITOR="vim"
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH EDITOR

PS1='$ '

export WINEDEBUG=-all
