#!/bin/bash

# Input: Two inputs. 
# 1: Lookup table produced by id_times_count_lookup.sh containing
# the unique repeat IDs, consensus lengths, counts, and consensus 
# multiplied by count.
# 2: BLAST+ custom output where field 1 is query and field 2 is database
# Output: Each row contains a field for monomer ID and a field with
# the summed (length * count) values for all its matches, including the
# value for this monomer itself. (It is assumed the input file has been
# cleared of self-matches already.) 

# Stop on errors instead of continuing
set -euo pipefail

# Name variables for clarity
id_times_count="$1"
blast_output="$2"

# Calculate tandem mass
awk '
	NR == FNR \
		{ amt[$1] = $2; next }
		{ mass[$1] = mass[$1] + amt[$2] }
	END { for (q in mass) print q, mass[q] + amt[q] }
' ${id_times_count} ${matches_per_monomer}

