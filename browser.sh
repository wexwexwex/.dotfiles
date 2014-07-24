#!/bin/bash

if [[ $1 =~ \.webm$ ]]
then
        /usr/bin/mpv $1


elif [[ $1 =~ youtube.com ]] || [[ $1 =~ youtu.be ]]
then
	/usr/bin/mpv $1 2> ~/mystderr
	ret=$? 
	if [[ $ret != 0 ]]; then
		notify-send "Youtube video is blocked."
	fi

else
        /usr/bin/dwb $1
fi
