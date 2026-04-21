#!/usr/bin/env Rscript
# =============================================================================
# PHASE 3 | STEP 1B: HARMONIZATION (Rat — mRNA/miRNA integration)
# =============================================================================
# PURPOSE:
#   Harmonizes DE outputs from Phase 2 (rat miRNA limma + rat mRNA limma)
#   into a unified gene set for each ischemic disease-state contrast.
#
#   SPECIES NOTE:
#     Rat data uses Ensembl ENSRNOG IDs (mRNA) and rno-miR-* (miRNA).
#     Cross-mapping uses rat_geneid_to_symbol.txt for ID standardization.
#
#   CONTRASTS:
#     Acute_vs_Control | Subacute_vs_Control | Subacute_vs_Acute | Stroke_vs_Control
#
# OUTPUT: harmonized/rat/{GROUP}_mirna_targets.csv
#         harmonized/rat/{GROUP}_mrna_background.csv
# =============================================================================

suppressPackageStartupMessages(library(dplyr))

cat("============================================\n")
cat("Phase 3 | Harmonization — Rat\n")
cat("============================================\n\n")

DE_MIRNA_DIR <- "../phase2_differential_expression/rat_mirna/"
DE_MRNA_DIR  <- "../phase2_differential_expression/rat_mrna/"
REF_DIR      <- "../reference/"
OUT_DIR      <- "harmonized/rat/"

dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

RAT_CONTRASTS <- c("Acute_vs_Control", "Subacute_vs_Control",
                   "Subacute_vs_Acute", "Stroke_vs_Control")

# -----------------------------------------------------------------------------
# STEP 1: Load rat gene ID → symbol lookup
# -----------------------------------------------------------------------------
# SKELETON: rat_map <- read.table("rat_geneid_to_symbol.txt", sep="\t")
# Provides ENSRNOG → RGD Symbol conversion for rat mRNA annotations.
cat("[SKELETON] Rat gene ID → symbol map loading omitted.\n\n")

# -----------------------------------------------------------------------------
# STEP 2: Per-contrast harmonization
# -----------------------------------------------------------------------------
for (contrast in RAT_CONTRASTS) {

  cat("Processing rat contrast:", contrast, "\n")

  # SKELETON:
  # 1. Load Rat_{contrast}_UP.csv + _DOWN.csv from Phase 2 limma output
  # 2. Load de_{contrast}_UP.csv + _DOWN.csv from rat mRNA limma output
  # 3. Map ENSRNOG → gene symbol via rat_map
  # 4. Export harmonized pair table

  cat("  [SKELETON] Rat harmonization for", contrast, "omitted.\n")
}

cat("\nPhase 3 | Rat harmonization complete.\n")
