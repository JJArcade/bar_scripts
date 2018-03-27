#!/bin/bash

num=1

for a in "$@"
do
	echo -e "$num:\t$a"
	((num++))
done
