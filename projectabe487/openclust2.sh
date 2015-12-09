#!/bin/bash
#Parameters
CWD=$(pwd)
FASTA_IN="$CWD/data/swab.seqs.fna"
OUT_DIR="$CWD/otus_uclust/"

#Pick OTUs
module load qiime
pick_open_reference_otus.py -i $FASTA_IN -o $OUT_DIR
