#!/usr/bin/env Rscript
# =============================================================================
# PHASE 3 | NETWORK DYNAMICS: FUNCTIONAL ENRICHMENT MECHANISMS (Human)
# =============================================================================
# PURPOSE:
#   Performs functional enrichment analysis on target mRNA sets from each
#   network state to characterize the biological mechanisms dysregulated
#   during ischemic stroke progression.
#
#   ENRICHMENT DATABASES:
#     - GO Biological Process (BP)    → cellular mechanism annotations
#     - KEGG Pathways                 → disease pathway mapping
#     - Reactome                      → signalling cascade context
#
#   ANALYSIS STRATEGY:
#     For each disease state → extract target mRNA gene symbols
#     Run ORA (Over-Representation Analysis) via clusterProfiler
#     Focus on neurological, inflammatory, and apoptotic terms
#
#   KEY PATHWAYS EXPECTED:
#     Stroke state: Apoptosis (GO:0006915), Neuroinflammation (KEGG hsa05418),
#     HIF-1 signaling, MAPK cascade, oxidative stress response
#
# INPUT : network_results/human/{state}_nodes.csv (mRNA nodes only)
# OUTPUT: enrichment/ → {state}_GO_BP.png + {state}_KEGG.png + enrichment_table.csv
# =============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(clusterProfiler)
  library(org.Hs.eg.db)
  library(enrichplot)
  library(ggplot2)
})

cat("============================================\n")
cat("Phase 3 | Functional Enrichment — Human\n")
cat("============================================\n\n")

RES_DIR <- "../../../network_results/human/"
OUT_DIR <- file.path(RES_DIR, "enrichment/")
dir.create(OUT_DIR, recursive = TRUE, showWarnings = FALSE)

STATES  <- c("Moderate_vs_Control", "Severe_vs_Control", "Stroke_vs_Control")

# -----------------------------------------------------------------------------
# STEP 1: Extract mRNA gene lists per state
# -----------------------------------------------------------------------------
# SKELETON: Load {state}_nodes.csv, filter type == "mRNA", extract Symbol column

cat("[SKELETON] mRNA node extraction omitted.\n")

# -----------------------------------------------------------------------------
# STEP 2: GO Biological Process enrichment
# -----------------------------------------------------------------------------
run_go_enrichment <- function(gene_symbols, state_name) {
  # SKELETON:
  # gene_ids <- bitr(gene_symbols, fromType="SYMBOL", toType="ENTREZID",
  #                  OrgDb = org.Hs.eg.db)
  # ego <- enrichGO(gene   = gene_ids$ENTREZID,
  #                 OrgDb  = org.Hs.eg.db,
  #                 ont    = "BP",
  #                 pAdjustMethod = "BH",
  #                 pvalueCutoff  = 0.05,
  #                 qvalueCutoff  = 0.2)
  # dotplot(ego) + ggtitle(paste("GO-BP:", state_name))
  # ggsave(...)
  message(paste("[SKELETON] GO-BP enrichment for", state_name, "omitted."))
}

# -----------------------------------------------------------------------------
# STEP 3: KEGG pathway enrichment
# -----------------------------------------------------------------------------
run_kegg_enrichment <- function(gene_symbols, state_name) {
  # SKELETON:
  # ekegg <- enrichKEGG(gene = gene_ids$ENTREZID, organism = "hsa",
  #                     pvalueCutoff = 0.05)
  message(paste("[SKELETON] KEGG enrichment for", state_name, "omitted."))
}

# -----------------------------------------------------------------------------
# STEP 4: Run for all states
# -----------------------------------------------------------------------------
for (state in STATES) {
  cat("Enrichment analysis:", state, "\n")
  run_go_enrichment(character(), state)
  run_kegg_enrichment(character(), state)
}

cat("\nPhase 3 | Functional enrichment complete → ", OUT_DIR, "\n")
