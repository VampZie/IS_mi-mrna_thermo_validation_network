#!/bin/bash
# =============================================================================
# PHASE 1 | miRNA PIPELINE: ADAPTER TRIMMING (small-RNA)
# Dataset: GSE202708 (Human miRNA-seq — Ischemic Stroke, small-RNA)
# =============================================================================
# PURPOSE:
#   Trims 3' adapter sequences from single-end small-RNA reads using Trimmomatic
#   or cutadapt. Critical for miRNA-seq where 18–24 nt reads require precise
#   adapter removal to avoid artificial truncation of seed sequences.
#
# TOOL: cutadapt (preferred for small-RNA)
# ADAPTER: Illumina TruSeq small-RNA 3' adapter
# =============================================================================

set -euo pipefail

source ~/miniconda3/etc/profile.d/conda.sh
conda activate mirna

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
RAW_DIR="raw_data"
TRIM_DIR="trimmed"
LOG_DIR="logs"
THREADS=$(nproc)

mkdir -p "$TRIM_DIR" "$LOG_DIR"

echo "============================================"
echo "Small-RNA trimming started: $(date)"
echo "============================================"

# -----------------------------------------------------------------------------
# SKELETON: Per-sample trimming loop
# Cutadapt parameters applied (not shown):
#   -a TGGAATTCTCGGGTGCCAAGG   → Illumina small-RNA 3' adapter
#   -m 16                      → minimum read length (filter miRNA fragments)
#   -M 30                      → maximum read length (filter rRNA/tRNA noise)
#   -q 20                      → quality trimming (Phred ≥ 20)
#   --discard-untrimmed        → keep only adapter-confirmed reads
# -----------------------------------------------------------------------------

for RAW_FASTQ in "$RAW_DIR"/*.fastq.gz; do

    SAMPLE=$(basename "$RAW_FASTQ" .fastq.gz)
    TRIM_OUT="$TRIM_DIR/${SAMPLE}_trimmed.fastq.gz"

    if [[ -f "$TRIM_OUT" ]]; then
        echo "SKIP: $SAMPLE — already trimmed."
        continue
    fi

    echo "Trimming: $SAMPLE"
    # SKELETON: cutadapt execution omitted.
    # Output: $TRIM_DIR/${SAMPLE}_trimmed.fastq.gz

done

echo "Trimming complete: $(date)"
