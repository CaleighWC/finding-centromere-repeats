#!/bin/bash

# Input: "ngs" format table from Tandem Repeat Finder
# Output: Fasta with unique headers for each repeat, named with the read and
# count on that read.

# Stop on errors instead of continuing
set -euo pipefail

# Use awk to create fasta
awk '/^@/ {current_header=$1} !/^@/ {print ">" current_header "_" ++count[current_header] "\n" $14}' "$1"

