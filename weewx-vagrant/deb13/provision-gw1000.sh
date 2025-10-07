#!/bin/bash 

# this is gw1000 driver from my stash of the upstream repo

URL="https://github.com/vinceskahan/upstream-repos/blob/main/weewx-gw1000.tgz"

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
  echo "skipping gw1000 - can't determine dpkg or pip"
fi

sudo systemctl restart weewx
