#!/usr/bin/env bash

if pgrep -x "qalc" > /dev/null; then
    pkill -9 -x "qalc"
else
    kitty -e qalc &
fi
