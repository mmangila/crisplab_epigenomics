#!/bin/bash -l
#PBS -A UQ-SCI-SAFS
#PBS -N deeptools
#PBS -r y
#PBS -m abej
#PBS -M p.crisp@uq.edu.au

########## QC #################
set -xeuo pipefail

echo ------------------------------------------------------
echo -n 'Job is running on node '; cat $PBS_NODEFILE
echo ------------------------------------------------------
echo PBS: qsub is running on $PBS_O_HOST
echo PBS: originating queue is $PBS_O_QUEUE
echo PBS: executing queue is $PBS_QUEUE
echo PBS: working directory is $PBS_O_WORKDIR
echo PBS: execution mode is $PBS_ENVIRONMENT
echo PBS: job identifier is $PBS_JOBID
echo PBS: job name is $PBS_JOBNAME
echo PBS: node file is $PBS_NODEFILE
echo PBS: current home directory is $PBS_O_HOME
echo PBS: PATH = $PBS_O_PATH
echo PBS: array_ID is ${PBS_ARRAY_INDEX}
echo ------------------------------------------------------

echo working dir is $PWD

#cd into work dir
echo changing to PBS_O_WORKDIR
cd "$PBS_O_WORKDIR"
echo working dir is now $PWD

########## Modules #################
conda activate py3.7
# module load R/3.5.0-gnu
########## Set up dirs #################

#get job ID
#use sed, -n supression pattern space, then 'p' to print item number {PBS_ARRAY_INDEX} eg 2 from {list}
ID="$(/bin/sed -n ${PBS_ARRAY_INDEX}p ${LIST})"

echo sample being mapped is $ID

#make adaligned folder bsmaped
cd analysis
mkdir -p $out_dir

########## Run #################

#plot
plotProfile \
-m ${out_dir}/${ID}.mat.gz \
-out ${out_dir}/${ID}.mat_metaplot.png \
--numPlotsPerRow 1 \
--yMin 0 \
--yMax 0.5

# heatmap
plotHeatmap \
-m ${out_dir}/${ID}.mat.gz \
-out ${out_dir}/${ID}.mat_heatmap.png \
--zMin 0 \
--zMax 1.0

echo finished summarising
