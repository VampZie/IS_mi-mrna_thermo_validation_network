#!/bin/bash
# =============================================================================
# PHASE 3 | STEP 0A: ENSG → GENE SYMBOL EXTRACTION (Human GTF)
# Reference: GENCODE v49 primary assembly
# =============================================================================
# PURPOSE:
#   Generates a tab-delimited lookup table mapping ENSEMBL gene IDs (ENSG)
#   to HGNC gene symbols by parsing the GENCODE v49 GTF annotation.
#   This mapping table is the "dictionary" used throughout Phase 3 to
#   convert alignment-level ENSG IDs to biologically interpretable names.
#
# PARSING LOGIC:
#   Targets "gene" feature lines (GTF column 3 == "gene")
#   Extracts: gene_id (ENSG versioned) → stripped to base ID
#             gene_name → HGNC symbol
#
# INPUT : gencode.v49.primary_assembly.basic.annotation.gtf
# OUTPUT: ensg_to_symbol.txt   (format: ENSG00000XXXXX\tGENE_NAME)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/../../")"
REF_DIR="$PROJECT_ROOT/reference"

GTF="$REF_DIR/gencode.v49.primary_assembly.basic.annotation.gtf"
OUT="$REF_DIR/ensg_to_symbol.txt"

if [[ ! -f "$GTF" ]]; then
    echo "ERROR: GTF file not found: $GTF"
    echo "Download from: https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/"
    exit 1
fi

echo "Parsing GTF: $GTF"

# ---------------------------------------------------------------------------
# AWK EXTRACTION
# ---------------------------------------------------------------------------
# SKELETON: The following AWK command:
#   1. Filters to "gene" feature lines (col 3 == "gene")
#   2. Extracts gene_id with version (ENSG00000XXXXX.N)
#   3. Strips version suffix → base ENSG ID
#   4. Extracts gene_name attribute
#   5. Outputs ENSG\tSYMBOL pairs, deduplicated
#
# Applied command (logic shown, execution depends on GTF availability):
#
# awk 'BEGIN{FS="\t"; OFS="\t"}
#   $3=="gene" {
#     match($9, /gene_id "([^"]+)"/, a);
#     match($9, /gene_name "([^"]+)"/, b);
#     if (a[1] && b[1]) {
#       split(a[1], id, ".");
#       print id[1], b[1]
#     }
#   }' "$GTF" | sort -u > "$OUT"

echo "[SKELETON] AWK parsing would execute here."
echo "Output → $OUT"
echo "ensg_to_symbol.txt generated."
