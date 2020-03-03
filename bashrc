#===============================================================
#
# PERSONAL $HOME/.bashrc FILE for bash-2.04 (or later)
#              by Emmanuel Rouat
#
# This file is read (normally) by interactive shells only.
# Here is the place to define your aliases, functions and
# other interactive features like your prompt.
#
# This file was designed for Solaris
#
#===============================================================

GNU=0
OSX=0
FINK=0
export EDITOR="vim"
export SVN_EDITOR="vim"

if [ `uname -s` = "Darwin" ]; then
	OSX=1
	if [ -r /sw/bin/init.sh ]; then
		. /sw/bin/init.sh
		export PATH=/usr/local/bin:$PATH
		FINK=1
	fi
fi

if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
	HOMEBREW=1
	export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
	export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
fi

if [ -d ~/Library/Python/2.7/bin ]; then
	export PATH=~/Library/Python/2.7/bin:$PATH
fi
if [ -d ~/Library/Python/3.6/bin ]; then
	export PATH=~/Library/Python/3.6/bin:$PATH
fi
if [ -d ~/Library/Python/3.7/bin ]; then
	export PATH=~/Library/Python/3.7/bin:$PATH
fi
if [ -d ~/.local/bin ]; then
	export PATH=~/.local/bin:$PATH
fi

if [ -d ~/bin ]; then
	export PATH=~/bin:$PATH
fi



if [ -d ~/.pyenv ] && [ -z $PYENV_VIRTUALENV_INIT ]; then
  export PATH="~/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

vmake () {
	local version=${2:-3.7}
	if [ -d ~/.virtualenvs/$1 ]; then
		echo $1 already exists
		return -1
	fi
	python${version} -m venv ~/.virtualenvs/$1
}


vactivate () {
	source ~/.virtualenvs/$1/bin/activate
}

_vactivate () {
	local cur prev opts base
	COMPREPLY=()
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"
	opts=`ls --color=none ~/.virtualenvs/`
	COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
        return 0
}

function exists_and_execs()
{
    FNAME=`which $1`
    [ -n "$FNAME" -a -x "$FNAME" ]
}

complete -F _vactivate vactivate
#don't do anything if it's a dumb terminal because it could cause scp to fail
[ -z "$PS1" -o  $TERM == "dumb" ] && return

#-----------------------------------
# Source global definitions (if any)
#-----------------------------------

if [ -f /etc/bashrc ]; then
	. /etc/bashrc  # Read system bash init file, if exists.
fi


if [ -d "${FREE:=''}/bin" ]; then
	GNU=1
fi

if [ `uname` == "Linux" ]; then
	GNU=1
fi

if [ -x `which dircolors` ] ; then	# use gnu/free stuff
	eval `dircolors`
fi

#-------------------------------------------------------------
# Automatic setting of $DISPLAY (if not set already)
# This works for linux and solaris - your mileage may vary....
#-------------------------------------------------------------

#if [ -z ${DISPLAY:=""} ]; then
#    DISPLAY=$(who am i)
#    DISPLAY=${DISPLAY%%\!*}
    if [ -n ${DISPLAY:=''} ]; then
	export DISPLAY=$DISPLAY
    else
	export DISPLAY=""  # fallback
    fi
#fi


#---------------
# Some settings
#---------------

set -o notify
#set -o noclobber
#set -o ignoreeof
set -o nounset
#set -o xtrace		# useful for debuging

shopt -s cdspell
#shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s mailwarn
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s histappend histreedit
shopt -s extglob	# useful for programmable completion



#-----------------------
# Greeting, motd etc...
#-----------------------

# Define some colors first:
red='\033[0;31m'
RED='\033[1;31m'
blue='\033[0;34m'
BLUE='\033[1;34m'
cyan='\033[0;36m'
CYAN='\033[1;36m'
NC='\033[0m'		# No Color

# Looks best on a black background.....
if [ $TERM != "dumb" ]; then
  echo -en "${CYAN}This is BASH ${RED}${BASH_VERSION%.*}${CYAN} - DISPLAY "
  if [ -z $DISPLAY ] ; then
    echo -ne "${RED}off${NC}\n";
  else
    echo -en "on ${RED}$DISPLAY${NC}\n"
  fi
  date
fi

function _exit()	# function to run upon exit of shell
{
    echo -e "${RED}MMmm I smell brains.${NC}"
}
trap _exit 0

#---------------
# Shell prompt
#---------------


function fastprompt()
{
    unset PROMPT_COMMAND
    case $TERM in
	xterm | rxvt | dtterm )
	    PS1="[\h] \W > \[\033]0;[\u@\h] \w\007\]" ;;
	*)
	    PS1="[\h] \W > " ;;
    esac
}

function powerprompt()
{
    _powerprompt()
    {
       RET=$?
       #echo -e $RET
        if [ $RET -eq  0 ]; then
          COLOR='1;36m'
        else
          COLOR='1;31m'
        fi

        if [ -n "${TMUX:=""}" ]; then
            tmux setenv TMUXPWD_$(tmux display -p "#I_#P") "$PWD"
	    tmux setenv VIRTUAL_ENV_$(tmux display -p "#I_#P") "${VIRTUAL_ENV:=""}"
            tmux refresh-client -S
        fi
        case $TERM in
	    xterm* | dtterm | rxvt  )
	        echo -n -e "\033]0;$USER@${HOSTNAME%%.*}:${PWD/#$HOME/~}\007";;
	esac
    }
    PROMPT_COMMAND=_powerprompt
    _powerprompt
    EPS1='\$'

    case $TERM in
	xterm* | dtterm | rxvt  )
	    local SPS1="\[\033]0;\u@\h:\w\007\]";;
#	linux | vt100 )
#	    SPS1="\u@\h:\w";;
	* )
	    local SPS1="";;
    esac
    SPS1=""
    PS1="${SPS1}\u@\h:\w\[\033[\$COLOR\]$EPS1\[${NC}\] "
}

powerprompt	# this is the default prompt - might be slow
		# If too slow, use fastprompt instead....



#===============================================================
#
# ALIASES AND FUNCTIONS
#
# Arguably, some functions defined here are quite big
# (ie 'lowercase') but my workstation has 512Meg of RAM, so
# If you want to make this file smaller, these functions can
# be converted into scripts.
#
#===============================================================

#-------------------
# Personnal Aliases
#-------------------


if exists_and_execs "vim"; then
	alias vi=vim
fi

if exists_and_execs "nvim"; then
	alias vi=nvim
	alias vim=nvim
fi

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias path='echo -e ${PATH//:/\\n}'
alias finch='screen -S finch -p finch -RaAD -e^bB finch'
alias irssi='screen -S irssi -p irssi -RaAD -e^bB irssi -ckt'

#-----------------------------------------
# Environment dependent aliases/variables
#-----------------------------------------

export ircname=hbar
export PAGER="less -r"
export EDITOR="vim -X"

if [ $GNU -eq 1 ] ; then	# use gnu/free stuff
	alias vi='vi -X'
	alias csh='tcsh'
	alias du='du -h'
	alias df='df -kh'
	alias ls='ls -h --color=always'
	alias more='less'
elif [ $OSX -eq 1 ]; then
	export CLICOLOR=1
	export SVN_EDITOR=vi
	if [ $FINK -eq 1 ]; then
		if [ -x '/sw/bin/ls' ]; then
			alias ls='/sw/bin/ls --color=always'
		fi
		alias du='du -h'
		alias df='df -kh'
	fi
	if [ $FINK -eq 1 -o $HOMEBREW -eq 1 ]; then
	    alias ls='ls -h --color=always'
	fi
else				# use regular solaris stuff
	alias df='df -k'
	#alias ls='ls -F'
fi

#----------------
# a few fun ones
#----------------

function xtitle ()
{
    case $TERM in
        xterm-kitty)
	   return ;;
	xterm* | dtterm | rxvt)
	    echo -n -e "\033]0;$HOSTNAME:$*\007" ;;
	*)  ;;
    esac
}

alias top='xtitle Processes on $HOSTNAME && top'
alias make='xtitle Making $(basename $PWD) ; make'
alias ncftp="xtitle ncFTP ; ncftp"

#---------------
# and functions
#---------------

function man ()
{
    xtitle The $(basename $1|tr -d .[:digit:]) manual
    /usr/bin/man -a "$*"
}

#-----------------------------------------
# Environment dependent functions
#-----------------------------------------

function dislink()
{
	if [ -f $1 -a ! -f .$1.tmp ]; then
		cp -L $1 .$1.tmp
		if [ ! -f .$1.tmp ]; then
			echo copy didn\'t work
			return
		fi
		unlink $1
		mv .$1.tmp $1
	else
		echo either file does not exist or tmp file exists
	fi
}
#-----------------------------------
# File & strings related functions:
#-----------------------------------

function ff() { find . -name '*'$1'*' ; }
function fe() { find . -name '*'$1'*' -exec $2 {} \; ; }
function fstr() # find a string in a set of files
{
    if [ "$#" -gt 2 ]; then
        echo "Usage: fstr \"pattern\" [files] "
    return;
    fi
    find . -type f -name "${2:-*}" -print | xargs grep -n "$1"
}
function cuttail() # cut last n lines in file
{
    nlines=$1
    sed -n -e :a -e "1,${nlines}!{P;N;D;};N;ba" $2
}

function lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}

#function swap()		# swap 2 filenames around
#{
#    local TMPFILE=tmp.$$
#    mv $1 $TMPFILE
#    mv $2 $1
#    mv $TMPFILE $2
#}


function ii()   # get current host related info
{
    echo -ne "\nYou are logged on ${RED}$HOSTNAME"
    echo -ne "\nAdditionnal information:$NC " ; uname -a
    echo -ne "\n${RED}IP Address :$NC" ; host $HOSTNAME
    echo -ne "\n${RED}Users logged on:$NC " ; users
    echo -ne "\n${RED}Current date :$NC " ; date
    echo -ne "\n${RED}Machine stats :$NC " ; uptime
#    echo -e "\n${RED}Memory stats :$NC " ; vmstat
#    echo -e "\n${RED}NIS Server :$NC " ; ypwhich
    echo
}
function corename()   # get name of app that created core
{
    local file name;
    file=${1:-"core"}
    set -- $(adb $file < /dev/null 2>&1 | sed 1q)
    name=${7#??}
    echo $file: ${name%??}
}
# Misc utilities:

function repeat()	# repeat n times command
{
    local i max
    max=$1; shift;
    for ((i=1; i <= max ; i++)); do
	eval "$@";
    done
}


function ask()
{
    echo -n "$@" '[y/n] ' ; read ans
    case "$ans" in
        y*|Y*) return 0 ;;
        *) return 1 ;;
    esac
}



#=========================================================================
#
# PROGRAMMABLE COMPLETION - ONLY IN BASH-2.04
#
#=========================================================================

if [ "${BASH_VERSION%.*}" \< "2.04" ]; then
    echo "No programmable completion available"
    return
fi

shopt -s extglob	# necessary

complete -A hostname   rsh rcp telnet rlogin r ftp ping disk
complete -A command    nohup exec eval trace truss strace sotruss gdb
complete -A command    command type which
complete -A export     printenv
complete -A variable   export local readonly unset
complete -A enabled    builtin
complete -A alias      alias unalias
complete -A function   function
complete -A user       su mail finger

complete -A helptopic  help	# currently same as builtins
complete -A shopt      shopt
complete -A stopped -P '%' bg
complete -A job -P '%'     fg jobs disown

complete -A directory  mkdir rmdir

complete -f -X '*.gz'   gzip
complete -f -X '!*.ps'  gs ghostview gv
complete -f -X '!*.pdf' acroread
complete -f -X '!*.+(gif|jpg|jpeg|GIF|JPG|bmp)' xv gimp


_make_targets ()
{
    local mdef makef gcmd cur prev i

    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    # if prev argument is -f, return possible filename completions.
    # we could be a little smarter here and return matches against
    # `makefile Makefile *.mk', whatever exists
    case "$prev" in
	-*f)	COMPREPLY=( $(compgen -f $cur ) ); return 0;;
    esac

    # if we want an option, return the possible posix options
    case "$cur" in
	-)	COMPREPLY=(-e -f -i -k -n -p -q -r -S -s -t); return 0;;
    esac

    # make reads `makefile' before `Makefile'
    if [ -f makefile ]; then
	mdef=makefile
    elif [ -f Makefile ]; then
	mdef=Makefile
    else
	mdef=*.mk		# local convention
    fi

    # before we scan for targets, see if a makefile name was specified
    # with -f
    for (( i=0; i < ${#COMP_WORDS[@]}; i++ )); do
	if [[ ${COMP_WORDS[i]} == -*f ]]; then
	    eval makef=${COMP_WORDS[i+1]}	# eval for tilde expansion
	    break
	fi
    done

	[ -z "$makef" ] && makef=$mdef

    # if we have a partial word to complete, restrict completions to
    # matches of that word
    if [ -n "$2" ]; then gcmd='grep "^$2"' ; else gcmd=cat ; fi

    # if we don't want to use *.mk, we can take out the cat and use
    # test -f $makef and input redirection
    COMPREPLY=( $(cat $makef 2>/dev/null | awk 'BEGIN {FS=":"} /^[^.# 	][^=]*:/ {print $1}' | tr -s ' ' '\012' | sort -u | eval $gcmd ) )
}

complete -F _make_targets -X '+($*|*.[cho])' make gmake pmake


_configure_func ()
{
    case "$2" in
	-*)	;;
	*)	return ;;
    esac

    case "$1" in
	\~*)	eval cmd=$1 ;;
	*)	cmd="$1" ;;
    esac

    COMPREPLY=( $("$cmd" --help | awk '{if ($1 ~ /--.*/) print $1}' | grep ^"$2" | sort -u) )
}

complete -F _configure_func configure

_killps ()
{
    local cur prev
    COMPREPLY=()
    cur=${COMP_WORDS[COMP_CWORD]}
    PSBIN=`which ps`
    # get a list of processes (the first sed evaluation
    # takes care of swapped out processes, the second
    # takes care of getting the basename of the process)
    COMPREPLY=( $( $PSBIN -u $USER -o comm  | \
	sed -e '1,1d' -e 's#[]\[]##g' -e 's#^.*/##'| \
	awk '{if ($0 ~ /^'$cur'/) print $0}' ))

    return 0
}
complete -F _killps killps

function r() {
	if [[ -n $TMUX ]]; then
		NEW_SSH_AUTH_SOCK=`tmux showenv | grep ^SSH_AUTH_SOCK | cut -d= -f2`
		if [[ -n $NEW_SSH_AUTH_SOCK ]] && [[ -S $NEW_SSH_AUTH_SOCK ]]; then
			export SSH_AUTH_SOCK=$NEW_SSH_AUTH_SOCK
		fi
		export DISPLAY=`tmux showenv | grep ^DISPLAY | cut -d= -f2`
	fi
}

[ -f ~/.bashrc.local ] && source ~/.bashrc.local

if [ $TERM != "dumb" ]; then
 set +u
 w
fi
# Local Variables:
# mode:shell-script
# sh-shell:bash
# End:
