#!/bin/bash
# =============================================================================
# PHASE 3 | TARGET PREDICTION: RNAhybrid WRAPPER
# Tool: RNAhybrid (Rehmsmeier et al., 2004)
# =============================================================================
# PURPOSE:
#   Computes Minimum Free Energy (MFE) of miRNA:3'UTR duplexes using
#   RNAhybrid. Operates on pre-extracted 3'UTR FASTA sequences per contrast
#   group. Output is parsed and filtered by energy threshold.
#
#   ENERGY THRESHOLD: MFE ≤ −20 kcal/mol
#   Rationale: empirically calibrated cutoff for stroke-context miRNA binding.
#   Values above -20 are considered thermodynamically insufficient for
#   stable repression complex formation.
#
# PIPELINE:
#   hybrid.sh → parse_output.sh → filter_by_energy.py
#
# USAGE:
#   bash run_rnahybrid.sh <GROUP>
# =============================================================================

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <GROUP>"
    exit 1
fi

GROUP="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/../../../")"

GROUP_DIR="$PROJECT_ROOT/target_prediction/$GROUP"
ENERGY_DIR="$GROUP_DIR/energy"
OUTPUT_DIR="$ENERGY_DIR/rnahybrid"

MIRNA_FASTA="$GROUP_DIR/${GROUP}_selected_miRNAs.fa"
UTR_FASTA="$ENERGY_DIR/${GROUP}_full_3utr.fa"

mkdir -p "$OUTPUT_DIR"

# -----------------------------------------------------------------------------
# PRECONDITIONS
# -----------------------------------------------------------------------------
for f in "$MIRNA_FASTA" "$UTR_FASTA"; do
    if [[ ! -f "$f" ]]; then
        echo "ERROR: Required file missing: $f"
        echo "Ensure 3'UTR extraction completed (extract_3utr.sh) before running."
        exit 1
    fi
done

echo "----------------------------------------"
echo "RNAhybrid pipeline: $GROUP"
echo "miRNA FASTA : $MIRNA_FASTA"
echo "3'UTR FASTA : $UTR_FASTA"
echo "Output dir  : $OUTPUT_DIR"
echo "----------------------------------------"

cd "$OUTPUT_DIR"

# -----------------------------------------------------------------------------
# STEP 1 — Run RNAhybrid
# -----------------------------------------------------------------------------
# SKELETON: RNAhybrid parameters (not shown for IP protection):
#   -s 3utr_human      → target site model
#   -e -20             → energy cutoff filter
#   -p 0.05            → p-value threshold
#   -m 50000           → max target length
#   Runs all miRNA × all 3'UTR pairs in FASTA files

echo "[1/3] Running RNAhybrid..."
# SKELETON: bash run_rnahybrid_core.sh "$GROUP" "$MIRNA_FASTA" "$UTR_FASTA"

# -----------------------------------------------------------------------------
# STEP 2 — Parse raw RNAhybrid output
# -----------------------------------------------------------------------------
# SKELETON: Converts RNAhybrid's block-format output to structured CSV:
#   Columns: miRNA_Name | Transcript_ID | MFE | Position | Target_Seq | miRNA_Seq

echo "[2/3] Parsing RNAhybrid output..."
# SKELETON: bash parse_output.sh "$GROUP"

# -----------------------------------------------------------------------------
# STEP 3 — Energy filter (Python)
# -----------------------------------------------------------------------------
echo "[3/3] Applying MFE threshold (≤ −20 kcal/mol)..."

source ~/miniconda3/etc/profile.d/conda.sh
conda activate py

python filter_by_energy.py "$GROUP"

echo "----------------------------------------"
echo "RNAhybrid complete for: $GROUP"
echo "Outputs: ${GROUP}_RNAhybrid_MFE_leq_-20.csv"
echo "         ${GROUP}_best_sites_MFE_leq_-20.csv"
echo "----------------------------------------"
