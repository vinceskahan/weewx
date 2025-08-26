
FROM rockylinux:9.2 as reposync
MAINTAINER Vince Skahan "vinceskahan@gmail.com"

RUN yum install -y yum-utils rpm-sign findutils vim pinentry wget
COPY mirror-repos.sh /tmp
COPY setup.sh /tmp
COPY resign-it.sh /tmp
CMD ["bash", "/tmp/mirror-repos.sh"]

