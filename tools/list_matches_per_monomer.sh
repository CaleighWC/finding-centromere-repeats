#!/bin/bash

# Input: BLAST+ result tsv where col 1 is query ID and col 2 is database ID.

# Output: File with one line per unique query ID. Format is query ID, two
# spaces, then pipe separated list of other monomer IDs that this query 
# monomer matched to. 

# Stop on errors instead of continuing
set -euo pipefail

# Use awk to list matches per monomer
awk -F'\t' '{ matches[$1] = matches[$1] " " $2 } END { for (q in matches) print q, matches[q] }' "$1"
