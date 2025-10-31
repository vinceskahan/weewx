#!/bin/bash

echo "-----------------------------------------"
echo " downloading and configuring git-prompt"
echo "-----------------------------------------"

sudo apt update
sudo apt install -y git

URL="https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
wget ${URL}

if [ ! -f  /usr/local/bin/git-prompt.sh ]
then
   sudo cp git-prompt.sh /usr/local/bin/git-prompt.sh
   cat >> /home/vagrant/.bashrc <<-EOF

#--- START GIT-PROMPT ---
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWSTASHSTATE=1
source /usr/local/bin/git-prompt.sh
PROMPT_COMMAND='__git_ps1 "\u@\h:\W" "\\\$ "'
#--- END GIT-PROMPT ---

EOF

fi
