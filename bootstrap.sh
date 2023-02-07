#!/bin/bash

#
# Environments
#
SHELLRC="$HOME/.bashrc"
PS1="\[\033[m\]|\[\033[1;35m\]\t\[\033[m\]|\[\e[1;31m\]\u\[\e[1;36m\]\[\033[m\]@\[\e[1;36m\]\h\[\033[m\]:\[\e[0m\]\[\e[1;32m\][\W]> \[\e[0m\]"
USER=`whoami`

# Help function
helpFunction()
{
   echo ""
   echo "Usage: $0 [-h hostname] [-p 'PS1 variable']"
   echo -e "\t-h Hostname to set"
   echo -e "\t-p PS1 variable to set (default: time|user@host:[dir]>)"
#    echo -e "\t-u user to set"
   exit 1
}

# Check if we are running as non-root user
if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run as root"
  helpFunction
  exit 1
fi

# Check for correct number of arguments
while getopts "h:p:u:" opt
do
  case "$opt" in
    h ) HOSTNAME="$OPTARG" ;;
    p ) PS1="$OPTARG" ;;
    u ) USER=$OPTARG ;;
    ? ) helpFunction ;;
  esac
done

# Set hostname
hostnamectl set-hostname "$HOSTNAME"

# Set PS1 variable
echo "PS1='$PS1'" >> $SHELLRC

# Add aliases
echo "alias l='ls -lah'" >> $SHELLRC
alias l="ls -lah"

# set Pub Key Access to user
if [ ! -d $HOME/.ssh ]; then
  mkdir -p $HOME/.ssh; chmod 600 $HOME/.ssh;
fi
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGVvVrgF7abC0Bk8KIeNLfTT+wGvHPodJkt0YkS04eNF" >> $HOME/.ssh/authorized_keys
