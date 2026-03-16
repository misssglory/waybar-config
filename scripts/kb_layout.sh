#!/bin/bash
# (Inside a while loop or using traps to catch signals)
layout=$(setxkbmap -query | grep layout | awk '{print $2}' | tr '[:lower:]' '[:upper:]')
printf '%s\n' "$layout"
