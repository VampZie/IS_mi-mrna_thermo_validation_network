#!/usr/bin/env Rscript
# =============================================================================
# PHASE 3 | STEP 1A: HARMONIZATION (Human — mRNA/miRNA integration)
# =============================================================================
# PURPOSE:
#   Harmonizes the DE outputs from Phase 2 (miRNA edgeR + mRNA DESeq2) into
#   a unified, protein-coding-filtered gene set for each disease-state contrast.
#   This harmonized set forms the input for thermodynamic target prediction.
#
#   OPERATIONS:
#     1. Load DE results (UP + DOWN) for miRNA and mRNA per contrast
#     2. Filter mRNA set to protein-coding genes only
#     3. Normalize ENSG IDs (strip version suffix)
#     4. Cross-reference with protein-coding gene list (GENCODE biotype filter)
#     5. Export paired miRNA–mRNA tables per contrast group
#
# OUTPUT: harmonized/{GROUP}_mirna_targets.csv
#         harmonized/{GROUP}_mrna_background.csv
# =============================================================================

suppressPackageStartupMessages(library(dplyr))

cat("============================================\n")
cat("Phase 3 | Harmonization — Human\n")
cat("============================================\n\n")

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
DE_MIRNA_DIR <- "../phase2_differential_expression/human_mirna/"
DE_MRNA_DIR  <- "../phase2_differential_expression/human_mrna/"
REF_DIR      <- "../reference/"
OUT_DIR      <- "harmonized/human/"

dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

# Contrasts to process
CONTRASTS <- c("Moderate_vs_Control", "Severe_vs_Control",
               "Severe_vs_Moderate",  "Stroke_vs_Control")

# -----------------------------------------------------------------------------
# STEP 1: Load protein-coding gene reference
# -----------------------------------------------------------------------------
# SKELETON: protein_coding genes extracted from GENCODE v49 GTF via:
#   awk '$3 == "gene" && /gene_type "protein_coding"/' → gene_id list
# Used to filter mRNA DE results to protein-coding targets only.

cat("[SKELETON] Protein-coding gene list loading omitted.\n")

# -----------------------------------------------------------------------------
# STEP 2: Per-contrast harmonization loop
# -----------------------------------------------------------------------------
for (contrast in CONTRASTS) {

  cat("Processing contrast:", contrast, "\n")

  # SKELETON:
  # 1. Load miRNA UP + DOWN CSVs from Phase 2 edgeR output
  # 2. Load mRNA SIG_RAW CSV from Phase 2 DESeq2 output
  # 3. Strip ENSG version: sub("\\..+", "", gene_id)
  # 4. Filter mRNA to protein_coding biotype
  # 5. Export harmonized pair table

  cat("  [SKELETON] Harmonization steps for", contrast, "omitted.\n")
}

cat("\nPhase 3 | Human harmonization complete.\n")
