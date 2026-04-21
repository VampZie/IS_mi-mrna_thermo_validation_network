#!/bin/bash
# =============================================================================
# PHASE 1 | STEP 3: GENOME ALIGNMENT (STAR)
# Dataset: GSE202518 (Human mRNA — Ischemic Stroke, RNA-seq)
# =============================================================================
# PURPOSE:
#   Aligns trimmed paired-end reads to the GRCh38 primary assembly using STAR
#   in 2-pass mode. Outputs coordinate-sorted BAM files for downstream
#   featureCounts quantification.
#
# REFERENCE: GENCODE v49 primary assembly annotation (GTF)
# TOOL: STAR 2.7.x (splice-aware aligner)
#
# USAGE:
#   bash 03_align_quantify.sh
# =============================================================================

set -euo pipefail

source ~/miniconda3/etc/profile.d/conda.sh
conda activate mrna

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
SRR_LIST="metadata/srr_list.txt"
TRIM_DIR="trimmed"
ALIGN_DIR="aligned"
GENOME_DIR="reference/star_index_grch38"   # Pre-built STAR index (GENCODE v49)
LOG_DIR="logs"
THREADS=$(nproc)

mkdir -p "$ALIGN_DIR" "$LOG_DIR"

MASTER_LOG="$LOG_DIR/align_master.log"

echo "============================================" | tee -a "$MASTER_LOG"
echo "Alignment started   : $(date)"               | tee -a "$MASTER_LOG"
echo "Genome index        : $GENOME_DIR"           | tee -a "$MASTER_LOG"
echo "Threads             : $THREADS"              | tee -a "$MASTER_LOG"
echo "============================================" | tee -a "$MASTER_LOG"

# -----------------------------------------------------------------------------
# ALIGNMENT LOOP
# -----------------------------------------------------------------------------
# SKELETON: STAR alignment parameters (applied but not shown):
#   --runMode alignReads
#   --readFilesCommand zcat         → read from .fastq.gz
#   --outSAMtype BAM SortedByCoordinate
#   --outSAMattributes NH HI AS NM
#   --quantMode GeneCounts          → simultaneous gene counting
#   --twopassMode Basic             → 2-pass for novel splice junction detection
# -----------------------------------------------------------------------------

while IFS= read -r SRR; do

    TRIM1="$TRIM_DIR/${SRR}_1.trimmed.fastq.gz"
    TRIM2="$TRIM_DIR/${SRR}_2.trimmed.fastq.gz"
    OUT_PREFIX="$ALIGN_DIR/${SRR}/"

    if [[ -f "${OUT_PREFIX}Aligned.sortedByCoord.out.bam" ]]; then
        echo "SKIP: $SRR — BAM already exists." | tee -a "$MASTER_LOG"
        continue
    fi

    if [[ ! -f "$TRIM1" ]]; then
        echo "SKIP: $SRR — trimmed FASTQ not found." | tee -a "$MASTER_LOG"
        continue
    fi

    mkdir -p "$OUT_PREFIX"
    echo "Aligning: $SRR" | tee -a "$MASTER_LOG"

    # SKELETON: STAR command omitted.
    # Output per sample:
    #   Aligned.sortedByCoord.out.bam
    #   ReadsPerGene.out.tab    (gene counts, strand-aware)
    #   Log.final.out           (alignment summary statistics)

    echo "Alignment complete: $SRR — $(date)" | tee -a "$MASTER_LOG"

done < "$SRR_LIST"

echo "============================================" | tee -a "$MASTER_LOG"
echo "All alignments complete: $(date)"            | tee -a "$MASTER_LOG"
echo "============================================" | tee -a "$MASTER_LOG"
