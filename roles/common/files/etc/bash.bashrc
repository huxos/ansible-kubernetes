# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -f /etc/bash_completion ] &&  . /etc/bash_completion

TERM="linux"
EDITOR="vim"
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
if  [ `id -u` -ne 0 ]; then
PS1="\[\e[1;36m\]|\u\[\e[1;32m\]@\h \[\e[1;36m\]\w\n\[\e[1;32m\]\[\e[1;36m\]|>\\$\[\e[0m\] "
PS2="\[\e[1;36m\]|<\\$\[\e[0m\] "
else
PS1="\[\e[1;31m\]|\u\[\e[1;32m\]@\h \[\e[1;31m\]\w\n\[\e[1;32m\]\[\e[1;31m\]|>\\$\[\e[0m\] "
PS2="\[\e[1;31m\]|<\\$\[\e[0m\] "
fi

LC_ALL=en_US.UTF-8
LANG=en_US.UTF-8

export TERM EDITOR PATH CDPATH PYTHONPATH EDITOR PS1 PS2 HISTSIZE HISTFILE LC_ALL LANG PROMPT_COMMAND
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

alias ..='cd ..'
alias du='du -sh'
alias df='df -h'
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
alias ls='ls --color=auto -F'
alias l='ls'
alias l.='ls -d .*'
alias la='ls -a'
alias ll='ls -l'
alias ..='cd ..'
alias grep='grep --colour'
alias arp='arp -n'
alias now="date +%H%M%S"
alias day="date +%Y%m%d%H%M%S"
alias dig="dig +answer +multiline"
alias px='ps eo pid,user,psr,pcpu,pmem,stat,comm axf'
alias curlpaste='curl -F "sprunge=<-" http://sprunge.us'
