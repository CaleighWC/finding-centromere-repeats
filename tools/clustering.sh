trmass_file="$1"
matches_file="$2"

# Make a temporary file to remove monomers from as their cluster is defined
cp ${trmass_file} tmp_for_clustering.txt

while [ -s tmp_for_clustering.txt ]
do

# Read the first value (biggest mass monomer ID) in the clustering file
read -r monomer_id total < tmp_for_clustering.txt

# Print that whole line to the standard output
printf "${monomer_id} ${total}\n"

# Get the list of monomer and its matches from the matches lookup file,
# separated with newlines so they can be used directly in grep for "or" matching
awk -v target="${monomer_id}" '$1 == target { $1=$1; print }' OFS='\n' "${matches_file}" > tmp_1line_matches.txt

# Remove all matching monomers from the temporary file before repeating loop
grep -F -v -w -f tmp_1line_matches.txt tmp_for_clustering.txt > tmp_for_clustering_new.txt
mv tmp_for_clustering_new.txt tmp_for_clustering.txt

done

rm tmp_for_clustering.txt
rm tmp_exclude_list.txt
rm tmp_1line_matches.txt
