#!/bin/bash

DEVICE=/sys/class/backlight/intel_backlight

case "$1" in
    "max")
        cat $DEVICE/max_brightness
        ;;

    "cur")
        cat $DEVICE/brightness
        ;;

    *)
        echo $1 | sudo tee $DEVICE/brightness
        ;;
esac

