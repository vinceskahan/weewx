
```
Dockerfile and docker compose file to build/start
a pair of weewx and nginx containers based on a 
weewx pip installation

weewx-pip:5.1.0 built image size is 174 MB
nginx:1.29.1 upstream image size is 192 MB

Usual commands apply
=====================
docker compose up -d
docker compose down
docker ps -a
docker images -a

ONE TIME SETUP REQUIRED
=======================
  - the container runs as weewx:weewx uid/gid=1234
  - so create a user/group to match on the host
    and mkdir /mnt/weewx and set it the same
    before starting the containers so permissions
    permit writing into there
```
