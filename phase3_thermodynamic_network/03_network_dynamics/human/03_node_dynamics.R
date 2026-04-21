#!/usr/bin/env Rscript
# =============================================================================
# PHASE 3 | NETWORK DYNAMICS: NODE-LEVEL REWIRING ANALYSIS (Human)
# =============================================================================
# PURPOSE:
#   Quantifies how individual miRNA and mRNA nodes change their connectivity
#   (degree) across disease progression. Classifies each node into one of
#   five rewiring categories based on degree trajectory.
#
#   REWIRING TAXONOMY:
#     Lost      → present in Moderate, absent in Stroke  (silenced regulators)
#     Gained    → absent in Moderate, present in Stroke  (emergency recruitments)
#     Expansion → degree increases Moderate → Stroke     (hub amplification)
#     Reduction → degree decreases Moderate → Stroke     (hub attrition)
#     Stable    → degree unchanged across all states     (constitutive regulation)
#
#   VISUALIZATION:
#     Rewiring scatter (degree_Moderate vs degree_Stroke):
#       - Diagonal = no change line
#       - Points coloured by rewiring category
#       - All nodes labelled (ggrepel, max.overlaps = Inf)
#       - Separate panels: all nodes | miRNA only | mRNA only
#
#   KEY BIOLOGICAL INSIGHT:
#     Hub miRNAs showing "Expansion" in Stroke = potential master regulators
#     of ischemic injury (candidates for therapeutic targeting).
#
# INPUT : network_results/human/{state}_edges.csv (Moderate + Stroke required)
# OUTPUT: node_dynamics/ → Viz_B_Rewiring_ALL_LABELED.png
#                          Viz_B_miRNA_ALL_LABELED.png
#                          Viz_B_mRNA_ALL_LABELED.png
#                          All_Labeled_Nodes.csv
# =============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(igraph)
  library(viridis)
  library(ggrepel)
})

cat("============================================\n")
cat("Phase 3 | Node Rewiring Analysis — Human\n")
cat("============================================\n\n")

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
RES_DIR <- "../../../network_results/human/"
OUT_DIR <- file.path(RES_DIR, "node_dynamics/")
dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

MAPPING_FILE <- "../../00_sequence_retrieval/ensg_to_symbol.txt"

# Rewiring colour palette
REWIRING_COLORS <- c(
  "Lost"      = "#e41a1c",
  "Gained"    = "#377eb8",
  "Expansion" = "#4daf4a",
  "Reduction" = "#ff7f00",
  "Stable"    = "#999999"
)

# -----------------------------------------------------------------------------
# STEP 1: Compute per-state degree for each node
# -----------------------------------------------------------------------------
calc_degrees <- function(edge_file, state_name) {
  # SKELETON:
  # edges <- read.csv(edge_file)
  # g     <- graph_from_data_frame(edges, directed = TRUE)
  # data.frame(id = V(g)$name, degree = igraph::degree(g),
  #            type = ifelse(grepl("miR|let", V(g)$name), "miRNA", "mRNA"),
  #            state = state_name)
  message(paste("[SKELETON] Degree calculation for", state_name, "omitted."))
  data.frame(id=character(), degree=integer(), type=character(), state=character())
}

# -----------------------------------------------------------------------------
# STEP 2: Build master node table + classify rewiring
# -----------------------------------------------------------------------------
# SKELETON:
# master_nodes <- full_join(deg_Moderate, deg_Stroke, by="id") %>%
#   mutate(
#     gain = degree_Stroke - degree_Moderate,
#     Rewiring_Type = case_when(
#       degree_Moderate >0 & degree_Stroke ==0 ~ "Lost",
#       degree_Moderate==0 & degree_Stroke  >0 ~ "Gained",
#       degree_Stroke > degree_Moderate         ~ "Expansion",
#       degree_Stroke < degree_Moderate         ~ "Reduction",
#       TRUE                                    ~ "Stable"
#     )
#   )

cat("[SKELETON] Master node table construction omitted.\n")

# -----------------------------------------------------------------------------
# STEP 3: Rewiring scatter — ALL nodes labelled
# -----------------------------------------------------------------------------
# SKELETON:
# ggplot(master_nodes, aes(x=degree_Moderate, y=degree_Stroke, color=Rewiring_Type)) +
#   geom_abline(slope=1, intercept=0, linetype="dashed") +
#   geom_point(alpha=0.7, size=4) +
#   geom_text_repel(aes(label=Symbol), max.overlaps=Inf, force=3, seed=42) +
#   scale_color_manual(values = REWIRING_COLORS) +
#   theme_minimal(base_size=14)
#
# ggsave("Viz_B_Rewiring_ALL_LABELED.png", width=20, height=16, dpi=600)

cat("[SKELETON] Rewiring visualizations (ALL / miRNA / mRNA panels) omitted.\n")

# -----------------------------------------------------------------------------
# STEP 4: Export labelled node tables
# -----------------------------------------------------------------------------
# SKELETON: write.csv for All_Labeled_Nodes.csv, _miRNAs.csv, _mRNAs.csv

cat("[SKELETON] Node table CSV exports omitted.\n\n")
cat("Phase 3 | Node rewiring analysis complete.\n")
cat("Outputs → ", OUT_DIR, "\n")
