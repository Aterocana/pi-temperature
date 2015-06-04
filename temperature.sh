#!/bin/sh

# Copyleft (C) 2015 Maurizio Dominici <dominicimaurizio@gmail.com>
# www.digitalsyncretism.com
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# version 2 as published by the Free Software Foundation.

output_file="/home/pi/data.json"

now=$(date)

if [ -f "/proc/uptime" ]; then
	uptime=$(cat /proc/uptime)
	uptime=${uptime%%.*}
	seconds=$(( uptime%60 ))
	minutes=$(( uptime/60%60 ))
	hours=$(( uptime/60/60%24 ))
	days=$(( uptime/60/60/24 ))
	uptime="$days days, $hours hours, $minutes minutes, $seconds seconds"
else
	uptime=""
fi

temp=$(/opt/vc/bin/vcgencmd measure_temp | sed "s/temp=//")

element="{\"date\":\""$(date)"\",\t\"temp\":\""$temp"\",\t\"uptime\":\""$uptime"\"}"

if [ -f $output_file ]; then
	sed -i "s/]/,\n$element]/" $output_file
else
	touch $output_file
	echo -e "[{\"date\":\""$(date)"\",\t\"temp\":\""$temp"\",\t\"uptime\":\""$uptime"\"}]" > $output_file
fi
