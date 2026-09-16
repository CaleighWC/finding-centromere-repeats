#!/bin/bash

# Input: TRF output and a custom Blast+ "ngs" output format. 
# Output: Files listing which monomers were blast matches for which others,

trf_output="$1"
blast_output="$2"
scope="$3"

# Filter blast output

filtered_blast_name="blast_filtered_${scope}.txt"

if [[ ${scope} == "global" ]]; then
	tools/blast_filtering_global.sh "${blast_output}" \
	> ${filtered_blast}

elif [[ ${scope} == "local" ]]; then
	tools/blast_filtering_local.sh "${blast_output}" \
	> ${filtered_blast}

else
	printf "\nA recognized scope was not provided.\n"

fi

# Create list of matches

match_list="matches_per_monomer_${scope}.txt"

tools/list_matches_per_monomer.sh ${filtered_blast} \
> ${match_list}

# Calculate the length times count for each monomer
# This should be the same for local and global, but
# I'm still adding a separate name for now to make
# it not potentially overwrite in case it's bad. I will think
# about it more later.

len_times_count="len_times_count_${scope}.txt"

tools/len_times_counts_lookup.sh ${trf_output} \
> ${len_times_count}

# Calculate the tandem repeat mass of each monomer by adding the length times
# count values for it and all its matches. Then sort descending by the second
# column (the masses).

tandem_repeat_masses="tandem_repeat_masses_${scope}.txt"

tools/calc_tandem_repeat_mass.sh ${len_times_count} \
| sort -k2,2nr \
> ${tandem_repeat_masses}

# Collapse the list of monomers and masses into a list of the top clusters and
# their masses.

top_clusters="top_clusers_${scope}.txt"

tools/clustering.sh ${tandem_repeat_masses} ${match_list} 100 \
> ${top_clusters}

