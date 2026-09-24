#!/bin/bash

# Input: Special BLAST+ result tsv where col 1 is query ID, col 2 is
# database ID, and col 6 is percent of query covered by alignment.

# Output: Same BLAST+ result table but without self-matches. 
# This is the filtering used in Melters et al. (2013) "local" mode. 
# Also removes duplicates of entire lines.

# Stop on errors instead of continuing
set -euo pipefail

# Filter blast
awk '$1 != $2' "1" | uniq

