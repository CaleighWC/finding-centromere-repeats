#!/bin/bash

# Input: Special BLAST+ result tsv where col 1 is query ID, col 2 is
# database ID, and col 6 is percent of query covered by alignment.

# Output: Same BLAST+ result table but without self-matches and 
# matches covering 50% or less of the query. This is the filtering
# used in Melters et al. (2013) "global" mode. Also removes
# duplicates of entire lines.

awk '$1 != $2 && $6 > 50' | uniq "$1"

