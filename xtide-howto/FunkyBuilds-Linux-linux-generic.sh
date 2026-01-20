#!/bin/bash
#
#----------------------------------------------------------------------------
#
# vds notes - this is unaltered other than the instructions for how to install to
#             normal places which is at the very bottom of this script
#             and the editing of the SRCDIR variable near the top of this script
#
#
# original script is from https://flaterco.com/files/xtide/FunkyBuilds-20251228.tar.xz
#
# installed prerequisites for Debian-13 via:
#    sudo apt-get -y install build-essential xorg-dev libxaw7-dev xaw3dg-dev libpng-dev libsystemd-dev
#
# to download sources - edit ${SRCDIR} below then:
#    mkdir ${SRCDIR}
#    cd ${SRCDIR}
#    wget https://flaterco.com/files/xtide/xtide-2.15.6.tar.xz
#    wget https://flaterco.com/files/xtide/harmonics-dwf-20251228-free.tar.xz
#    wget https://flaterco.com/files/xtide/libtcd-2.2.7-r3.tar.xz
#
#---------------------------------------------------------------------------
#
# 2025-12-28
# Build everything XTide-related as a normal user.
# See below for variables to be edited (SRCDIR, etc.).

# The script will look for the following 11 archives in SRCDIR and build the
# packages if they are present:

# libdstr-*.tar.*          String library used by XTide and Harmbase2.
# libtcd-*.tar.*           TCD library used by XTide, Congen, Harmbase2,
#                          TideEditor, and tcd-utils.
# libxaw3dxft-*.tar.*      FreeType font support library.  Optional for XTide.
# congen-*.tar.*           Math library used by Harmbase2 and Harmgen.
# tcd-utils-*.tar.*        TCD command line utilities.
# harmgen-*.tar.*          Program to derive harmonic constants.
# xtide-*.tar.*            Tide predictor.
# harmonics-dwf-*-free.tar.*    Harmonics file used by XTide.
# wvs.tar.*                World Vector Shoreline data.  Optional for XTide
#                          and TideEditor.
# harmbase2-*.tar.*        Harmonic constant management system.
# tideeditor-*.tar.*       Graphical TCD file editor.

# harmbase2 is skipped if PostgreSQL is not on the system.
# tideeditor is skipped if Qt5 is not on the system.
# Other missing dependencies will result in failures.

# libdstr comes from https://flaterco.com/util/index.html
# libxaw3dxft comes from https://github.com/DaveFlater/libXaw3dXft/releases
# Everything else comes from https://flaterco.com/xtide/files.html

set -e
if [ $UID = 0 ]; then
  echo 'There is no need to run this script as root.'
  exit
fi

# ------------------ Begin variables to edit ------------------

# Source tarballs must be in this directory.
# Include only what is to be installed.
# Multiple versions of a single package will cause an abort.
SRCDIR="/home/vagrant/xtide-src"         # EDIT ME !!!!!!

# Empty scratch directory to build in.
# rm -rf will happen here.
BUILDDIR="/tmp"
#BUILDDIR="${HOME}/tmp"

# Installation prefix.
#DESTDIR="/tmp/xtide"
DESTDIR="${HOME}/xtide"

# Specify number of CPU cores for GNU Make.
JFLAG="-j 4"

# Standard preprocessor, compiler, and linker flags.
XCPP="-I${DESTDIR}/include"
XCC="-O2"
XLD="-L${DESTDIR}/lib -Wl,-rpath,${DESTDIR}/lib"

# ------------------ End variables to edit ------------------

echo "SRCDIR = ${SRCDIR}"
echo "BUILDDIR = ${BUILDDIR}"
echo "DESTDIR = ${DESTDIR}"
echo "JFLAG = ${JFLAG}"
echo "XCPP = ${XCPP}"
echo "XCC = ${XCC}"
echo "XLD = ${XLD}"

if [ ! -d "${SRCDIR}" ]; then
  echo -e "\nSource directory ${SRCDIR} does not exist.  Aborting."
  exit
fi
if [ ! -d "${BUILDDIR}" ]; then
  echo -e "\nBuild directory ${BUILDDIR} does not exist.  Aborting."
  exit
fi


# Find exactly one source file and assign its path to SRCFILE.
# 1: glob expression
# Returns true if one source file found,
# returns false if no source file found,
# does not return if there are multiple matches.
function find_source {
  declare -g SRCFILE=`compgen -G "$1"`
  [ -z "${SRCFILE}" ] && return 1
  [ `echo -n "${SRCFILE}" | wc -l` = 0 ] && return 0
  echo "ERROR: There are multiple source files matching $1"
  echo 'Aborting'
  exit
}

# Standard build of autotools packages.
# 1: package name
# 2: path relative to DESTDIR to test for already present
# 3: [optional] extra configure flags
# 4: [optional] extra preprocessor and compiler flags
# 5: [optional] required pkg-config dependency
#               Its -I and -L flags are added
function standard_build {
  echo -e "\nBEGIN standard_build $1"
  if [ -e "${DESTDIR}/${2}" ]; then
    echo "Already present in ${DESTDIR}.  Skipping $1."
  else
    if find_source "${SRCDIR}/${1}*.tar.*"; then
      echo "Found source file ${SRCFILE}."
      local TempXCPP="${XCPP}" TempXCC="${XCC}" TempXLD="${XLD}" skip=0
      if [ -n "$4" ]; then
	TempXCPP+=" $4"
	TempXCC+=" $4"
      fi
      if [ -n "$5" ]; then
	if pkg-config --exists "$5"; then
	  TempXCPP+=" `pkg-config --cflags-only-I \"$5\"`"
	  TempXLD+=" `pkg-config --libs-only-L \"$5\"`"
	else
	  echo "Dependency $5 is unknown to pkg-config.  Skipping $1."
	  skip=1
	fi
      fi
      if [ $skip = 0 ]; then
	cd "${BUILDDIR}"
	tar xf "${SRCFILE}"
	cd "$1"*
	./configure --disable-dependency-tracking --prefix="${DESTDIR}" $3 \
	  CPPFLAGS="${TempXCPP}" CFLAGS="${TempXCC}" CXXFLAGS="${TempXCC}" \
	  LDFLAGS="${TempXLD}"
	make ${JFLAG}
	make install
	cd "${BUILDDIR}"
	rm -rf "$1"*
      fi
    else
      echo "Archive not found in ${SRCDIR}.  Skipping $1."
    fi
  fi
  echo "END standard_build $1"
}


standard_build libdstr lib/libdstr.a
standard_build libtcd lib/libtcd.a
standard_build libxaw3dxft lib/libXaw3dxft.a '--enable-internationalization --enable-multiplane-bitmaps --enable-gray-stipples --enable-arrow-scrollbars'
standard_build congen lib/libcongen.a
standard_build tcd-utils bin/build_tide_db

# harmgen
# Octave is a runtime dependency.
standard_build harmgen bin/harmgen

# XTide
# System must provide libpng, libz, and X libs.
# libgps is optional.
# xttpd is built for use on an unprivileged port without involving systemd.
standard_build xtide bin/xtide \
  "--with-xttpd-user=`id -un` --with-xttpd-group=`id -gn` --enable-gnu-attributes"

# Harmonics file
echo -e "\nBEGIN harmonics file"
HFILE_PATH="${DESTDIR}/share/xtide"
if [ -e "${HFILE_PATH}" ]; then
  echo "Already present in ${DESTDIR}.  Skipping harmonics file."
else
  if find_source "${SRCDIR}/harmonics-dwf-*-free.tar.*"; then
    echo "Found ${SRCFILE}."
    mkdir -v -p "${HFILE_PATH}"
    tar -x -v -f "${SRCFILE}" -C "${HFILE_PATH}" \
	--strip-components=1 --wildcards '*/*.tcd'
  else
    echo "Archive not found in ${SRCDIR}.  Skipping harmonics file."
    HFILE_PATH=''
  fi
fi
echo 'END harmonics file'

# World Vector Shoreline data files
echo -e '\nBEGIN World Vector Shoreline (WVS)'
WVS_DIR="${DESTDIR}/share/wvs"
if [ -e "${WVS_DIR}" ]; then
  echo "Already present in ${DESTDIR}.  Skipping WVS."
else
  if find_source "${SRCDIR}/wvs.tar.*"; then
    echo "Found ${SRCFILE}."
    mkdir -v -p "${WVS_DIR}"
    tar -x -v -f "${SRCFILE}" -C "${WVS_DIR}"
  else
    echo "Archive not found in ${SRCDIR}.  Skipping WVS."
    WVS_DIR=''
  fi
fi
echo 'END World Vector Shoreline'

# Harmbase2
# System must provide PostgreSQL.
standard_build harmbase2 bin/hbexport

# tideEditor
# System must provide Qt5 and all of its dependencies.  Calculate Linux
# somehow had Qt5Core but not Qt5PrintSupport.
# Qt still isn't completely handled by standard_build.
# (In Qt6, host_bins is replaced by libexecdir.)
if pkg-config --exists Qt5Core Qt5Gui Qt5Widgets Qt5PrintSupport; then
  MOCDIR="`pkg-config --variable=host_bins Qt5Core`"
  standard_build tideeditor bin/tideEditor \
    "MOC=${MOCDIR}/moc RCC=${MOCDIR}/rcc" -fPIC Qt5Core
else
  echo -e '\nOne or more of the Qt5 dependencies Qt5Core, Qt5Gui, Qt5Widgets, and Qt5PrintSupport is unknown to pkg-config.  Skipping tideEditor.'
fi


echo -e "\nBuild is finished.\nBinaries are in ${DESTDIR}/bin."
if [ -n "${HFILE_PATH}" ]; then
  echo 'This environment variable is required for xtide to run:'
  echo "  export HFILE_PATH=\"${HFILE_PATH}\""
else
  echo 'XTide still needs a harmonics file.'
fi
if [ -n "${WVS_DIR}" ]; then
  echo 'This environment variable is required to enable World Vector Shoreline in xtide:'
  echo "  export WVS_DIR=\"${WVS_DIR}\""
fi


#---- vds additions ------
echo ""
echo "#---------------------------------------------"
echo "# to install results into normal locations"
echo "#---------------------------------------------"
echo "sudo cp -r ${DESTDIR}/bin/tide /usr/bin/tide"
echo "sudo cp -r ${HFILE_PATH} /usr/share"
echo "echo /usr/share/xtide | sudo tee /etc/xtide.conf"
echo "# and optionally delete the built ${DESTDIR} now"
echo "#    rm -r ${DESTDIR}"
echo "# and optionally remove any build prerequisite packages now"
echo "#    (for debian)"
echo "#    sudo apt remove xorg-dev libxaw7-dev xaw3dg-dev libpng-dev libsystemd-dev"
echo "#---------------------------------------------"

