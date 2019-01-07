#!/bin/bash

CLAMAV_VERSION=0.101.1
DOWNLOAD_LINK="https://www.clamav.net/downloads/production/clamav-${CLAMAV_VERSION}.tar.gz"

# exit for any non-zero exit status
set -e
set -o pipefail

echo "Setting up clamav user and group"
# only needed for freshclam.  The clamd user only needs read access to the virus database
groupadd clamav
useradd -g clamav -s /bin/nologin -c "Clam Antivirus" clamav

echo "Installing dependencies"
yum install -y wget
yum groupinstall -y "Development Tools"
yum install -y openssl openssl-devel libcurl-devel zlib-devel libpng-devel libxml2-devel json-c-devel bzip2-devel pcre2-devel ncurses-devel
yum install -y valgrind check check-devel

echo "Downloading ClamAV"
cd /tmp
wget $DOWNLOAD_LINK
tar -xvf clamav-${CLAMAV_VERSION}.tar.gz
cd clamav-${CLAMAV_VERSION}

echo "Installing ClamAV"
./configure --enable-check
make -j2
make check
make install

echo "Configure freshclam"
if [[ -f /usr/local/etc/freshclam.conf ]]; then
  mv /usr/local/etc/freshclam.conf /usr/local/etc/freshclam.conf.old
fi
cat >> /usr/local/etc/freshclam.conf << EOL
DatabaseOwner clamav
EOL
# copy sample config file for reference,
# and remove "Example" stub
sed 's/Example/# Example/g' /usr/local/etc/freshclam.conf.sample >> /usr/local/etc/freshclam.conf
mkdir -p /usr/local/share/clamav
chown -R clamav:clamav /usr/local/share/clamav

echo "Configure clamd"
# Configure On-Access Scanning for /home
# Note on OnAccessMountPath vs. OnAccessIncludePath:
#   OnAccessMountPath:
#     - leverages a fanotify api different from OnAccessIncludePath
#     - is incompatible with the Dynamic Directory Determination (DDD) system.
#       Therefore, it will not work with OnAccessPrevention or
#       OnAccessExcludePath
#   OnAccessIncludePath:
#     - leverages the DDD scheme to track the layout of every specified directory.
#       This feature leverages inotify, which has a limited number of watchpoints.

# increase the number of watchpoints for use by inotify (via DDD)
echo 524288 | tee -a /proc/sys/fs/inotify/max_user_watches

if [[ -f /usr/local/etc/clamd.conf ]]; then
  mv /usr/local/etc/clamd.conf /usr/local/etc/clamd.conf.old
fi
cat >> /usr/local/etc/clamd.conf << EOL
LocalSocket /tmp/clamd.socket
LocalSocketMode 660
FixStaleSocket yes
ScanOnAccess yes
OnAccessIncludePath /home
OnAccessPrevention yes
OnAccessExtraScanning yes
ExcludePath ^/proc/
ExcludePath ^/sys/
EOL
# copy sample config file for reference,
# and remove "Example" stub
sed 's/Example/# Example/g' /usr/local/etc/clamd.conf.sample >> /usr/local/etc/clamd.conf

echo "Enabling freshclam"
systemctl enable clamav-freshclam

echo "Enabling clamd"
systemctl enable clamav-daemon

echo "Starting freshclam"
systemctl start clamav-freshclam

echo "Waiting for virus database to populate"
sleep 5

echo "Starting clamd"
systemctl start clamav-daemon

echo "Setting up daily full system scan"
if [[ -f /etc/cron.daily/clamdscan ]]; then
  rm /etc/cron.daily/clamdscan
fi
cat >> /etc/cron.daily/clamdscan << EOL
#!/bin/bash

/usr/local/bin/clamdscan /
EOL
chmod 700 /etc/cron.daily/clamdscan

echo "\n\nClamAV installation complete!\n"
