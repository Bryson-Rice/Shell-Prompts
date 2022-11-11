#! /bin/bash

cp ~/.zshrc zshrc.bak 
cp ~/.bashrc bashrc.bak
cp /root/.zshrc root-zshrc.bak 
cp /root/.bashrc root-bashrc.bak 

cp 'bashrc - Home' ~/.bashrc
cp 'bashrc - Root' /root/.bashrc
cp 'zshrc - Root' /root/.zshrc
cp 'zshrc - Home' ~/.zshrc