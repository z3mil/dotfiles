#!/bin/bash

#
# Environments
#
SHELLRC="$HOME/.bashrc"
PS1="\[\033[m\]|\[\033[1;35m\]\t\[\033[m\]|\[\e[1;31m\]\u\[\e[1;36m\]\[\033[m\]@\[\e[1;36m\]\h\[\033[m\]:\[\e[0m\]\[\e[1;32m\][\W]> \[\e[0m\]"

# Help function
helpFunction()
{
   echo ""
   echo "Usage: $0 -h hostname -p 'PS1 variable' "
   echo -e "\t-h Hostname to set"
   echo -e "\t-p PS1 variable to set (default: time|user@host:[dir]>)"
   exit 1
}

# Check if we are running as non-root user
if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run as root"
  exit 1
fi

# Check for correct number of arguments
if [ $# -eq 0 ]; then
  helpFunction
else
  while getopts "h:p:" opt
  do
    case "$opt" in
      h ) HOSTNAME="$OPTARG" ;;
      p ) PS1="$OPTARG" ;;
      ? ) helpFunction ;;
    esac
  done
fi

# Set hostname
hostnamectl set-hostname "$HOSTNAME"

# Set PS1 variable
echo "PS1='$PS1'" >> $SHELLRC
export "PS1='$PS1'"

# Add aliases
echo "alias l='ls -lah'" >> $SHELLRC
export "alias l='ls -lah'"
