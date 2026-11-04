#!/usr/bin/env bash

if pgrep -x "qalculate-gtk" > /dev/null; then
    pkill -9 -x "qalculate-gtk"
else
    qalculate-gtk &
fi
