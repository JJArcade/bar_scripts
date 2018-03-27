#!/bin/bash

network() {
	read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`

	# iwconfig returns an error if the interface tseted has no wireless extensions

	if iwconfig $int1 >/dev/null 2>&1; then
		wifi=$int1
		eth0=$int2
	else
		wifi=$int2
		eth0=$int1
	fi

	ip link show $eth0 | grep 'state UP' >/dev/null && int=$eth0 || int=$wifi

	# echo -n "$int"

	ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "$int connected" || echo "$int disconnected"
}

memory() {
	# store memory
	read t f <<< `grep -E 'Mem(Total|Free)' /proc/meminfo | awk '{print $2}'`
	read b c <<< `grep -E '^(Buffers|Cached)' /proc/meminfo |awk '{print $2}'`

	# calc memory
	bc <<< "100*($t -$f -$c -$b) / $t"
	# echo $t $f $b $c
	# echo -n "100($t-$f-$c-$b)/$t"
}

vol() {
	amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p' | uniq
}

wm() {
	cwin=`xprop -root _NET_CURRENT_DESKTOP | awk '{print int( $3 )}'`
	tot=`xprop -root _NET_NUMBER_OF_DESKTOPS | awk '{print int( $3 )}'`

	for w in `seq 1 $((cwin - 1))`; do line="${line}="; done
	# echo $line

	line="${line}|"
	# echo $line

	for w in `seq $((cwin + 2)) $tot`; do line="${line}="; done
	echo $line
}

clock() {
	date '+%H:%M - %a %b %Y CHECK IT'
}

# buffering loop
while :; do
	buf=""
	buf="${buf} [$(wm)]  -- "
	buf="${buf} CLK: $(clock) -"
	buf="${buf} NET: $(network) -"
	buf="${buf} RAM: $(memory)%% -"
	buf="${buf} VOL: $(vol)%%"

	echo $buf
	sleep 1
done
