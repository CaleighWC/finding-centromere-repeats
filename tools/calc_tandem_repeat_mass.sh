#!/bin/bash

# Input: Lookup table produced by id_times_count_lookup.sh containing
# the unique repeat IDs, consensus lengths, counts, and consensus 
# multiplied by count
# Output: Each row contains a field for monomer ID and a field with
# the summed (length * count) values for all its matches, including the
# value for this monomer itself. (It is assumed the input file has been
# cleared of self-matches already.) 

# Stop on errors instead of continuing
set -euo pipefail

# Calculate tandem mass
awk '
	NR == FNR \
		{ amt[$1] = $2; next }
		{ mass[$1] = mass[$1] + amt[$2] }
	END { for (q in mass) print q, mass[q] + amt[q] }
' "$1"

