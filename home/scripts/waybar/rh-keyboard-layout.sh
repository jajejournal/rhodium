#!/usr/bin/env bash

current=$(niri msg keyboard-layouts 2>/dev/null | sed -n 's/^ \* [0-9][0-9]* //p')

case "$current" in
    Spanish)        layout="ES" ;;
    "English (US)") layout="US" ;;
    "")             layout="??" ;;
    *)              layout="${current:0:2}" ;;
esac

echo "$layout"
