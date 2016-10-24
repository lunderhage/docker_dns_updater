#!/bin/sh -e

echo $KEY

IP_FILE="/var/cache/dns_updater/ipaddress"
KEY_FILE="/var/cache/dns_updater/alphanumeric"
CURRENT_IP=`/usr/bin/host myip.opendns.com | grep "has address" | cut -d ' ' -f 4`
REGISTERED_IP="Unknown"

if [ -e $KEY_FILE ]; then
    KEY=`cat $KEY_FILE`
elif [ ! -z $KEY ]; then
    echo $KEY > $KEY_FILE
else
    echo "KEY must be set on first start."
    exit 1
fi

if [ -e "$IP_FILE" ];
then
    REGISTERED_IP=`cat $IP_FILE`
fi

if [ ! "$CURRENT_IP" = "$REGISTERED_IP" ];
then
   echo "Updating IP address from $REGISTERED_IP to $CURRENT_IP ..."
   curl -s -k http://freedns.afraid.org/dynamic/update.php?${KEY}
   echo $CURRENT_IP > $IP_FILE
fi
 
