#!/usr/bin/env bash

if pgrep -x "calcure" >/dev/null; then
    pkill -9 -x "calcure"
else
    foot -e calcure &
fi
