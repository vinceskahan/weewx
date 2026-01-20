2025-06-28

linux-generic.sh builds everything XTide-related as a normal user.  See the
header comments for configuration and usage.

------------
Installing standard XTide prerequisites in major Linux distributions:
(copied from https://flaterco.com/xtide/installation.html)

Arch family:  sudo pacman -Syu --needed --noconfirm xorg xorg-fonts-misc xorg-fonts-alias-misc libxaw xaw3d libpng

Debian family:  sudo apt-get -y install build-essential xorg-dev libxaw7-dev xaw3dg-dev libpng-dev libsystemd-dev

Fedora family:  sudo dnf -y group install c-development base-x x-software-development; sudo dnf -y install zlib-ng-devel systemd-devel xorg-x11-fonts-misc xorg-x11-fonts-75dpi xorg-x11-fonts-100dpi xorg-x11-font-utils

Gentoo family:  sudo emerge xorg-fonts libXaw3d

Slackware family:  The default full install gives you everything you need.
------------

For TideEditor, you'll also need Qt5.
Arch family:  sudo pacman -Syu --needed --noconfirm qt5
Debian family:  sudo apt-get -y install qtbase5-dev
Fedora family:  sudo dnf -y install qt5-qtbase-devel
Gentoo family:  sudo emerge qt5compat qtprintsupport
Slackware family:  default full install

For Harmbase2, you'll also need PostgreSQL.
Arch family:  sudo pacman -Syu --needed --noconfirm postgresql
Debian family:  sudo apt-get -y install postgresql libpq-dev libecpg-dev
Fedora family:  sudo dnf -y install postgresql libecpg-devel
Gentoo family:  sudo emerge postgresql
Slackware family:  build and install PostgreSQL from source
