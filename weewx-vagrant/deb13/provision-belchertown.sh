#!/bin/bash 

# this is belchertown from my stashed zip of upstream
URL="https://github.com/vinceskahan/upstream-repos/raw/refs/heads/main/weewx-belchertown.zip"
FILENAME="weewx-belchertown.zip"

# get upstream
wget ${URL} -O /var/tmp/${FILENAME}

echo ".....installing belchertown skin...."
if [ -d /etc/weewx ]
then
  # this results in /var/www/html/weewx/belchertown for the root url
  sudo weectl extension install -y /var/tmp/${FILENAME}
elif [ -d ${HOME}/weewx-venv ]
then
  cd ${HOME}/weewx-venv
  source bin/activate &&  weectl extension install -y /var/tmp/${FILENAME}
else
  echo "skipping belchertown - can't determine dpkg or pip"
fi

sudo systemctl restart weewx
