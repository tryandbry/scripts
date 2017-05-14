#!/bin/bash

# refresh yum repo list
yum clean all
yum repolist -v

# install wget
yum install -y wget

# install EPEL repo
# http://fedoraproject.org/wiki/EPEL/FAQ#How_can_I_install_the_packages_from_the_EPEL_software_repository.3F
# Note: check  http://dl.fedoraproject.org/pub/epel/7/x86_64/e/
#       for the latest RPM package

wget -P /tmp http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
rpm -ivh /tmp/epel-release-7-9.noarch.rpm
rm -f /tmp/epel-release-7-9.noarch.rpm

# install nodejs and npm
# https://nodejs.org/en/download/package-manager/#enterprise-linux-and-fedora
yum install -y nodejs npm

# install, enable, and start httpd
#yum install -y httpd.x86_64
#systemctl enable httpd
#systemctl start httpd

# install testem
npm install -g testem

# install vim
yum install -y vim









### Optional
# installs the repo for the software collections for CERN CentOS 7
# needed for gcc
#yum install centos-release-scl -y

