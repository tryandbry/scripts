#!/bin/bash

firewall-cmd --set-default-zone=public
firewall-cmd --zone=public --remove-service dhcpv6-client  --permanent
firewall-cmd --zone=public --add-service http  --permanent
firewall-cmd --zone=public --add-service https --permanent

for i in `ip link show | awk '/enp/ {print $2}' | sed -e 's/://'`
do
firewall-cmd --zone=public --change-interface=$i --permanent
done

firewall-cmd --reload
firewall-cmd --list-all
