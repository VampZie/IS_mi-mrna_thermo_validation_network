#!/bin/bash
# =============================================================================
# PHASE 1 | STEP 1: SRA DOWNLOAD ENGINE
# Dataset: GSE202518 (Human mRNA — Ischemic Stroke, RNA-seq)
# =============================================================================
# PURPOSE:
#   Automates retrieval of raw SRA archives from NCBI with built-in retry
#   logic and resume capability, designed for HPC environments where jobs
#   may get interrupted mid-download.
#
# TOOL CHAIN:
#   prefetch (SRA-Toolkit) → fasterq-dump → pigz (parallel compression)
#
# USAGE:
#   nohup bash 01_sra_download.sh > logs/nohup_download.log 2>&1 &
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# ENVIRONMENT
# -----------------------------------------------------------------------------
source ~/miniconda3/etc/profile.d/conda.sh
conda activate mrna

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
SRR_LIST="metadata/srr_list.txt"      # One SRR accession per line
RAW_DIR="raw_data"
SRA_DIR="$HOME/ncbi/public/sra"
TMP_DIR="scratch/tmp"
LOG_DIR="logs"
THREADS=$(nproc)

mkdir -p "$RAW_DIR" "$TMP_DIR" "$LOG_DIR"

MASTER_LOG="$LOG_DIR/master_pipeline.log"
DOWNLOAD_LOG="$LOG_DIR/download.log"
FAILED_LOG="$LOG_DIR/failed_downloads.txt"

echo "============================================" | tee -a "$MASTER_LOG"
echo "Pipeline started  : $(date)"                 | tee -a "$MASTER_LOG"
echo "Threads available : $THREADS"                | tee -a "$MASTER_LOG"
echo "============================================" | tee -a "$MASTER_LOG"

# -----------------------------------------------------------------------------
# STEP 1 — PREFETCH (SRA binary download with retry)
# -----------------------------------------------------------------------------
# SKELETON: The loop below implements a 3-attempt retry-aware download.
# Each attempt is logged with timestamp. Failed accessions are written to
# $FAILED_LOG for post-run inspection and re-queuing.
# -----------------------------------------------------------------------------

echo "Starting SRA download phase..." | tee -a "$MASTER_LOG"

while IFS= read -r SRR; do

    SRA_FILE="$SRA_DIR/${SRR}.sra"

    # Skip if already downloaded (resume-safe)
    if [[ -f "$SRA_FILE" ]]; then
        echo "$SRR — already cached. Skipping." | tee -a "$DOWNLOAD_LOG"
        continue
    fi

    echo "Downloading: $SRR" | tee -a "$DOWNLOAD_LOG"

    # 3-attempt retry loop
    for attempt in 1 2 3; do
        echo "  Attempt $attempt / 3 for $SRR" | tee -a "$DOWNLOAD_LOG"
        # SKELETON: prefetch call omitted — implementation uses:
        #   prefetch $SRR >> $DOWNLOAD_LOG 2>&1 && break
        sleep 1  # placeholder
    done

    # Validate download success
    if [[ ! -f "$SRA_FILE" ]]; then
        echo "FAILED: $SRR — added to failed log." | tee -a "$MASTER_LOG"
        echo "$SRR" >> "$FAILED_LOG"
        continue
    fi

    echo "$SRR — download confirmed." | tee -a "$DOWNLOAD_LOG"

done < "$SRR_LIST"

# -----------------------------------------------------------------------------
# STEP 2 — FASTERQ-DUMP (SRA → paired FASTQ)
# -----------------------------------------------------------------------------
# SKELETON: Converts each .sra to split _1.fastq / _2.fastq with multi-thread
# support. Skips samples already converted (resume-safe).
# Output: raw_data/{SRR}_1.fastq, raw_data/{SRR}_2.fastq
# -----------------------------------------------------------------------------

echo "Starting fasterq-dump phase..." | tee -a "$MASTER_LOG"

while IFS= read -r SRR; do

    FASTQ1="$RAW_DIR/${SRR}_1.fastq"

    if [[ -f "$FASTQ1" ]]; then
        echo "$SRR — FASTQ already exists. Skipping." | tee -a "$MASTER_LOG"
        continue
    fi

    echo "Converting $SRR → FASTQ..." | tee -a "$MASTER_LOG"
    # SKELETON: fasterq-dump call:
    #   fasterq-dump $SRR --split-files --threads $THREADS \
    #     --temp $TMP_DIR --outdir $RAW_DIR >> $LOG_DIR/fasterq.log 2>&1

done < "$SRR_LIST"

echo "============================================" | tee -a "$MASTER_LOG"
echo "Phase 1 — Step 1 complete: $(date)"          | tee -a "$MASTER_LOG"
echo "============================================" | tee -a "$MASTER_LOG"
