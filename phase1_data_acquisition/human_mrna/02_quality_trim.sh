#!/bin/bash
# =============================================================================
# PHASE 1 | STEP 2: QUALITY TRIMMING (fastp)
# Dataset: GSE202518 (Human mRNA — Ischemic Stroke, RNA-seq)
# =============================================================================
# PURPOSE:
#   Performs adapter trimming and quality filtering on paired-end FASTQ files
#   using fastp. Processes samples sequentially to avoid I/O contention on
#   shared HPC storage. Generates per-sample HTML/JSON QC reports.
#
# TOOL: fastp (auto-detect PE adapters) + pigz (parallel compression)
#
# USAGE:
#   bash 02_quality_trim.sh
# =============================================================================

set -euo pipefail

source ~/miniconda3/etc/profile.d/conda.sh
conda activate mrna

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
SRR_LIST="metadata/srr_list.txt"
RAW_DIR="raw_data"
TRIM_DIR="trimmed"
LOG_DIR="logs"
THREADS=$(nproc)

mkdir -p "$TRIM_DIR" "$LOG_DIR"

MASTER_LOG="$LOG_DIR/trim_master.log"

echo "============================================" | tee -a "$MASTER_LOG"
echo "Sequential trimming started : $(date)"       | tee -a "$MASTER_LOG"
echo "Threads                     : $THREADS"      | tee -a "$MASTER_LOG"
echo "============================================" | tee -a "$MASTER_LOG"

# -----------------------------------------------------------------------------
# TRIMMING LOOP
# -----------------------------------------------------------------------------
# SKELETON: fastp is called with --detect_adapter_for_pe to auto-infer adapter
# sequences from paired-end read chemistry. After successful trimming, raw
# FASTQs are compressed with pigz and deleted to conserve disk space.
#
# fastp parameters (applied but not shown):
#   --detect_adapter_for_pe    → auto-detect PE adapters
#   --thread $THREADS          → parallel execution
#   --html / --json            → per-sample QC reports
# -----------------------------------------------------------------------------

while IFS= read -r SRR; do

    RAW1="$RAW_DIR/${SRR}_1.fastq"
    RAW2="$RAW_DIR/${SRR}_2.fastq"
    TRIM1="$TRIM_DIR/${SRR}_1.trimmed.fastq"
    TRIM2="$TRIM_DIR/${SRR}_2.trimmed.fastq"

    # Skip missing raws
    if [[ ! -f "$RAW1" ]] || [[ ! -f "$RAW2" ]]; then
        echo "SKIP: $SRR — raw files not found." | tee -a "$MASTER_LOG"
        continue
    fi

    echo "Trimming: $SRR" | tee -a "$MASTER_LOG"

    # SKELETON: fastp execution block omitted.
    # Output: $TRIM_DIR/${SRR}_1.trimmed.fastq.gz
    #         $TRIM_DIR/${SRR}_2.trimmed.fastq.gz
    #         $TRIM_DIR/${SRR}.fastp.html
    #         $TRIM_DIR/${SRR}.fastp.json

    echo "Compressing trimmed files for $SRR..." | tee -a "$MASTER_LOG"
    # SKELETON: pigz compression + raw file deletion logic omitted.

    echo "Finished: $SRR — $(date)" | tee -a "$MASTER_LOG"
    echo "--------------------------------------------" | tee -a "$MASTER_LOG"

done < "$SRR_LIST"

echo "============================================" | tee -a "$MASTER_LOG"
echo "All trimming complete: $(date)"              | tee -a "$MASTER_LOG"
echo "============================================" | tee -a "$MASTER_LOG"
