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
source /usr/local/bin/git-prompt.sh

# Custom function to set the prompt
function set_bash_prompt () {
    # 1. Get the virtual environment name if active
    if [[ -n "\${VIRTUAL_ENV-}" && -z "\${VIRTUAL_ENV_DISABLE_PROMPT+x}" ]]; then
        # Extracts the directory name of the venv (e.g., "venv" or "myproject")
        VENV_NAME="(\$(basename "\${VIRTUAL_ENV}")) "
    else
        VENV_NAME=""
    fi

    # 2. Use __git_ps1 to get the git branch info
    # The arguments control the format: "prefix%s" "suffix"
    # The %s is a placeholder for the git status/branch string.
    GIT_PROMPT=\$(__git_ps1 "[%s]")

    # 3. Set the final PS1 (Prompt String 1)
    # Example format: (venv) user@host:~/current/path on git-branch$
    PS1="\${VENV_NAME}\[\u@\h\]:\w\] \${GIT_PROMPT}\\\$ "
}

# Tell bash to execute the function before displaying the prompt
PROMPT_COMMAND=set_bash_prompt

# Optional: Configure git-prompt behavior
GIT_PS1_SHOWDIRTYSTATE=1         # Show if there are unstaged changes (+)
GIT_PS1_SHOWUNTRACKEDFILES=1     # Show if there are untracked files (?)
GIT_PS1_SHOWUPSTREAM="auto"      # Show upstream branch status (e.g., ahead, behind)
GIT_PS1_SHOWCOLORHINTS=1         # Enable color hints
GIT_PS1_SHOWSTASHSTATE=1

#keepme
##GIT_PS1_SHOWDIRTYSTATE=1
#GIT_PS1_SHOWUPSTREAM=1
#GIT_PS1_SHOWUNTRACKEDFILES=1
#GIT_PS1_SHOWCOLORHINTS=1
#GIT_PS1_SHOWSTASHSTATE=1
#source /usr/local/bin/git-prompt.sh
#PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\$ "'
#--- END GIT-PROMPT ---

EOF

fi
