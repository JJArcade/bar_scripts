#!/bin/zsh

amixer -D pulse sget Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p' | uniq
