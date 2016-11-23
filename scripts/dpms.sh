#!/bin/bash

case "$1" in
    "toggle")
        if [ "$($0)" == "enabled" ]; then
            $0 disable
        else
            $0 enable
        fi
        ;;

    "disable")
        xset s off
        xset -dpms
        ;;

    "enable")
        xset s on
        xset +dpms
        ;;
    *)
        if [ $(xset q | grep "DPMS is" | grep Disabled | wc -l) -gt 0 ]; then
            echo -n "disabled"
        else
            echo -n "enabled"
        fi
        ;;
esac

