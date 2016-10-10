#
#                          CEC ZSHELL THEME
#
########################################################################
#
#                           Chris Cummins
#                       http://chriscummins.cc
#                    Thursday 25th September 2014
#
#                  GNU General Public License v3.0
#                http://www.gnu.org/copyleft/gpl.html
#
########################################################################
#


# Portability wrapper for Mac OS X:
#
#    Use the local machine name, not the reverse-DNS version returned
#      by `hostname'.
#    Pass the correct flags to `sed'.
#
if [[ "$(uname -s)" == "Darwin" ]]; then
    __CEC_ZSH_THEME_HOST=$(scutil --get ComputerName)
else
    __CEC_ZSH_THEME_HOST=$HOST
fi


# Get the current working directory, using UNIX style tilde notation
# in place of full paths for home directories. E.g. "~/", "~foo/".
#
__cec_zsh_theme_cwd() {
    local cwd="$(pwd | sed -e "s,^$HOME,~,;s,^/home/,~,;s,^/Users/,~,")"
    echo "\e[1m$cwd%{$reset_color%}"
}

# Get the prompt prefix, e.g. "$", "#", "(dev) *$", etc.
#
__cec_zsh_theme_prefix() {
    local prefix=''

    # Prefix prompt with (<$ENV>) environment variable, if set. This
    # can be used be scripts which spawn subshells in order to
    # indicate a non-standard environment.
    [ $ENV ] && { prefix='('`basename $ENV`') ' }

    # Set pound sign "#" or dollar sign "$" prefix character depending
    # on whether we're superuser or a normal user, respectively.
    if (( $UID != 0 )); then
        prefix=$prefix'$'
    else
        prefix=$prefix'#'
    fi

    echo $prefix
}

# Print a given string in a colour depending on the contents of the
# string. Iterate over input characters summing up their decimal char
# value, before modulating around 7 in order to produce a colour code.
#
__cec_zsh_theme_colourise() {
    local chars="$(echo $1 | sed -e 's/\(.\)/\1\n/g')"
    local total=3

    for c in $(echo $1 | sed -e 's/\(.\)/\1\n/g'); do
        local int=$(printf '%d' \'$c)
        total=$((total+int))
    done

    local modcode=$(expr $total % 7)
    local color=$(tput setaf $modcode)

    echo "$color$1$reset_color"
}


# Left hand side prompt.
#
# Shows the return code (if non-zero) of the previous command, the
# username and hostname, current directory, and git version control
# status.
PROMPT='\
%(?..%{$fg_bold[red]%}% exit [$?] ↵%{$reset_color%}
)\
$(tput bold)$(__cec_zsh_theme_colourise $USER)@$(tput bold)$(__cec_zsh_theme_colourise $__CEC_ZSH_THEME_HOST)\
 in $(__cec_zsh_theme_cwd)$(git_prompt_info)\
 at $(date '+%H:%M:%S')\

$(__cec_zsh_theme_prefix) '


# Right hand prompt.
#
# Show the current time in HH:MM:SS format.
# RPROMPT="$(date '+%H:%M:%S')"


ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✘%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"
