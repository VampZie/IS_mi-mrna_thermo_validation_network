#!/bin/bash
# =============================================================================
# PHASE 1 | miRNA PIPELINE: GENOME MAPPING (Bowtie / miRDeep2)
# Dataset: GSE202708 (Human miRNA-seq — Ischemic Stroke)
# =============================================================================
# PURPOSE:
#   Maps trimmed small-RNA reads to the human genome (GRCh38) using Bowtie
#   within the miRDeep2 framework.  Short, exact-match alignment is preferred
#   for mature miRNA loci profiling.
#
# TOOL : miRDeep2 mapper.pl + Bowtie
# INDEX: GRCh38 Bowtie index (pre-built from primary_assembly.fa)
# =============================================================================

set -euo pipefail

source ~/miniconda3/etc/profile.d/conda.sh
conda activate mirna

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
TRIM_DIR="trimmed"
MAP_DIR="mapped"
GENOME_INDEX="reference/grch38_bowtie_index/genome"
THREADS=$(nproc)

mkdir -p "$MAP_DIR"

echo "============================================"
echo "miRNA mapping started: $(date)"
echo "============================================"

# -----------------------------------------------------------------------------
# SKELETON: miRDeep2 mapper.pl parameters (applied but not shown):
#   -e          → input is FASTQ
#   -h          → parse to FASTA (required by miRDeep2)
#   -i          → discard reads with non-ACGT characters
#   -j          → discard reads < 18 nt
#   -l 18       → minimum read length
#   -m          → collapse reads (for quantifier step)
#   -p $GENOME_INDEX → Bowtie index
#   -s reads_collapsed.fa
#   -t reads_collapsed_vs_genome.arf
# -----------------------------------------------------------------------------

for TRIMMED in "$TRIM_DIR"/*_trimmed.fastq.gz; do

    SAMPLE=$(basename "$TRIMMED" _trimmed.fastq.gz)
    OUT_DIR="$MAP_DIR/$SAMPLE"
    mkdir -p "$OUT_DIR"

    if [[ -f "$OUT_DIR/reads_collapsed_vs_genome.arf" ]]; then
        echo "SKIP: $SAMPLE — already mapped."
        continue
    fi

    echo "Mapping: $SAMPLE"
    # SKELETON: mapper.pl call omitted.
    # Outputs:
    #   reads_collapsed.fa               → collapsed FASTA
    #   reads_collapsed_vs_genome.arf    → alignment result file (miRDeep2 format)

done

echo "Mapping complete: $(date)"
