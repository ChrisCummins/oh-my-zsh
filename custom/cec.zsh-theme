collapse_pwd() {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

prompt_char() {
    local prompt_char=''

    git branch >/dev/null 2>&1 && {
        prompt_char='*'$prompt_char
    }


    if (( $UID != 0 )); then
        prompt_char=$prompt_char'$'
    else
        prompt_char=$prompt_char'#'
    fi

    echo $prompt_char
}

battery_charge() {
    echo `$BAT_CHARGE` 2>/dev/null
}

virtualenv_info() {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

git_dirty_info() {
    git branch >/dev/null 2>&1 || { return; }

    local info=''
    local modified=$(git status --porcelain | grep -c '^ M')
    local new=$(git status --porcelain | grep -c '^??')
    local deleted=$(git status --porcelain | grep -c '^ D')

    if (( $modified )); then info=$info', M'$modified; fi
    if (( $new ));      then info=$info', ?'$new; fi
    if (( $deleted ));  then info=$info', D'$deleted; fi

    echo ${info:2}
}

return_code() {
    echo "%(?..%{$fg_bold[red]%}% exit [$?] ↵%{$reset_color%}
)"
}

set_color_from_letter() {
    local keycode=$(printf '%d' \'$1)
    local modcode=$(expr $keycode % 7)

    tput setaf $modcode
}

PROMPT='$(return_code)$(tput bold)$(set_color_from_letter $USER)%n%{$reset_color%}@$(set_color_from_letter $HOST)%m$reset_color%} in %{$fg_bold[white]%}$(collapse_pwd)%{$reset_color%}$(git_prompt_info)
$(virtualenv_info)$(prompt_char) '

RPROMPT='$(battery_charge)'

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✘%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"
