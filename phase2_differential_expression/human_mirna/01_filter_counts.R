#!/usr/bin/env Rscript
# =============================================================================
# PHASE 2 | HUMAN miRNA DE: COUNT FILTERING (edgeR)
# Dataset: GSE202708 — Human miRNA-seq, Ischemic Stroke Progression
# =============================================================================
# PURPOSE:
#   Applies a two-stage differential
#   expression analysis.
#
#   Stage 1 — Raw count filter : removes miRNAs with < [MIN_COUNTS] in < [MIN_SAMPLES]
#   Stage 2 — CPM filter       : removes miRNAs with CPM < [MIN_CPM] in < [MIN_SAMPLES]
#
#   Rationale: miRNA-seq libraries have higher sparsity than mRNA-seq.
#   Dual-filter improves specificity of edgeR dispersion estimates.
#
# INPUT : miRNA_count_matrix.csv         (Phase 1 output)
# OUTPUT: miRNA_count_matrix_filtered.csv
# =============================================================================

suppressPackageStartupMessages(library(edgeR))

cat("============================================\n")
cat("Phase 2 | Human miRNA: Strict count filter\n")
cat("============================================\n\n")

# -----------------------------------------------------------------------------
# STEP 1: Load raw count matrix
# -----------------------------------------------------------------------------
expr_raw <- as.matrix(
  read.csv("miRNA_count_matrix.csv", row.names = 1, check.names = FALSE)
)

cat("Raw matrix:", nrow(expr_raw), "miRNAs ×", ncol(expr_raw), "samples\n")

# -----------------------------------------------------------------------------
# STEP 2: Retain human miRNAs only (hsa- prefix filter)
# -----------------------------------------------------------------------------
# SKELETON: Species-specific filter — keeps only hsa-miR-* and hsa-let-* entries.
# This removes cross-mapped rno- / mmu- entries introduced during alignment.
expr_raw <- expr_raw[grepl("^hsa-", rownames(expr_raw)), ]
cat("After hsa- filter:", nrow(expr_raw), "miRNAs\n")

# -----------------------------------------------------------------------------
# STEP 3: Create DGEList
# -----------------------------------------------------------------------------
dge <- DGEList(counts = expr_raw)

# -----------------------------------------------------------------------------
# STEP 4: Stage 1 — Raw count threshold
# -----------------------------------------------------------------------------
# SKELETON: keep_counts <- rowSums(dge$counts >= [THRESHOLD_COUNT]) >= [THRESHOLD_SAMPLES]
# Threshold: ≥[THRESHOLD_COUNT] raw counts in ≥[THRESHOLD_SAMPLES] samples
keep_counts <- rep(TRUE, nrow(dge))  # SKELETON placeholder
dge <- dge[keep_counts, , keep.lib.sizes = FALSE]
cat("After count filter:", nrow(dge), "miRNAs\n")

# -----------------------------------------------------------------------------
# STEP 5: Stage 2 — CPM detectability threshold
# -----------------------------------------------------------------------------
# SKELETON: keep_cpm <- rowSums(cpm(dge) > [THRESHOLD_CPM]) >= [THRESHOLD_SAMPLES]
# Threshold: CPM > [THRESHOLD_CPM] in ≥[THRESHOLD_SAMPLES] samples
cpm_mat   <- cpm(dge)
keep_cpm  <- rep(TRUE, nrow(dge))   # SKELETON placeholder
dge <- dge[keep_cpm, , keep.lib.sizes = FALSE]
cat("After CPM filter:", nrow(dge), "miRNAs retained\n")

# -----------------------------------------------------------------------------
# STEP 6: Save filtered matrix
# -----------------------------------------------------------------------------
write.csv(dge$counts, "miRNA_count_matrix_filtered.csv", row.names = TRUE)

cat("\nFiltered matrix saved → miRNA_count_matrix_filtered.csv\n")
cat("Phase 2 | Filter step complete.\n")
