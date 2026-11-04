#!/usr/bin/env bash

if pgrep -x "btop" > /dev/null; then
    pkill -9 -x "btop"
else
    kitty -e btop &
fi
