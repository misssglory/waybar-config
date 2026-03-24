#!/usr/bin/env bash
set -euo pipefail

HIST_FILE="${HIST_FILE:-$HOME/.config/waybar/scripts/output_history.log}"
KEEP="${KEEP:-4}"   # how many previous distinct values to show

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

parts=("$current")
prev=()

if [[ -s "$HIST_FILE" ]]; then
    mapfile -t hist < <(tail -n 50 "$HIST_FILE")

    for ((i=${#hist[@]}-1; i>=0; i--)); do
        v="${hist[i]}"

        [[ "$v" == "$current" ]] && continue

        if ((${#prev[@]} == 0)) || [[ "$v" != "${prev[-1]}" ]]; then
            prev+=("$v")
            ((${#prev[@]} >= KEEP)) && break
        fi
    done
fi

parts+=("${prev[@]}")

printf '%s\n' "${parts[*]}"

