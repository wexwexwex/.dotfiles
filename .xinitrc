#!/bin/sh
xset +fp $HOME/.fonts
xrdb ~/.Xresources
nitrogen --restore
mpd
/usr/bin/mpdscribble --conf /home/akari/.mpdscribble/mpdscribble.conf
/usr/bin/start-pulseaudio-x11
compton -C -b --config /home/akari/.config/compton.conf
xbindkeys
setterm -blank 0
setterm -powersave off
setterm  -powerdown 0
xset s off
exec i3
