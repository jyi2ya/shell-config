echo "X$-" | grep -vq i && return

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
        if [ -z "$1" ]; then
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
alias cb='cargo build --release'
alias ci='cargo init'
alias cl='cargo rustc -- --emit=llvm-ir'
alias cu='cargo update'
alias rc='rustc'

rr() {
	[ -z "$@" ] && return
	rr_fname="/tmp/rust_run_$RANDOM.bin"
	rustc "$@" -o "$rr_fname" || return
	eval "$rr_fname"
	rm -f "$rr_fname"
}

cn() {
	[ -z "$@" ] && return
	cargo new "$@"
	for cn_opt in "$@"; do
		if [ -d "$cn_opt" ]; then
			cd "$cn_opt"
			break
		fi
	done
}

# apt
alias apt='sudo apt'
alias sa='apt'
alias au='sudo apt update && sudo apt upgrade && sudo apt full-upgrade && sudo apt-file update'
alias ai='sudo apt install'
alias ali='apt list --installed'
alias al='apt list'
alias af='apt-file find'
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
	if ! [ -t 0 ]; then
		file -
	elif [ -z "$1" ]; then
		find
	else
		for f_local_i in "$@"; do
			if [ "${f_local_i:0:1}" = '-' ]; then
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

alias o='xdg-open'

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

ag() {
    ag_pattern="$1"
    [ -z "$ag_pattern" ] && return
    shift
    if [ -z "$*" ]; then
        find -type f -exec grep -P -H "$ag_pattern" '{}' \;
    else
        find -type f -a \( "$@" \) -exec grep -P -H "$ag_pattern" '{}' \;
    fi
}

md()
{
	if [ -z "$2" ]; then
		mkdir "$1" || return
		cd "$1"
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

EDITOR="vim"
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export PATH EDITOR

PS1='$ '
