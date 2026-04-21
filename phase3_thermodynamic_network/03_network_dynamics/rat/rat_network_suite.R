#!/usr/bin/env Rscript
# =============================================================================
# PHASE 3 | NETWORK DYNAMICS: RAT NETWORK SUITE (Mirrors Human Pipeline)
# Dataset: GSE46266 (miRNA) + GSE46267 (mRNA) — Rattus norvegicus
# =============================================================================
# PURPOSE:
#   Constructs and analyzes miRNA–mRNA regulatory networks for the rat ischemic
#   stroke model. Mirrors the human pipeline (01–07) for cross-species
#   conservation validation.
#
#   RAT-SPECIFIC CONSIDERATIONS:
#     - rno-miR-* prefix (Rattus norvegicus miRNA identifiers)
#     - Ensembl ENSRNOG IDs → RGD gene symbols via rat_geneid_to_symbol.txt
#     - Rat disease states: Control | Acute | Subacute (vs human: Control | Moderate | Severe)
#     - RNAhybrid run against rn6 3'UTR sequences
#
#   CROSS-SPECIES COMPARISON:
#     After running this module, compare:
#       Human hub miRNAs ↔ Rat hub miRNAs (conserved hubs = high-confidence targets)
#       Human thermo-shifts ↔ Rat thermo-shifts (conserved flips = mechanism-level evidence)
#
# STATES: Acute_vs_Control | Subacute_vs_Control | Stroke_vs_Control
# =============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(igraph)
  library(ggrepel)
  library(pheatmap)
  library(viridis)
  library(clusterProfiler)
  library(org.Rn.eg.db)   # rat annotation database
})

cat("============================================\n")
cat("Phase 3 | Rat Network Suite\n")
cat("Species: Rattus norvegicus\n")
cat("============================================\n\n")

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
RES_DIR      <- "../../../network_results/rat/"
MAPPING_FILE <- "../../00_sequence_retrieval/rat_geneid_to_symbol.txt"

dir.create(RES_DIR, recursive = TRUE, showWarnings = FALSE)

RAT_STATES <- c("Acute_vs_Control", "Subacute_vs_Control", "Stroke_vs_Control")

# Rewiring colours (same palette as human for visual consistency)
REWIRING_COLORS <- c(
  "Lost"      = "#e41a1c",
  "Gained"    = "#377eb8",
  "Expansion" = "#4daf4a",
  "Reduction" = "#ff7f00",
  "Stable"    = "#999999"
)

# -----------------------------------------------------------------------------
# MODULE 1: Network Definition (rat)
# -----------------------------------------------------------------------------
# SKELETON: Same logic as human/01_define_network.R but using:
#   - rno- prefixed miRNA nodes
#   - rat_geneid_to_symbol.txt for mRNA node annotation
#   - rat 3'UTR extraction (rn6 reference)

cat("[SKELETON] Rat network construction omitted.\n")

# -----------------------------------------------------------------------------
# MODULE 2: Progression comparison (rat)
# -----------------------------------------------------------------------------
# SKELETON: Jaccard similarity + density progression (Acute → Subacute → Stroke)
# Cross-reference with human progression for conservation analysis.

cat("[SKELETON] Rat progression comparison omitted.\n")

# -----------------------------------------------------------------------------
# MODULE 3: Node dynamics (rat)
# -----------------------------------------------------------------------------
# SKELETON: Rewiring taxonomy applied to rat nodes.
# Key output: rat miRNAs showing Expansion in Stroke state.

cat("[SKELETON] Rat node dynamics omitted.\n")

# -----------------------------------------------------------------------------
# MODULE 4: Hub quantification (rat)
# -----------------------------------------------------------------------------
# SKELETON: Multi-metric centrality (degree + betweenness + eigenvector)
# Conserved with human hubs → mechanistic validation.

cat("[SKELETON] Rat hub quantification omitted.\n")

# -----------------------------------------------------------------------------
# MODULE 5: Edge strength comparison (rat)
# -----------------------------------------------------------------------------
cat("[SKELETON] Rat edge strength comparison omitted.\n")

# -----------------------------------------------------------------------------
# MODULE 6: Thermodynamic shift (rat)
# -----------------------------------------------------------------------------
# SKELETON: ΔΔG(Acute→Stroke) per rat miRNA.
# Compare with human ΔΔG for cross-species thermodynamic conservation.

cat("[SKELETON] Rat thermodynamic shift analysis omitted.\n")

# -----------------------------------------------------------------------------
# MODULE 7: Functional enrichment (rat)
# -----------------------------------------------------------------------------
# SKELETON: Same as human but using org.Rn.eg.db + KEGG organism="rno"

cat("[SKELETON] Rat functional enrichment (org.Rn.eg.db) omitted.\n\n")

cat("Phase 3 | Rat network suite complete.\n")
cat("Results → ", RES_DIR, "\n")
