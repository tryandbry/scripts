#!/bin/bash

IPDIR=/etc/sysconfig/network-scripts

for i in `ip link show | awk '/enp/ {print $2}' | sed -e 's/://'`
do
if [ -e $IPDIR/ifcfg-$i ]
then
mv $IPDIR/ifcfg-$i $IPDIR/ifcfg-$i.old.`date +%Y-%m-%d`
fi
touch $IPDIR/ifcfg-$i
chown root:root $IPDIR/ifcfg-$i
chmod 644 $IPDIR/ifcfg-$i
echo "NAME="$i >> $IPDIR/ifcfg-$i
echo "HWADDR="`ip link show | grep -A1 $i | awk '/link/ {print $2}'` >> $IPDIR/ifcfg-$i
echo "TYPE=Ethernet" >> $IPDIR/ifcfg-$i
echo "BOOTPROTO=dhcp" >> $IPDIR/ifcfg-$i
echo "#BOOTPROTO=static" >> $IPDIR/ifcfg-$i
echo "#IPADDR=IPADDRESSHERE" >> $IPDIR/ifcfg-$i
echo "DEFROUTE=yes" >> $IPDIR/ifcfg-$i
echo "PEERDNS=yes" >> $IPDIR/ifcfg-$i
echo "PEERROUTES=yes" >> $IPDIR/ifcfg-$i
echo "IPV4_FAILURE_FATAL=no" >> $IPDIR/ifcfg-$i
echo "ONBOOT=yes" >> $IPDIR/ifcfg-$i
echo $IPDIR/ifcfg-$i" generated"
done

