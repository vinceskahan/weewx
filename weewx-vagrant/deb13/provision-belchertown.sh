#!/bin/bash 

# this is belchertown from my stashed tgz of upstream
URL="https://github.com/vinceskahan/upstream-repos/blob/main/weewx-belchertown.tgz"

echo ".....installing belchertown skin...."
if [ -d /etc/weewx ]
then
  # this results in /var/www/html/weewx/belchertown for the root url
  sudo weectl extension install -y ${URL}
elif [ -d ${HOME}/weewx-venv ]
then
  cd ${HOME}/weewx-venv
  source bin/activate &&  weectl extension install -y ${URL}
else
  echo "skipping belchertown - can't determine dpkg or pip"
fi

sudo systemctl restart weewx
