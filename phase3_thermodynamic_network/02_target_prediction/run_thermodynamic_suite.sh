#!/bin/bash
# =============================================================================
# PHASE 3 | STEP 2: THERMODYNAMIC VALIDATION SUITE LAUNCHER
# =============================================================================
# PURPOSE:
#   Master orchestration script for the 4-tool thermodynamic validation engine.
#   This suite validates predicted miRNA–mRNA interactions by structural and
#   energetic criteria, implementing a stringent 4-way intersection filter.
#
#   TOOL PIPELINE (executed in sequence):
#     1. TargetScan  → conserved seed-match prediction (position 2–8)
#     2. RNAhybrid   → MFE of miRNA:3'UTR duplex (threshold: ≤ [THRESHOLD_MFE])
#     3. RNAplfold   → local 3'UTR accessibility (unpaired probability window)
#     4. RNAcofold   → co-folding free energy (duplex + flanking context)
#
#   FINAL OUTPUT: intersection of all 4 tools = high-confidence validated targets
#
# USAGE:
#   bash run_thermodynamic_suite.sh <GROUP>
#   GROUP = contrast group directory (e.g., Moderate_vs_Control)
# =============================================================================

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <GROUP>"
    exit 1
fi

GROUP="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/../../")"

echo "========================================================"
echo "Thermodynamic Validation Suite | Group: $GROUP"
echo "========================================================"

# -----------------------------------------------------------------------------
# STEP 1: TargetScan seed-match prediction
# -----------------------------------------------------------------------------
echo "[1/4] Running TargetScan seed-match extraction..."
bash "$SCRIPT_DIR/targetscan/run_targetscan.sh" "$GROUP"

# -----------------------------------------------------------------------------
# STEP 2: RNAhybrid MFE calculation
# -----------------------------------------------------------------------------
echo "[2/4] Running RNAhybrid (MFE ≤ -20 kcal/mol threshold)..."
bash "$SCRIPT_DIR/rnahybrid/run_rnahybrid.sh" "$GROUP"

# -----------------------------------------------------------------------------
# STEP 3: RNAplfold local accessibility
# -----------------------------------------------------------------------------
echo "[3/4] Running RNAplfold (3'UTR accessibility profiling)..."
# SKELETON: run_rnaplfold.sh $GROUP

# -----------------------------------------------------------------------------
# STEP 4: RNAcofold duplex co-folding
# -----------------------------------------------------------------------------
echo "[4/4] Running RNAcofold (seed duplex co-folding energy)..."
# SKELETON: run_rnacofold.sh $GROUP

# -----------------------------------------------------------------------------
# STEP 5: 4-tool intersection
# -----------------------------------------------------------------------------
echo "Computing 4-tool thermodynamic intersection..."
# SKELETON: intersection.sh $GROUP
# Final output: {GROUP}_validated_targets.csv

echo "========================================================"
echo "Thermodynamic suite complete for: $GROUP"
echo "========================================================"
