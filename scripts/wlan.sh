#!/bin/bash

IFACE=$1
ESSID=$(/sbin/iwconfig $IFACE | grep ESSID | cut -d ':' -f 2 | sed -r 's:"::g' | sed -r 's:\s+$::' | sed -r 's: : :g')

if [ "x$ESSID" != "xoff/any" ]; then
    declare -i SIGNAL
    SIGNAL=100*$(/sbin/iwconfig $IFACE | grep "Link Quality" | awk '{print $2'} | cut -d '=' -f 2)
    IPV4=$(/sbin/ifconfig $IFACE | grep "inet " | awk '{print $2;}')
    IPV6=$(/sbin/ifconfig $IFACE | grep inet6 | grep global | awk '{print $2;}')
    echo -n "$ESSID $SIGNAL $IPV4 $IPV6"
else
    echo -n "off"
fi

