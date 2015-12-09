#!/bin/bash

#PBS -W group_list=anling
#PBS -q windfall
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=12:mem=24gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M kmcarter91@email.arizona.edu
#PBS -m bea

#Parameters
CWD=$(pwd)
FASTA_IN="$CWD/projectabe487/data/split/Swab.162.10.fasta"
OUT_DIR="$CWD/projectabe487/otus_uclust/"

#Pick OTUs
module load qiime
pick_open_reference_otus.py -i $FASTA_IN -o $OUT_DIR
