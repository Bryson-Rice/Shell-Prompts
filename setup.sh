#!/bin/bash

# Prompt the user for what changes they want to make
echo "What changes do you want to make?"
echo "1) Install for current user"
echo "2) Install for root"
echo "3) Apply changes to tmux"
echo "4) Install for specific user"
echo "5) Install all"
read -p "Select Option: " option

# Check if option is valid
if ! [[ "$option" =~ ^[1-5]$ ]]; then
  echo "Invalid option. Exiting script."
  exit 1
fi

# Backup the original files
if [ "$option" = "1" ] || [ "$option" = "5" ] || [ "$option" = "4" ]; then
  cp $HOME/.zshrc $HOME/.zshrc.bak
  cp $HOME/.bashrc $HOME/.bashrc.bak
fi

if [ "$option" = "2" ] || [ "$option" = "5" ] || [ "$option" = "4" ]; then
  if [ "$EUID" -eq 0 ]; then
    cp /root/.zshrc /root/.zshrc.bak
    cp /root/.bashrc /root/.bashrc.bak
  else
    cp $HOME/.zshrc $HOME/.zshrc.bak
    cp $HOME/.bashrc $HOME/.bashrc.bak
  fi
fi

if [ "$option" = "3" ] || [ "$option" = "5" ] || [ "$option" = "4" ]; then
  cp $HOME/.tmux.conf $HOME/.tmux.conf.bak
fi

# Change the files based on the user's selection
if [ "$option" = "1" ] || [ "$option" = "5" ] || [ "$option" = "4" ]; then
  cp 'bashrc - Home' $HOME/.bashrc
  cp 'zshrc - Home' $HOME/.zshrc
fi

if [ "$option" = "2" ] || [ "$option" = "5" ] || [ "$option" = "4" ]; then
  if [ "$EUID" -eq 0 ]; then
    read -p "Enter username: " username
    user_home="/home/$username"
    if [ ! -d "$user_home" ]; then
      echo "User does not exist or home directory not found. Exiting script."
      exit 1
    fi
    cp 'bashrc - Home' $user_home/.bashrc
    cp 'zshrc - Home' $user_home/.zshrc
  else
    echo "You need to be root to install for root."
  fi
fi

if [ "$option" = "3" ] || [ "$option" = "5" ] || [ "$option" = "4" ]; then
  cp 'tmux.conf' $HOME/.tmux.conf
fi
