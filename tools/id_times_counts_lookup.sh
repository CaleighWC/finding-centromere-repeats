#!/bin/bash

# Use trf ngs output to make a table containing unique repeat IDs, consensus
# lengths, counts, and consensus multiplied by count
awk '/^@/ {current_header=$1} !/^@/ {print current_header "_" ++count[current_header], $5, $4, $5 * $4}' "$1"
