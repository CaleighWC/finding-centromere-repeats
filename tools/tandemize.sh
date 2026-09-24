#!/bin/bash

#Input: "ngs" style table output from Tandem Repeat Finder
#Output: Fasta format file with headers being the read the monomer is from,
#plus a number for uniqueness. Body for each read is the monomer itself, but
#doubled in this file to tandemize so that blast can match other monomers to
#parts of the sequence that might wrap around the edge of this monomer. This
#is described in Melters et al. 2013.

# Stop on errors instead of continuing
set -euo pipefail

# Use awk to tandemize sequences
awk '/^@/ {current_header=$1} !/^@/ {print ">" current_header "_" ++count[current_header] "\n" $14 $14}' "$1"

