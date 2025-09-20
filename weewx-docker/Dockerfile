#-------------------------------------------------------------------------
#
# deb13 Dockerfile
#
# 'base'        = minimal os starting point
#
# 'v5pip'       = with v5 pip installed over base
#
# to run manually:
#    docker run --rm -it imagename:here [cmd]
#
# to build:
#    docker build [--no-cache] . -t weewx-pip:5.1.0
#
#-------------------------------------------------------------------------

#-------------------------------------------------------------
# configure a base image we'll derive other variants from
#-------------------------------------------------------------

FROM debian:trixie-20250908-slim AS base
LABEL maintainer="Vince Skahan <vinceskahan@gmail.com>"

# we'll need this later for Docker to suppress needing syslog
COPY logging.additions /tmp/logging.additions

# we do a little cleanup for size here
# need gcc for compiling CT3
# also set up weewx user/group/homedir
RUN apt-get update                                  \
    && apt-get install -y python3-pip python3-venv sqlite3 wget gcc \
    && apt-get clean autoclean                         \
    && apt-get autoremove --yes                        \
    && rm -rf /var/lib/{apt,dpkg,cache,log}            \
    && rm -rf /usr/share/doc                           \
    && rm -rf /usr/share/man                           \
    && groupadd -r weewx -g 1234        \
    && useradd -r -g weewx weewx -u 1234       \
    && mkdir -p /home/weewx/adds \
    && cd /home/weewx/adds\
    && chown -R weewx:weewx /home/weewx \
    && chmod -R 755 /home/weewx 

#-------------------------------------------------------------
# install v5pip over the base image above
#-------------------------------------------------------------

FROM base AS v5pip

# install and configure weewx using an unprivileged user
#    setting debug=1 can't be done via weectl so use sed
#    StdPrint is removed to stop LOOP from being logged to stdout
#    append logging stanza so we don't look for syslogd at runtime
#

USER weewx
RUN python3 -m venv /home/weewx/weewx-venv \
    && . /home/weewx/weewx-venv/bin/activate \
    && pip3 install weewx     \
    && weectl station create --no-prompt \
    && sed -i -e s:debug\ =\ 0:debug\ =\ 1: /home/weewx/weewx-data/weewx.conf \
    && sed -i -e s:weewx.engine.StdPrint,:: /home/weewx/weewx-data/weewx.conf \
    && cat /tmp/logging.additions >> /home/weewx/weewx-data/weewx.conf 

CMD ["/home/weewx/weewx-venv/bin/weewxd"]

#-------------------------------------------------------------
# build a mini image from the artifacts above over python slim
#  - have to fix the python3 path due to differences in where
#    the python executable is in the python image vs. debian
#  - create the user/group for when we run bash in this image
#-------------------------------------------------------------

FROM python:3.13-slim AS minimal
COPY --from=v5pip /home/weewx /home/weewx
RUN cd /home/weewx/weewx-venv/bin \
 && rm python3 \
 && ln -s /usr/local/bin/python3 python3 \
 && groupadd -r weewx -g 1234        \
 && useradd -r -g weewx weewx -u 1234 
USER weewx
CMD ["/home/weewx/weewx-venv/bin/weewxd", "/home/weewx/weewx-data/weewx.conf"]

