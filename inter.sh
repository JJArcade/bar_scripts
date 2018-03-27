#!/bin/bash

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

echo -n "$int"

ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "connected" || echo "disconnected"
