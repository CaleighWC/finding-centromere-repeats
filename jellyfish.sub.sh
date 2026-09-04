#!/bin/bash

#SBATCH --time=0-00:05:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --job-name="jellyfish.sub.sh"
#SBATCH --account=def-dirwin
#SBATCH --output=job_%j.out
#SBATCH --mail-user=cwc@zoology.ubc.ca
#SBATCH --mail-type=ALL

# Setting initial variables

scratchpath="/home/cwcharle/scratch"

this_filename="jellyfish.sub.sh"

prologue_filename="tools/single_job_prologue.sh"

# Run prologue script to take care of some logging and synchronize jobtimes
source ${prologue_filename}

# Load modules
printf "\nCurrently loaded modules\n"
module list

module load \
jellyfish/2.3.1

printf "\nCurrently loaded modules\n"
module list

# Create variables with paths and names of input and output files
# This is the last spot where you need to ADD VARIABLES (3/3)

# The path where you would like the job output to be placed
out_dir_path="/home/cwcharle/scratch/finding-centromere-repeats/jellyfish/"
log_archive_dir="/home/cwcharle/projects/def-dirwin/cwcharle/finding-centromere-repeats/copied_output_logs"

# The path to and names of PacBio HiFi read fasta files
fasta_path="/home/cwcharle/projects/def-dirwin/cwcharle/gw2022_data/HiFi_raw_reads/"
#fasta_path="/home/cwcharle/projects/def-dirwin/cwcharle/gwstaffan_data/gwstaffan_raw_reads"

fasta_name="P_trochiloides.HiFi.cells_concat.fasta"
#fasta_name="staffan_gw_ref.hifi_reads.default.fasta"

# Copy input files to temp node local directory
# This makes reads/writes faster during the job

cp ${fasta_path}/${fasta_name} ${SLURM_TMPDIR}

printf "\nThe files in SLURM_TMPDIR are:\n"
echo $(ls ${SLURM_TMPDIR})

# Change working directory to the temp node local directory
# This is just so we can use smaller file paths and all outputs
# are generated on the node

mkdir ${SLURM_TMPDIR}/${jobtime}

printf "\nChanging working directory to job directory within SLURM_TMPDIR\n"
cd ${SLURM_TMPDIR}/${jobtime}

printf "\nStarting to run jellyfish\n"

# Run jellyfish
jellyfish count \
-t 16 \
--mer-len 17 \
--size 3G \ 
--canonical true \
--lower-count 10 \
--timing \
${fasta_name}

# Move output back to output directory in projects directory

printf "\nCopying final output file back to projects directory in ${out_dir_path}\n"

mkdir -p ${out_dir_path}/

cp -r ${SLURM_TMPDIR}/${jobtime} ${out_dir_path}/

printf "\n These are the files in the output directory\n"
ls ${out_dir_path}

printf "\n Moving logfile to the output folder \n"
mv ${init_wd}/${log_filename} ${out_dir_path}/${jobtime}

printf "\n Copying logfile to the archive folder \n"
cp ${out_dir_path}/${jobtime}/${log_filename} ${log_archive_dir}

printf "\nScript complete\n"
