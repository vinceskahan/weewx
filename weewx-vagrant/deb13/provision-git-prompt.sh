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

function __git_ps1_venv() {
    # Check if VIRTUAL_ENV is set and add it to the prompt display
    if [[ -n "$VIRTUAL_ENV" ]]; then
        # Extract only the basename of the venv directory (e.g., 'myproject_env')
        VENV_NAME="($(basename "$VIRTUAL_ENV")) "
    else
        VENV_NAME=""
    fi
    # Combine venv info, user/host/path (original PS1), and git info
    # The arguments to __git_ps1 are a prefix and a suffix
    PS1="${VENV_NAME}\u@\h \w\$(__git_ps1 \" (\[%s])\")\$ "
}


#--- START GIT-PROMPT ---
#  change __git_ps1_venv to __git_ps1 for a non-venv-aware prompt
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWSTASHSTATE=1
source /usr/local/bin/git-prompt.sh
####PROMPT_COMMAND='__git_ps1_venv "\u@\h:\W" "\\\$ "'
PROMPT_COMMAND='__git_ps1_venv'
#--- END GIT-PROMPT ---

EOF

fi
