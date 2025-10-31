#!/bin/bash 

# this is gw1000 driver from my stash of the upstream repo

URL="https://github.com/vinceskahan/upstream-repos/raw/refs/heads/main/weewx-gw1000.tgz"
FILENAME="weewx-gw1000.tgz"

# get upstream
wget ${URL} -O /var/tmp/${FILENAME}

echo ".....installing gw1000 skin...."
if [ -d /etc/weewx ]
then
  # this results in /var/www/html/weewx/belchertown for the root url
  sudo apt update && sudo apt install -y python3-six
  sudo weectl extension install -y /var/tmp/${FILENAME}
elif [ -d ${HOME}/weewx-venv ]
then
  cd ${HOME}/weewx-venv
  source bin/activate &&  pip3 install six && weectl extension install -y /var/tmp/${FILENAME}
else
  echo "skipping gw1000 - can't determine dpkg or pip"
fi

sudo systemctl restart weewx
