#!/bin/bash

# store memory
read t f <<< `grep -E 'Mem(Total|Free)' /proc/meminfo | awk '{print $2}'`
read b c <<< `grep -E '^(Buffers|Cached)' /proc/meminfo |awk '{print $2}'`

# calc memory
bc <<< "100*($t -$f -$c -$b) / $t"
# echo $t $f $b $c
# echo -n "100($t-$f-$c-$b)/$t"

