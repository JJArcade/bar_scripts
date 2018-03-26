#!/bin/bash

read a b <<< `grep -E 'Mem(Total|Free)' /proc/meminfo | awk '{print $2}'`

echo $a
echo $b
