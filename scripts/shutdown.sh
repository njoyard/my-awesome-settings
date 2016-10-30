#!/bin/sh

ACTION=`zenity --width=90 --height=250 --list --text="Select action" --title="Logout" --column "Action" Shutdown Reboot LockScreen Suspend`

if [ -n "${ACTION}" ];then
  case $ACTION in
  Shutdown)
    zenity --question --text "Shutdown?" && gksudo shutdown -h now
    ;;
  Reboot)
    zenity --question --text "Reboot?" && gksudo shutdown -r now
    ;;
  Suspend)
    gksudo slock /usr/sbin/pm-suspend-hybrid
    ;;
  LockScreen)
    slock
    ;;
  esac
fi

