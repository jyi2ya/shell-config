alias -- -='cd -'
alias rl='exec bash'

shopt -s autocd
shopt -s checkwinsize
shopt -s dotglob
# shopt -s failglob
shopt -s globstar
shopt -s histappend

HISTSIZE=999999999
HISTFILE="$HOME/.bash_history"
HISTTIMEFORMAT="%F %T "
HISTCONTROL=ignoredups
INPUTRC=/etc/inputrc

LAST_LS=$(command ls | sum)
LAST_PWD="$PWD"
_prompt_smart_ls()
{
	local this_ls
	this_ls=$(command ls | sum)
	if [ "$LAST_LS" != "$this_ls" ] || [ "$LAST_PWD" != "$PWD" ]; then
		LAST_LS="$this_ls"
		LAST_PWD="$PWD"
		ls
		return
	fi
}

_prompt_slow_command_tracer_init()
{
    CMD_START_TIME="$SECONDS"
    if [ -n "$DISPLAY" ]; then
        CMD_ACTIVE_WINDOW=$(xdotool getactivewindow)
    fi
}

_prompt_set_return_value() {
    prompt_return_value=$?
}

_prompt_show_return_value()
{
	test $prompt_return_value -ne 0 && printf '[%s] ' $prompt_return_value
}

_prompt_slow_command()
{
    local time_diff=$((SECONDS - CMD_START_TIME))
    local active_window
    local urgency="low"
    if [ "$prompt_return_value" != 0 ]; then
        urgency=critical
    fi

    if [ -n "$DISPLAY" ]; then
        active_window=$(xdotool getactivewindow 2>/dev/null)
        if [ -n "$CMD_ACTIVE_WINDOW" ] && [ "$active_window" != "$CMD_ACTIVE_WINDOW" ]; then
            notify-send -u "$urgency" "DONE $(date -u +%H:%M:%S --date="@$time_diff")" "$(fc -nl 0 | sed 's/^[[:space:]]*//')"
        fi
    fi
    [ $time_diff -lt 10  ] && return
    echo -n ">"
    date -u +%H:%M:%S --date="@$time_diff" | awk -F':' '{
    if ($1) printf("%dh ", $1);
    if ($1 || $2) printf("%dm ", $2);
    printf("%ds", $3);
}'
    echo -n "< "
    return
}

_prompt_append_history() {
    history -a
}

preexec_functions+=(_prompt_slow_command_tracer_init)
precmd_functions+=(_prompt_smart_ls)
precmd_functions+=(_prompt_set_return_value)

PS1='$(_prompt_show_return_value)$(_prompt_slow_command)\A \H$(__git_ps1) $(_prompt_fish_path)\n\j '

if [ -f /etc/bash_completion ]; then
    # shellcheck source=/dev/null
    source /etc/bash_completion
fi

if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    # shellcheck source=/dev/null
	source /usr/share/git-core/contrib/completion/git-prompt.sh
fi
