#!/bin/bash

# Check if we are running as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# Default PS1 variable value
PS1="\[\033[m\]|\[\033[1;35m\]\t\[\033[m\]|\[\e[1;31m\]\u\[\e[1;36m\]\[\033[m\]@\[\e[1;36m\]\h\[\033[m\]:\[\e[0m\]\[\e[1;32m\][\W]> \[\e[0m\]"

# Help function
helpFunction()
{
   echo ""
   echo "Usage: $0 -h hostname -p 'PS1 variable' "
   echo -e "\t-h Hostname to set"
   echo -e "\t-p PS1 variable to set (default: $PS1)"
   exit 1
}

# Check for correct number of arguments
while getopts "h:p:" opt
do
   case "$opt" in
      h ) HOSTNAME="$OPTARG" ;;
      p ) PS1="$OPTARG" ;;
      ? ) helpFunction ;;
   esac
done

# Check if the HOSTNAME environment variable is set
if [[ -z "$HOSTNAME" ]]; then
  echo "HOSTNAME environment variable must be set"
  exit 1
fi

# Set hostname
hostnamectl set-hostname "$HOSTNAME"

# Set PS1 variable
echo "PS1='$PS1'" >> /etc/profile

# Add aliases
echo "alias l='ls -lah'" >> /etc/profile

# Apply changes
source /etc/profile
