#!/bin/sh
xset +fp $HOME/.fonts
xrdb ~/.Xresources
mpd
/usr/bin/mpdscribble --conf /home/akari/.mpdscribble/mpdscribble.conf
/usr/bin/start-pulseaudio-x11
xbindkeys
exec awesome
