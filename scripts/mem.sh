#!/bin/bash

declare -i MEMTOTAL
declare -i MEMFREE
declare -i MEMUSED
declare -i PERCENT_USED

MEMTOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2;}')
MEMFREE=$(grep MemAvailable /proc/meminfo | awk '{print $2;}')

MEMUSED=$MEMTOTAL-$MEMFREE
PERCENT_USED=100*$MEMUSED/$MEMTOTAL

echo -n $PERCENT_USED

