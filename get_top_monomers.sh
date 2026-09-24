#!/bin/bash

# Input: TRF output and a custom Blast+ "ngs" output format. 
# Output: Files listing which monomers were blast matches for which others,

trf_output="$1"
blast_output="$2"
scope="$3"

# Stop on errors instead of continuing
set -euo pipefail

# Get the location of this script so it can find tools (not the working directory)
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Filter blast output
printf "\nFiltering blast output\n"

filtered_blast="blast_filtered_${scope}.txt"

if [[ ${scope} == "global" ]]; then

	printf "\nThe filtering scope is global\n"
	${script_dir}/tools/blast_filtering_global.sh "${blast_output}" \
	> ${filtered_blast}

elif [[ ${scope} == "local" ]]; then

	printf "\nThe filtering scope is local\n"
	${script_dir}/tools/blast_filtering_local.sh "${blast_output}" \
	> ${filtered_blast}

else
	printf "\nA recognized filtering scope (parameter 3) was not provided.\n"

fi

# Create list of matches
printf "\nCreating list of matches\n"

match_list="matches_per_monomer_${scope}.txt"

${script_dir}/tools/list_matches_per_monomer.sh ${filtered_blast} \
> ${match_list}

# Calculate the length times count for each monomer
# This should be the same for local and global, but
# I'm still adding a separate name for now to make
# it not potentially overwrite in case it's bad. I will think
# about it more later.
printf "\nCreating length-times-count file\n"

len_times_count="len_times_count_${scope}.txt"

${script_dir}/tools/len_times_counts_lookup.sh ${trf_output} \
> ${len_times_count}

# Calculate the tandem repeat mass of each monomer by adding the length times
# count values for it and all its matches. Then sort descending by the second
# column (the masses).
printf "\nCreating sorted file with tandem repeat masses of each monomer\n"

tandem_repeat_masses="tandem_repeat_masses_${scope}.txt"

${script_dir}/tools/calc_tandem_repeat_mass.sh ${len_times_count} \
| sort -k2,2nr \
> ${tandem_repeat_masses}

# Collapse the list of monomers and masses into a list of the top clusters and
# their masses.
printf "\nClustering and keeping representative sequence for each cluster with cumulative mass\n"

top_clusters="top_clusters_${scope}.txt"

${script_dir}/tools/clustering.sh ${tandem_repeat_masses} ${match_list} 100 \
> ${top_clusters}

printf "\nThe script is complete.\n"

