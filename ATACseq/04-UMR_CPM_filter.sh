#!/bin/bash -l
#PBS -A UQ-SCI-SAFS
#PBS -N umrs
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
module load bedtools
# module load R/3.5.0-gnu
########## Set up dirs #################

#get job ID
#use sed, -n supression pattern space, then 'p' to print item number {PBS_ARRAY_INDEX} eg 2 from {list}
ID="$(/bin/sed -n ${PBS_ARRAY_INDEX}p ${LIST})"

echo sample being mapped is $ID

#make adaligned folder bsmaped
cd analysis
mkdir -p tiles

########## Run #################

#### filter
awk -v CPM_filter_UMRs=$CPM_filter_UMRs '$4 > CPM_filter_UMRs' tiles/${ID}_100bp_CPM.bed |
bedtools merge -d 100 -c 4 -o sum -i - > tiles/${ID}_100bp_CPM_${CPM_filter_UMRs}_UMRs.bed

#### merge to call UMRs

echo finished summarising
