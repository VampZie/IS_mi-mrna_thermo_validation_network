#!/bin/bash
# =============================================================================
# PHASE 1 | STEP 4: GENE-LEVEL QUANTIFICATION (featureCounts)
# Dataset: GSE202518 (Human mRNA — Ischemic Stroke, RNA-seq)
# =============================================================================
# PURPOSE:
#   Aggregates all sample BAM files into a single gene-level count matrix
#   using featureCounts (Subread package). Stranded mode is determined by
#   prior strandedness validation (see 01_strand_test.sh).
#
# KEY DECISION: --strandSpecificity 2 (reverse-strand protocol confirmed
#   via RSeQC infer_experiment.py on pilot samples)
#
# TOOL: featureCounts (Subread ≥ 2.0)
# REF : GENCODE v49 primary_assembly.basic.annotation.gtf
# =============================================================================

set -euo pipefail

source ~/miniconda3/etc/profile.d/conda.sh
conda activate mrna

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
ALIGN_DIR="aligned"
GTF="reference/gencode.v49.primary_assembly.basic.annotation.gtf"
OUT_FILE="gene_counts_stranded.txt"
LOG_DIR="logs"
THREADS=$(nproc)

mkdir -p "$LOG_DIR"

# Collect all sorted BAMs
BAM_FILES=$(find "$ALIGN_DIR" -name "Aligned.sortedByCoord.out.bam" | sort | tr '\n' ' ')

echo "BAM files found: $(echo "$BAM_FILES" | wc -w)"

# -----------------------------------------------------------------------------
# FEATURECOUNTS CALL
# -----------------------------------------------------------------------------
# SKELETON: featureCounts parameters (applied but not shown):
#   -T $THREADS         → parallel threads
#   -p                 → paired-end mode
#   -s 2               → reverse-stranded (validated by RSeQC)
#   -t exon            → count at exon level
#   -g gene_id         → aggregate to gene_id
#   --byReadGroup      → per read-group counting for QC
#   -a $GTF            → GENCODE v49 annotation
#   -o $OUT_FILE       → output count matrix
#
# Output columns: Geneid | Chr | Start | End | Strand | Length | SRR...
# SKELETON: command execution omitted. See 05_build_count_matrix.R to
# convert featureCounts output → clean DESeq2-ready matrix.
# -----------------------------------------------------------------------------

echo "featureCounts quantification: [SKELETON — execution omitted]"
echo "Output would be written to: $OUT_FILE"
echo "Next step: Rscript 05_build_count_matrix.R"
