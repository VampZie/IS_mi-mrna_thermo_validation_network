#!/usr/bin/env Rscript
# =============================================================================
# PHASE 1 | miRNA PIPELINE: COUNT MATRIX BUILDER
# Dataset: GSE202708 (Human miRNA-seq — Ischemic Stroke)
# =============================================================================
# PURPOSE:
#   Reads all per-sample miRDeep2 quantifier.pl CSV files and merges them
#   into a single gene × sample count matrix for downstream edgeR analysis.
#
#   Key operations:
#     - Extracts sample name from filename
#     - Selects miRNA + read_count columns only
#     - Collapses duplicate mature entries via sum aggregation
#     - Outer joins all samples on miRNA identifier
#     - Fills NA values with 0 (absent miRNAs not expressed in that sample)
#
# INPUT : miRNAs_expressed_all_samples_*.csv  (one per sample in working dir)
# OUTPUT: miRNA_count_matrix.csv
# =============================================================================

suppressPackageStartupMessages(library(dplyr))

cat("============================================\n")
cat("Building miRNA count matrix from quantifier outputs\n")
cat("============================================\n\n")

# -----------------------------------------------------------------------------
# STEP 1: Discover all per-sample quantifier CSVs
# -----------------------------------------------------------------------------
files <- list.files(
  pattern = "miRNAs_expressed_all_samples_.*\\.csv$"
)

cat("Sample files found:", length(files), "\n")
if (length(files) == 0) stop("No quantifier CSV files found.")

# -----------------------------------------------------------------------------
# STEP 2–4: Load, extract, collapse, and merge
# -----------------------------------------------------------------------------
# SKELETON: For each file:
#   1. Extract sample_name from filename (strip prefix/suffix)
#   2. Read tab-delimited file; rename column "#miRNA" → "miRNA"
#   3. Keep only miRNA + read_count columns
#   4. Collapse duplicates: group_by(miRNA) + summarise(count = sum(read_count))
#   5. Rename count column → sample_name
#   6. Add to count_list

count_list <- list()

for (f in files) {

  sample_name <- sub("miRNAs_expressed_all_samples_|\\.csv", "", f)

  # SKELETON: loading and processing omitted.
  # Result per file: 2-column data.frame: miRNA | {sample_name}
  cat("  Processing:", sample_name, "\n")

  count_list[[sample_name]] <- data.frame(
    miRNA = character(),
    count = integer()
  )
}

# -----------------------------------------------------------------------------
# STEP 5: Outer join all samples on miRNA
# -----------------------------------------------------------------------------
# SKELETON: Reduce(function(x, y) merge(x, y, by="miRNA", all=TRUE), count_list)
# NA → 0 fill applied after merge.

count_matrix <- data.frame(miRNA = character())  # SKELETON placeholder

# -----------------------------------------------------------------------------
# STEP 6: Save
# -----------------------------------------------------------------------------
write.csv(count_matrix, "miRNA_count_matrix.csv", row.names = FALSE)

cat("\nmiRNA count matrix saved → miRNA_count_matrix.csv\n")
cat("Dimensions: [SKELETON] genes × samples\n")
cat("Phase 1 | miRNA matrix build complete.\n")
