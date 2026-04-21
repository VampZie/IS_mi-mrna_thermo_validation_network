#!/usr/bin/env Rscript
# =============================================================================
# PHASE 2 | HUMAN miRNA DE: DIFFERENTIAL EXPRESSION (edgeR — glmFit/glmLRT)
# Dataset: GSE202708 — Human miRNA-seq, Ischemic Stroke Progression
# =============================================================================
# PURPOSE:
#   Identifies differentially expressed miRNAs across a 4-state ischemic stroke
#   progression model using edgeR's generalised linear model framework.
#
#   DISEASE MODEL:
#     Control → Moderate TBI → Severe TBI → Stroke
#
#   CONTRASTS (4 pairwise):
#     1. Moderate  vs Control   → early ischemic response
#     2. Severe    vs Control   → advanced ischemic response
#     3. Severe    vs Moderate  → progression signature
#     4. Stroke    vs Control   → composite stroke signature (avg moderate+severe)
#
#   THRESHOLDS:
#     FDR < 0.05  AND  |logFC| > 1
#
# INPUT : miRNA_count_matrix_filtered.csv, sample_info.csv
# OUTPUT: DE_{contrast}_ALL.csv, _SIG.csv, _UP.csv, _DOWN.csv
# =============================================================================

suppressPackageStartupMessages(library(edgeR))

cat("============================================\n")
cat("Phase 2 | Human miRNA DE — edgeR glmLRT\n")
cat("============================================\n\n")

# -----------------------------------------------------------------------------
# STEP 1: Load filtered count matrix + metadata
# -----------------------------------------------------------------------------
counts <- read.csv("miRNA_count_matrix_filtered.csv", row.names = 1)
meta   <- read.csv("sample_info.csv", stringsAsFactors = FALSE)

# Align sample order
meta    <- meta[match(colnames(counts), meta$sample_id), ]
stopifnot(all(colnames(counts) == meta$sample_id))

meta$group <- factor(meta$condition, levels = c("control", "moderate", "severe"))

# -----------------------------------------------------------------------------
# STEP 2: DGEList + Normalization (TMM)
# -----------------------------------------------------------------------------
# SKELETON: edgeR TMM normalization corrects for library composition bias,
# essential for miRNA-seq where a small number of highly expressed
# miRNAs can dominate the library.

y <- DGEList(counts = counts, group = meta$group)
y <- calcNormFactors(y, method = "TMM")

# -----------------------------------------------------------------------------
# STEP 3: Design matrix + Dispersion estimation
# -----------------------------------------------------------------------------
# SKELETON: ~0 + group design (no intercept) allows explicit contrast coding.
# Dispersion estimated via estimateDisp() with empirical Bayes shrinkage.

design <- model.matrix(~0 + group, data = meta)
colnames(design) <- levels(meta$group)

# SKELETON: y <- estimateDisp(y, design)
# SKELETON: fit <- glmFit(y, design)

# -----------------------------------------------------------------------------
# STEP 4: Contrast function — extract + save DE results
# -----------------------------------------------------------------------------
run_contrast <- function(fit, contrast_vector, contrast_name) {
  # SKELETON: glmLRT performs likelihood ratio test for the specified contrast.
  # lrt <- glmLRT(fit, contrast = contrast_vector)
  # res <- topTags(lrt, n = Inf)$table

  # Significance filter: FDR < 0.05, |logFC| > 1
  # res_sig  <- subset(res, FDR < 0.05 & abs(logFC) > 1)
  # res_up   <- subset(res_sig, logFC > 1)
  # res_down <- subset(res_sig, logFC < -1)

  # SKELETON: write.csv() calls omitted for _ALL, _SIG, _UP, _DOWN variants.
  message(paste("[SKELETON] Contrast:", contrast_name, "— outputs would be written here."))
}

# -----------------------------------------------------------------------------
# STEP 5: Run all 4 progression contrasts
# -----------------------------------------------------------------------------
# Contrast vectors map directly to: [control, moderate, severe]
run_contrast(NULL, c(-1,  1,  0), "Moderate_vs_Control")
run_contrast(NULL, c(-1,  0,  1), "Severe_vs_Control")
run_contrast(NULL, c( 0, -1,  1), "Severe_vs_Moderate")
run_contrast(NULL, c(-1, 0.5, 0.5), "Stroke_vs_Control")   # composite average

cat("\nAll contrasts completed.\n")
cat("Phase 2 | Human miRNA DE complete.\n")
