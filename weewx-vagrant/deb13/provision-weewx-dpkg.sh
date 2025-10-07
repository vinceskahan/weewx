#
# this script installs weewx v5 via dpkg
# as well as nginx, hooking the two together
# so that the weewx web will be at http://x.x.x.x/weewx

#------------- START EDITING HERE -------------------------

RUN_AS_VAGRANT_PROVISIONER=1
ADD_USER_TO_TYPICAL_GROUPS=1

#-------------- STOP EDITING HERE -------------------------

# the Vagrantfile sets privileged: false
# so we need to use sudo occasionally here
# but fortunately this os has vagrant sudo-enabled

if [ "x${RUN_AS_VAGRANT_PROVISIONER}" = "x1" ]
then
  WEEWXUSER="weewx"    # weewx for dpkg, vagrant for pip
else
  WEEWXUSER=${USER}
fi
echo "...setting up to run as user ${WEEWXUSER}..."

# some things we'll need
sudo apt install -y vim rsyslog

#---- from the debian quickstart
sudo apt install -y wget gnupg
sudo wget -qO - https://weewx.com/keys.html | \
    sudo gpg --dearmor --output /etc/apt/trusted.gpg.d/weewx.gpg

echo "deb [arch=all] https://weewx.com/apt/python3 buster main" | \
    sudo tee /etc/apt/sources.list.d/weewx.list

sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install weewx -y

# install the rsyslogd hook and reset the logging daemon
echo "...setting up rsyslogd..."
sudo cp /etc/weewx/rsyslog.d/weewx.conf /etc/rsyslog.d/weewx.conf \
    && sudo systemctl restart rsyslog

# add weewx to all the groups typical 'pi' is in
# which should permit binding to non-privileged ports for various drivers
if [ "x${ADD_USER_TO_TYPICAL_GROUPS}" = "x1" ]
then
  echo "...adding ${WEEWXUSER} to typical groups..."
  for g in adm dialout cdrom sudo audio video plugdev games users input render netdev gpio i2c spi
  do
    if ! getent group $g >/dev/null
    then
     echo "adding group $g..."
     sudo /usr/sbin/addgroup $g
    fi
    sudo usermod -aG $g ${WEEWXUSER}
  done
  usermod -aG adm ${WEEWXUSER}     # to view logs
fi

# install and configure nginx and connect it to weewx
echo "...integrating weewx and nginx setups..."
sudo apt-get install -y nginx
sudo chown -R ${WEEWXUSER}:${WEEWXUSER} /var/www/html/weewx
sudo chmod 755 /var/www/html/weewx
sudo ln -s /var/www/html/weewx /usr/share/weewx/public_html

# set up logrotate to match
echo "...setting up logrotate..."
sudo cp /etc/weewx/logrotate.d/weewx /etc/logrotate.d/weewx

# no need to set up systemd, dpkg does this for us

# do a little tweaking of weewx.conf
echo "...editing weewx.conf..."
sudo sed -i -e s:debug\ =\ 0:debug\ =\ 1: /etc/weewx/weewx.conf 

echo "...starting weewx..."
sudo systemctl restart weewx

