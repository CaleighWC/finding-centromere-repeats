#!/bin/bash

#SBATCH --time=0-02:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --job-name="blast+.sub.sh"
#SBATCH --account=def-dirwin
#SBATCH --output=job_%j.out
#SBATCH --mail-user=cwc@zoology.ubc.ca
#SBATCH --mail-type=ALL

# Setting initial variables

scratchpath="/home/cwcharle/scratch"

this_filename="blast+.sub.sh"

prologue_filename="tools/single_job_prologue.sh"

# Run prologue script to take care of some logging and synchronize jobtimes
source ${prologue_filename}

# Load modules
printf "\nCurrently loaded modules\n"
module list

module load \
blast+/2.17.0

printf "\nCurrently loaded modules\n"
module list

# Create variables with paths and names of input and output files
# This is the last spot where you need to ADD VARIABLES (3/3)

# The path where you would like the job output to be placed
out_dir_path="/home/cwcharle/scratch/finding-centromere-repeats/blast+/"
log_archive_dir="/home/cwcharle/projects/def-dirwin/cwcharle/finding-centromere-repeats/copied_output_logs"

# The path to the fasta to use as database
db_path="/home/cwcharle/project/finding-centromere-repeats/results/trf/2026-Sep-08_09-12-23"

db_name="P_trochiloides.HiFi.cells_concat_downsampled.fasta.trf.ngs.tandemized"

# The path to fasta to use as query
query_fasta_path=${db_path}

query_fasta_name="P_trochiloides.HiFi.cells_concat_downsampled.fasta.trf.ngs.fa"

# The path to the .txt file with additional info on the fasta

query_txt_path=${db_path}

query_txt_name="P_trochiloides.HiFi.cells_concat_downsampled.fasta.trf.ngs.txt"

# Copy input files to temp node local directory
# This makes reads/writes faster during the job

cp ${db_path}/${db_name}* ${SLURM_TMPDIR}
cp ${query_fasta_path}/${query_fasta_name} ${SLURM_TMPDIR}

printf "\nThe files in SLURM_TMPDIR are:\n"
echo $(ls ${SLURM_TMPDIR})

# Change working directory to the temp node local directory
# This is just so we can use smaller file paths and all outputs
# are generated on the node

mkdir ${SLURM_TMPDIR}/${jobtime}

printf "\nChanging working directory to job directory within SLURM_TMPDIR\n"
cd ${SLURM_TMPDIR}/${jobtime}

printf "\nStarting to run blastn\n"

# Run blast
blastn \
-query ../${query_fasta_name} \
-db ../${db_name} \
-reward 1 \
-penalty -1 \
-gapopen 3 \
-gapextend 2 \
-word_size 10 \
-outfmt "6 qseqid sseqid pident length qlen qcovhsp evalue bitscore" \
-num_threads 16 \
-out mono_vs_tandemized.tsv

# Move output back to output directory in projects directory

printf "\nCopying final output file back to projects directory in ${out_dir_path}\n"

mkdir -p ${out_dir_path}/

cp -r ${SLURM_TMPDIR}/${jobtime} ${out_dir_path}/

printf "\n These are the files in the output directory\n"
ls ${out_dir_path}

printf "\n Copying extra file to output directory for this step to prepare for next step \n"
cp ${query_txt_path}/${query_txt_name} ${out_dir_path}/

printf "\n Moving logfile to the output folder \n"
mv ${init_wd}/${log_filename} ${out_dir_path}/${jobtime}

printf "\n Copying logfile to the archive folder \n"
cp ${out_dir_path}/${jobtime}/${log_filename} ${log_archive_dir}

printf "\nScript complete\n"
