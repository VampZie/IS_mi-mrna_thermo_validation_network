#!/usr/bin/env Rscript
# =============================================================================
# PHASE 3 | NETWORK DYNAMICS: BIOLOGICALLY-DRIVEN NETWORK DEFINITION (Human)
# =============================================================================
# PURPOSE:
#   Constructs miRNA–mRNA co-expression networks from validated thermodynamic
#   interactions for each disease-state contrast. Network edges are defined by
#   the 4-tool thermodynamic intersection (Phase 2: TargetScan ∩ RNAhybrid ∩
#   RNAplfold ∩ RNAcofold), ensuring only structurally stable interactions
#   are represented.
#
#   This module applies a biological directionality constraint:
#     - miRNA → mRNA edges are REPRESSIVE (negative regulation)
#     - Edge weight = absolute MFE (stronger binding = higher weight)
#     - Network states: Moderate | Severe | Stroke
#
#   GRAPH STRUCTURE:
#     Directed bipartite graph (igraph)
#     Nodes: miRNA sources + mRNA targets (labelled by HGNC symbol)
#     Edges: validated thermodynamic interactions per disease state
#
# INPUT : {state}_validated_targets.csv (per disease state)
#         ensg_to_symbol.txt            (HGNC annotation)
# OUTPUT: {state}_edges.csv, {state}_nodes.csv  (→ network_dynamics/human_results/)
# =============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(igraph)
})

cat("============================================\n")
cat("Phase 3 | Network Definition — Human\n")
cat("============================================\n\n")

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
BASE_DATA_PATH <- "../../02_target_prediction/"
MAPPING_FILE   <- "../../00_sequence_retrieval/ensg_to_symbol.txt"
OUTPUT_DIR     <- "../../../network_results/human/"

dir.create(OUTPUT_DIR, recursive = TRUE, showWarnings = FALSE)

# Disease states to construct networks for
STATES <- c("Moderate_vs_Control", "Severe_vs_Control", "Stroke_vs_Control")

# -----------------------------------------------------------------------------
# STEP 1: Load ENSG → symbol mapping
# -----------------------------------------------------------------------------
# SKELETON:
# id_map <- read.table(MAPPING_FILE, header=FALSE, sep="\t",
#                      col.names = c("ENSG","Symbol"))
# Used for node labelling in all downstream visualizations.
cat("[SKELETON] ENSG → symbol mapping loaded.\n\n")

# -----------------------------------------------------------------------------
# STEP 2: Build network per disease state
# -----------------------------------------------------------------------------
build_network <- function(state_name) {

  cat("Building network for:", state_name, "\n")

  # SKELETON:
  # 1. Load validated interaction table: {state}_validated_targets.csv
  # 2. Select columns: miRNA | mRNA_ENSG | MFE
  # 3. Map mRNA_ENSG → Symbol via id_map
  # 4. Build igraph directed graph:
  #    edges = miRNA → mRNA (repressive)
  #    edge weight = abs(MFE)
  # 5. Export edge list + node attribute table

  # graph_from_data_frame(edges, directed = TRUE)
  # V(g)$type  = "miRNA" | "mRNA"
  # V(g)$label = Symbol
  # E(g)$weight = abs(MFE)

  cat("  [SKELETON] Network construction for", state_name, "omitted.\n")

  # SKELETON: write.csv() for {state}_edges.csv and {state}_nodes.csv
}

# -----------------------------------------------------------------------------
# STEP 3: Run for all disease states
# -----------------------------------------------------------------------------
for (state in STATES) {
  build_network(state)
}

cat("\nPhase 3 | Human network definition complete.\n")
cat("Networks written to:", OUTPUT_DIR, "\n")
