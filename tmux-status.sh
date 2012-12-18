#!/bin/bash

var=$(tmux display -p "TMUXPWD_#I_#P")
dir=$(tmux show-environment  | grep $var | cut -f2- -d=)

dirty=""
branch=""
repo=""

#echo -n "#[fg=colour166]"
if [ -n "$dir" ] ; then
 if cd $dir; git update-index -q --refresh 2>/dev/null; git diff-index --quiet --cached HEAD --ignore-submodules -- 2>/dev/null && git diff-files --quiet --ignore-submodules 2>/dev/null
 then
   dirty="#[fg=colour33]"
 else
   dirty="#[fg=colour166]"
  fi
  branch=$(cd $dir; git repo 2>/dev/null)
fi
echo -n "${dirty}${repo}${branch}"
