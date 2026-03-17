#!/usr/bin/env python3
import os
import sys
import subprocess

HIST_FILE = os.environ.get("HIST_FILE", "./output_history.log")


def read_history(path):
    if not os.path.exists(path):
        return []
    with open(path, "r", encoding="utf-8") as f:
        return [line.rstrip("\n") for line in f]


def append_history(path, value):
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    with open(path, "a", encoding="utf-8") as f:
        f.write(value + "\n")


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} command [args...]", file=sys.stderr)
        sys.exit(1)

    result = subprocess.run(sys.argv[1:], capture_output=True, text=True)
    current = result.stdout.rstrip("\n")

    history = read_history(HIST_FILE)
    last = history[-1] if history else None

    if current != last:
        append_history(HIST_FILE, current)
        history.append(current)

    print(current)

    prev = []
    seen = {current}

    for item in reversed(history[:-1] if history and history[-1] == current else history):
        if item in seen:
            continue
        prev.append(item)
        seen.add(item)
        if len(prev) == 2:
            break

    for item in prev:
        print(item)


if __name__ == "__main__":
    main()
