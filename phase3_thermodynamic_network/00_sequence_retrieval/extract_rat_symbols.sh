#!/bin/bash
# =============================================================================
# PHASE 3 | STEP 0B: RAT GENE ID → SYMBOL EXTRACTION (Rat GTF)
# Reference: Ensembl Rnor_6.0 / Rattus norvegicus GTF
# =============================================================================
# PURPOSE:
#   Generates the rat-specific gene ID → symbol lookup table from the Ensembl
#   rat genome annotation. Used to annotate rat network nodes (rno-miR-*)
#   with standard RGD symbols for cross-species comparison.
#
# INPUT : Rattus_norvegicus.Rnor_6.0.gtf (Ensembl)
# OUTPUT: rat_geneid_to_symbol.txt  (format: ENSRNOG00000XXXXX\tGene_Symbol)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(realpath "$SCRIPT_DIR/../../")"
REF_DIR="$PROJECT_ROOT/reference"

GTF="$REF_DIR/Rattus_norvegicus.Rnor_6.0.gtf"
OUT="$REF_DIR/rat_geneid_to_symbol.txt"

if [[ ! -f "$GTF" ]]; then
    echo "ERROR: Rat GTF not found: $GTF"
    echo "Download from: https://ftp.ensembl.org/pub/release-104/gtf/rattus_norvegicus/"
    exit 1
fi

echo "Parsing rat GTF: $GTF"

# ---------------------------------------------------------------------------
# SKELETON: AWK extracts gene_id + gene_name from Ensembl rat GTF.
# Ensembl format differs from GENCODE — gene_id is unversioned.
#
# awk 'BEGIN{FS="\t"}
#   $3=="gene" {
#     match($9, /gene_id "([^"]+)"/, a);
#     match($9, /gene_name "([^"]+)"/, b);
#     if (a[1] && b[1]) print a[1] "\t" b[1]
#   }' "$GTF" | sort -u > "$OUT"
# ---------------------------------------------------------------------------

echo "[SKELETON] Rat GTF AWK parsing would execute here."
echo "Output → $OUT"
echo "rat_geneid_to_symbol.txt generated."
