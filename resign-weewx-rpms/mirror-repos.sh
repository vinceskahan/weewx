#cat > /etc/yum.repos.d/weewx-suse15.repo <<EOF
#[suse15]
#name=weewx-suse15
#baseurl=http://weewx.com/suse/weewx/suse15
#enabled=1
#gpgcheck=0
#EOF
#
#
#cat > /etc/yum.repos.d/weewx-el7.repo <<EOF
#[el7]
#name=weewx7
#baseurl=http://weewx.com/yum/weewx/el7
#enabled=1
#gpgcheck=0
#EOF

cat > /etc/yum.repos.d/weewx-el8.repo <<EOF
[el8]
name=weewx8
baseurl=http://weewx.com/yum/weewx/el8
enabled=1
gpgcheck=0
EOF

cat > /etc/yum.repos.d/weewx-el8test.repo <<EOF
[el8test]
name=weewx8test
baseurl=http://weewx.com/yum-test/weewx/el8
enabled=1
gpgcheck=0
EOF

mkdir -p /root/repos
cd /root/repos

#echo ".............. suse repo ............"
#reposync --disablerepo=\* --enablerepo=suse15
##ls /root/repos/el7/RPMS -al

#echo "............... el7 repo ............"
#reposync --disablerepo=\* --enablerepo=el7
##ls /root/repos/el7/RPMS -al

echo "............... el8 repo ............"
reposync --disablerepo=\* --enablerepo=el8

echo "............... el8test repo ............"
reposync --disablerepo=\* --enablerepo=el8test

echo ".............. done ..............."

