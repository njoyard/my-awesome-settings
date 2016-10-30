#!/bin/bash

[ "$UID" -ne "0" ] && echo "Root required" && exit 1

DIR=$(realpath $(dirname $0))

ln -sf $DIR/awesome.session /usr/share/gnome-session/sessions/awesome.session
ln -sf $DIR/awesome.desktop /usr/share/applications/awesome.desktop
ln -sf $DIR/awesome.desktop /usr/share/xsessions/awesome.desktop
ln -sf $DIR/awesome-gnome.desktop /usr/share/xsessions/awesome-gnome.desktop
ln -sf $DIR/gnome-session-awesome /usr/bin/gnome-session-awesome

AUTOSTART=gnome-settings-daemon

for a in $AUTOSTART; do
    $DESKTOP=/etc/xdg/autostart/$a.desktop
    if [ -f $DESKTOP -a "$(grep OnlyShowIn $DESKTOP)" -a "$(grep OnlyShowIn $DESKTOP | grep -v Awesome)" ]; then
        sed -i -r "s:OnlyShowIn=:OnlyShowIn=Awesome;:" $DESKTOP
    fi
done

