#!/bin/bash
# =============================================================================
# PHASE 3 | TARGET PREDICTION: TargetScan SEED-MATCH EXTRACTION
# Tool: TargetScan (Lewis et al.) — conserved site prediction
# =============================================================================
# PURPOSE:
#   Extracts conserved miRNA seed-match predictions from the TargetScan
#   database backbone for human targets. Seed matches are filtered to retain
#   only 7mer-m8 and 8mer site types (canonical seed positions 2–8).
#
#   SITE TYPE HIERARCHY (most to least conservative):
#     8mer    → position 2–8 + A at position 1 (strongest)
#     7mer-m8 → position 2–8 (standard canonical)
#     7mer-A1 → position 2–7 + A1 (weaker, retained for intersection only)
#
#   FILTERING:
#     - Retains only sites present in TargetScan backbone for query miRNAs
#     - Cross-references with DE miRNA list from Phase 2
#     - Outputs per-group: {GROUP}_targetscan_filtered.csv
#
# USAGE:
#   bash run_targetscan.sh <GROUP>
# =============================================================================

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <GROUP>"
    exit 1
fi

GROUP="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/../../../")"

TARGETSCAN_DB="$PROJECT_ROOT/reference/TargetScan_backbone_hsa.txt"
MIRNA_LIST="$PROJECT_ROOT/target_prediction/$GROUP/${GROUP}_selected_miRNAs.txt"
OUT_DIR="$PROJECT_ROOT/target_prediction/$GROUP/targetscan"
OUT_FILE="$OUT_DIR/${GROUP}_targetscan_filtered.csv"

mkdir -p "$OUT_DIR"

echo "----------------------------------------"
echo "TargetScan extraction | Group: $GROUP"
echo "----------------------------------------"

# Validate inputs
if [[ ! -f "$TARGETSCAN_DB" ]]; then
    echo "ERROR: TargetScan backbone not found: $TARGETSCAN_DB"
    echo "Download from: https://www.targetscan.org/cgi-bin/targetscan/data_download.vert80.cgi"
    exit 1
fi

# -----------------------------------------------------------------------------
# SKELETON: TargetScan filtering logic
#
# Step 1: Load DE miRNA list (from Phase 2 edgeR output)
# Step 2: Grep TargetScan backbone for matching miRNA family IDs
# Step 3: Filter to site types: 8mer | 7mer-m8 | 7mer-A1
# Step 4: Cross-reference with 3'UTR gene list from Phase 3 harmonization
# Step 5: Output filtered interaction table
#
# Key column in TargetScan backbone:
#   miRNA_family_ID | Gene_ID | Gene_Symbol | Transcript_ID | Site_Type | ...
# -----------------------------------------------------------------------------

echo "[SKELETON] TargetScan extraction logic omitted."
echo "Output would be written to: $OUT_FILE"
echo "TargetScan step complete for: $GROUP"
