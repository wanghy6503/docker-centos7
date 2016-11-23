#!/bin/bash

set -o vi

alias ls='ls -h --color=auto'
alias la='ls -la'
alias l='ls -l'
alias ..='cd ..'
alias view='vi -R'

export EDITOR=vi
#export LANG='zh_TW.UTF-8'

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOR_NONE="\[\e[0m\]"

function set_bash_prompt () {
  if [[ $? == 0 ]] ; then
      PROMPT_SYMBOL="${GREEN}#${COLOR_NONE}"
  else
      PROMPT_SYMBOL="${RED}#${COLOR_NONE}"
  fi

  PS1="[\u@\h:$(pwd)]${PROMPT_SYMBOL} "

}

PROMPT_COMMAND=set_bash_prompt

