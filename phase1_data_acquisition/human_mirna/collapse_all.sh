#!/bin/bash
# =============================================================================
# PHASE 1 | miRNA PIPELINE: COUNT COLLAPSE
# Dataset: GSE202708 (Human miRNA-seq — Ischemic Stroke)
# =============================================================================
# PURPOSE:
#   Collapses per-sample miRDeep2 quantification CSV files into a single
#   unified count matrix. Duplicate mature miRNA entries within a sample are
#   summed (splice isoform collapse).
#
# INPUT : quantified/{SAMPLE}/miRNAs_expressed_all_samples_*.csv
# OUTPUT: miRNA_count_matrix_raw.csv   (input for Phase 2 preprocessing)
# =============================================================================

set -euo pipefail

source ~/miniconda3/etc/profile.d/conda.sh
conda activate mirna

QUANT_DIR="quantified"
OUT_FILE="miRNA_count_matrix_raw.csv"

echo "============================================"
echo "Collapsing per-sample CSVs → single matrix"
echo "============================================"

# SKELETON:
# Each sample's quantifier.pl output is a tab-separated file with columns:
#   #miRNA | read_count | mean(norm_read_count) | ...
#
# This step:
#   1. Reads all per-sample CSVs from $QUANT_DIR/
#   2. Extracts miRNA name + read_count columns only
#   3. Collapses duplicate miRNA entries by summing read_count
#   4. Merges all samples into one matrix by miRNA identifier
#   5. Fills missing values with 0
#
# Final output:
#   Rows   = unique miRNA identifiers (hsa-miR-*)
#   Columns = sample accession IDs (GSM*)
#
# See build_count_matrix.R for the R-based implementation of this logic.

Rscript build_count_matrix.R

echo "Collapse complete → $OUT_FILE"
