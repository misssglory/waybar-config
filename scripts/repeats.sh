#!/usr/bin/env bash
set -euo pipefail

HIST_FILE="${HIST_FILE:-/home/mg/sh/output_history.log}"

if (($# == 0)); then
    echo "Usage: $0 command [args...]"
    exit 1
fi

mkdir -p "$(dirname "$HIST_FILE")"
touch "$HIST_FILE"

current="$("$@")"

last=""
if [[ -s "$HIST_FILE" ]]; then
    last=$(tail -n 1 "$HIST_FILE")
fi

if [[ "$current" != "$last" ]]; then
    printf '%s\n' "$current" >> "$HIST_FILE"
fi

printf '%s\n' "$current"

prev1=""
prev2=""

if [[ -s "$HIST_FILE" ]]; then
    mapfile -t hist < <(tail -n 20 "$HIST_FILE")

    for ((i=${#hist[@]}-1; i>=0; i--)); do
        v="${hist[i]}"

        if [[ "$v" == "$current" ]]; then
            continue
        fi

        if [[ -z "$prev1" ]]; then
            prev1="$v"
            continue
        fi

        if [[ "$v" != "$prev1" ]]; then
            prev2="$v"
            break
        fi
    done
fi

[[ -n "$prev1" ]] && printf '%s\n' "$prev1"
[[ -n "$prev2" ]] && printf '%s\n' "$prev2"
