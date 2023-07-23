#!/bin/bash

#
# Environments
#
SHELLRC="$HOME/.bashrc"
PS1="\[\033[m\]|\[\033[1;35m\]\t\[\033[m\]|\[\e[1;31m\]\u\[\e[1;36m\]\[\033[m\]@\[\e[1;36m\]\h\[\033[m\]:\[\e[0m\]\[\e[1;32m\][\W]> \[\e[0m\]"
USER=`whoami`
# script colors
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
NC=$(tput sgr0)

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

# Set PS1 variable
echo "PS1='$PS1'" >> $SHELLRC

# Add aliases
echo "alias l='ls -lah'" >> $SHELLRC
alias l="ls -lah"

# Check if we are running as non-root user
if [[ $EUID -eq 0 ]]; then
  IAMROOT=true
else
  IAMROOT=false
fi

######################
### Main execution ###
######################
if [ ! -d $HOME/.ssh ]; then
  echo "INFO: checking/creating dot ssh folder.."
  mkdir -p $HOME/.ssh; chmod 700 $HOME/.ssh;
fi
if [ $IAMROOT = false ]; then
     echo "INFO: This script is run as $USER. make sure to run as root the first time."
     # set Pub Key Access to user if unprivileged
     echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGVvVrgF7abC0Bk8KIeNLfTT+wGvHPodJkt0YkS04eNF" >> $HOME/.ssh/authorized_keys
     chmod 600 $HOME/.ssh/authorized_keys
else
     echo "INFO: This script is run as root."
     # Required packages when run as root
     packagesNeeded='curl sudo vim'
     if [ -x "$(command -v apt-get)" ]; then apt-get install -y $packagesNeeded
     elif [ -x "$(command -v dnf)" ]; then dnf install -y $packagesNeeded
     else echo "${RED}FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded${NC}">&2; fi
     echo "INFO: SSH access as root is not allowed, skipping public key step.."
     # Set hostname
     echo "INFO: Setting HOSTNAME.."
     hostnamectl set-hostname "$HOSTNAME"
fi

echo "${GREEN}SUCCESS: Script executed successfully.${NC}"
