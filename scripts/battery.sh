#!/bin/bash

PREFIX=/sys/class/power_supply
BATTERIES="BAT0 BAT1"
ALARM=15

case "$1" in
    "state")
        AC_ONLINE=$(cat $PREFIX/AC/online)
        if [ $AC_ONLINE -gt 0 ]; then
            echo -n "AC "
        else
            echo -n "BAT "
        fi

        declare -i TOTAL_FULL
        declare -i TOTAL_NOW
        TOTAL_FULL=0
        TOTAL_NOW=0
            
        for bat in $BATTERIES; do
            TOTAL_FULL=$TOTAL_FULL+$(cat $PREFIX/$bat/energy_full)
            TOTAL_NOW=$TOTAL_NOW+$(cat $PREFIX/$bat/energy_now)
        done

        declare -i PERCENT
        PERCENT=100*$TOTAL_NOW/$TOTAL_FULL

        echo -n $PERCENT

        ;;
    *)
        cat $PREFIX/$1/capacity
        ;;
esac

