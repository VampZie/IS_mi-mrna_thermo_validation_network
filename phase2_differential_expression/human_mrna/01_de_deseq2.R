#!/usr/bin/env Rscript
# =============================================================================
# PHASE 2 | HUMAN mRNA DE: DIFFERENTIAL EXPRESSION (DESeq2)
# Dataset: GSE202518 — Human mRNA RNA-seq, Ischemic Stroke Progression
# =============================================================================
# PURPOSE:
#   Identifies differentially expressed mRNA transcripts across ischemic stroke
#   progression using DESeq2's negative binomial GLM.
#
#   DISEASE MODEL:
#     Control → Moderate TBI → Severe TBI → Stroke
#
#   DUAL-MODEL STRATEGY:
#     Model A (3-group): Control | Moderate | Severe → fine-grained progression
#     Model B (2-group): Control | Stroke           → clinical binary signature
#
#   CONTRASTS (4 total):
#     Severe_vs_Control    → maximal ischemic burden
#     Moderate_vs_Control  → sub-maximal ischemic burden
#     Severe_vs_Moderate   → severity escalation
#     Stroke_vs_Control    → clinical stroke composite
#
#   OUTPUTS (dual threshold):
#     RAW   : p < [THRESHOLD_PVAL]  AND  |log2FC| > [THRESHOLD_LOG2FC]   (permissive, for target intersection)
#     FDR   : padj < [THRESHOLD_FDR] AND  |log2FC| > [THRESHOLD_LOG2FC]  (stringent, for validation)
#
#   ANNOTATION: Gene symbols mapped from GENCODE v49 GTF via gene_id lookup
#
# INPUT : gene_counts_clean_matrix.csv, sample_info.csv,
#         gencode.v49.primary_assembly.basic.annotation.gtf
# OUTPUT: deseq2_{contrast}_{all|sig_FDR|sig_RAW|up_RAW|down_RAW}.csv
# =============================================================================

suppressPackageStartupMessages({
  library(DESeq2)
  library(dplyr)
})

cat("============================================\n")
cat("Phase 2 | Human mRNA DE — DESeq2\n")
cat("============================================\n\n")

# -----------------------------------------------------------------------------
# STEP 1: Load count matrix
# -----------------------------------------------------------------------------
counts <- read.csv(
  "gene_counts_clean_matrix.csv",
  row.names    = 1,
  check.names  = FALSE
)
cat("Count matrix:", nrow(counts), "genes ×", ncol(counts), "samples\n")

# -----------------------------------------------------------------------------
# STEP 2: Load + align metadata
# -----------------------------------------------------------------------------
coldata        <- read.csv("sample_info.csv", row.names = 1)
coldata        <- coldata[colnames(counts), , drop = FALSE]
coldata$group  <- factor(coldata$group, levels = c("Control", "Moderate", "Severe"))
cat("Groups:", paste(levels(coldata$group), collapse = " → "), "\n\n")

# -----------------------------------------------------------------------------
# STEP 3: Model A — DESeq2 (3-group)
# -----------------------------------------------------------------------------
# SKELETON:
# dds  <- DESeqDataSetFromMatrix(countData = counts, colData = coldata,
#                                design = ~ group)
# keep <- rowSums(counts(dds)) >= [THRESHOLD_MIN_COUNTS]   → low-count gene filter
# dds  <- DESeq(dds[keep, ])

cat("[SKELETON] DESeq2 3-group model fitting omitted.\n")

# -----------------------------------------------------------------------------
# STEP 4: Model B — DESeq2 (2-group stroke)
# -----------------------------------------------------------------------------
# SKELETON:
# coldata$stroke_status <- factor(
#   ifelse(coldata$group == "Control", "Control", "Stroke"),
#   levels = c("Control", "Stroke")
# )
# dds_stroke <- DESeqDataSetFromMatrix(..., design = ~ stroke_status)
# dds_stroke <- DESeq(dds_stroke[keep, ])

cat("[SKELETON] DESeq2 2-group stroke model omitted.\n")

# -----------------------------------------------------------------------------
# STEP 5: GTF-based gene symbol annotation
# -----------------------------------------------------------------------------
# SKELETON: Parses GENCODE v49 GTF to build gene_id → gene_name lookup.
# Each result table is merged on gene_id to attach HGNC symbols.
# Handles ENSG versioning (ENSG00000123.5 → ENSG00000123) via sub("\\..","",x).

cat("[SKELETON] GTF gene_name annotation merge omitted.\n\n")

# -----------------------------------------------------------------------------
# STEP 6: Contrast function — extract + dual-threshold filter + export
# -----------------------------------------------------------------------------
analyze_contrast <- function(res, contrast_name) {
  # SKELETON:
  # res_df   <- as.data.frame(res) + gene_id + gene_name merge
  # sig_raw  <- subset where pvalue < [THRESHOLD_PVAL] & |log2FC| > [THRESHOLD_LOG2FC]
  # sig_fdr  <- subset where padj  < [THRESHOLD_FDR] & |log2FC| > [THRESHOLD_LOG2FC]
  # up_raw   <- subset where log2FC > [THRESHOLD_LOG2FC]
  # down_raw <- subset where log2FC < -[THRESHOLD_LOG2FC]
  # write.csv() for _all, _sig_FDR, _sig_RAW, _up_RAW, _down_RAW variants
  message(paste("[SKELETON] Contrast:", contrast_name))
}

# -----------------------------------------------------------------------------
# STEP 7: Run all contrasts
# -----------------------------------------------------------------------------
analyze_contrast(NULL, "severe_vs_control")
analyze_contrast(NULL, "moderate_vs_control")
analyze_contrast(NULL, "severe_vs_moderate")
analyze_contrast(NULL, "stroke_vs_control")

cat("\nPhase 2 | Human mRNA DESeq2 analysis complete.\n")
