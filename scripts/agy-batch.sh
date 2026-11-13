#!/usr/bin/env bash
# Run one queue of Antigravity (agy) batches. Each batch is a text file of paths, one per line.
# usage: bash agy-batch.sh <batch-dir> <queue-index> <queue-count> <brief-file> [model]
#   batch-dir   folder holding b00.txt, b01.txt ... (one file list per batch)
#   queue-index this queue's number, 0-based; queue-count total queues run in parallel
#   brief-file  path (relative to the repo you run from) of the brief agy must follow
#   model       default gemini-4-hydrogen-high
# Run it from the repo or worktree being edited. Logs go to <batch-dir>/logs/.
set -u
dir=$1; q=$2; n=$3; brief=$4; model=${5:-gemini-4-hydrogen-high}
agy=${AGY:-$HOME/.local/bin/agy}
mkdir -p "$dir/logs"
i=0
for b in "$dir"/b*.txt; do
  if [ $((i % n)) -eq "$q" ]; then
    name=$(basename "$b" .txt)
    "$agy" -p "Follow $brief exactly. Do NOT run any shell command (not even checks); only read and edit files. Do not run git. Edit ONLY these files:
$(cat "$b")
Report one line per file: path — done, or path — left: n (why)." \
      --model "$model" --mode accept-edits --print-timeout 0 > "$dir/logs/$name.log" 2>&1
    echo "$name exit $?" >> "$dir/logs/done.txt"
  fi
  i=$((i + 1))
done
