#!/bin/bash

declare -i TOTAL
declare -i IDLE
declare -i LAST_TOTAL
declare -i LAST_IDLE
declare -i TOTAL_DIFF
declare -i IDLE_DIFF
declare -i BUSY
declare -i PERCENT

LAST_TOTAL_FILE=/tmp/_cpu_total
LAST_IDLE_FILE=/tmp/_cpu_idle

[ ! -f $LAST_TOTAL_FILE ] && echo 0 > $LAST_TOTAL_FILE
[ ! -f $LAST_IDLE_FILE ] && echo 0 > $LAST_IDLE_FILE

STAT=$(cat /proc/stat | grep "cpu " | sed -r 's:cpu  ::')
TOTAL=$(echo $STAT | sed -r 's: :+:g')
IDLE=$(echo $STAT | awk '{print $4;}')
LAST_TOTAL=$(cat $LAST_TOTAL_FILE)
LAST_IDLE=$(cat $LAST_IDLE_FILE)

TOTAL_DIFF=$TOTAL-$LAST_TOTAL
IDLE_DIFF=$IDLE-$LAST_IDLE

BUSY=$TOTAL_DIFF-$IDLE_DIFF
PERCENT=100*$BUSY/$TOTAL_DIFF

echo -n $TOTAL > $LAST_TOTAL_FILE
echo -n $IDLE > $LAST_IDLE_FILE

echo -n $PERCENT

