#!/bin/bash
# =============================================================================
# PHASE 1 | miRNA PIPELINE: EXPRESSION QUANTIFICATION (miRDeep2)
# Dataset: GSE202708 (Human miRNA-seq — Ischemic Stroke)
# =============================================================================
# PURPOSE:
#   Quantifies mature miRNA expression counts from aligned reads using
#   miRDeep2's quantifier.pl module against mature + precursor miRNA
#   references from miRBase (release 22.1).
#
# TOOL : miRDeep2 quantifier.pl
# REF  : miRBase v22.1 — hsa mature + hairpin sequences
# =============================================================================

set -euo pipefail

source ~/miniconda3/etc/profile.d/conda.sh
conda activate mirna

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
MAP_DIR="mapped"
QUANT_DIR="quantified"
REF_DIR="reference"
MATURE_FA="$REF_DIR/mature_hsa.fa"       # miRBase v22.1 mature sequences
HAIRPIN_FA="$REF_DIR/hairpin_hsa.fa"     # miRBase v22.1 hairpin sequences
THREADS=$(nproc)

mkdir -p "$QUANT_DIR"

echo "============================================"
echo "miRNA quantification started: $(date)"
echo "============================================"

# -----------------------------------------------------------------------------
# SKELETON: quantifier.pl parameters (applied but not shown):
#   -p $HAIRPIN_FA    → precursor miRNA sequences
#   -m $MATURE_FA     → mature miRNA sequences
#   -r reads_collapsed.fa
#   -t hsa            → species prefix filter
#   -y $(date +%Y%m%d)
#
# Output per sample:
#   miRNAs_expressed_all_samples_*.csv
#     Columns: #miRNA | read_count | mean(norm_read_count) | ...
# -----------------------------------------------------------------------------

for SAMPLE_DIR in "$MAP_DIR"/*/; do

    SAMPLE=$(basename "$SAMPLE_DIR")
    OUT_DIR="$QUANT_DIR/$SAMPLE"
    mkdir -p "$OUT_DIR"

    COLLAPSED="$SAMPLE_DIR/reads_collapsed.fa"
    ARF="$SAMPLE_DIR/reads_collapsed_vs_genome.arf"

    if [[ ! -f "$COLLAPSED" ]] || [[ ! -f "$ARF" ]]; then
        echo "SKIP: $SAMPLE — mapping outputs missing."
        continue
    fi

    echo "Quantifying: $SAMPLE"
    # SKELETON: quantifier.pl call omitted.
    # Output: $OUT_DIR/miRNAs_expressed_all_samples_*.csv

done

echo "Quantification complete: $(date)"
