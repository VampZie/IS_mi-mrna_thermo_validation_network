#!/usr/bin/env Rscript
# =============================================================================
# PHASE 1 | STEP 5: COUNT MATRIX PREPARATION
# Dataset: GSE202518 (Human mRNA — Ischemic Stroke)
# =============================================================================
# PURPOSE:
#   Converts the raw featureCounts output (tab-delimited, with annotation
#   columns) into a clean gene × sample count matrix (CSV), with SRR IDs
#   extracted from BAM path names as column labels.
#
# INPUT : gene_counts_stranded.txt  (featureCounts output)
# OUTPUT: gene_counts_clean_matrix.csv  (DESeq2-ready: genes × samples)
# =============================================================================

cat("============================================\n")
cat("Phase 1 | Step 5: Count matrix preparation\n")
cat("============================================\n\n")

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
input_file  <- "gene_counts_stranded.txt"
output_file <- "gene_counts_clean_matrix.csv"

# -----------------------------------------------------------------------------
# STEP 1: Load featureCounts output
# -----------------------------------------------------------------------------
# SKELETON: featureCounts produces a multi-column file:
#   Geneid | Chr | Start | End | Strand | Length | [BAM paths...]
# The first 6 columns are annotation metadata; columns 7+ are sample counts.

cat("Loading featureCounts output...\n")
counts <- read.table(
  input_file,
  header       = TRUE,
  row.names    = 1,
  comment.char = "#",
  check.names  = FALSE
)

cat("Raw dimensions:", nrow(counts), "genes ×", ncol(counts), "columns\n")

# -----------------------------------------------------------------------------
# STEP 2: Drop annotation columns (columns 1–5 after gene_id is row.names)
# -----------------------------------------------------------------------------
# SKELETON: columns Chr, Start, End, Strand, Length are removed.
# Remaining columns 7+ correspond to individual BAM files (one per sample).

counts_matrix <- counts[, 7:ncol(counts)]

# -----------------------------------------------------------------------------
# STEP 3: Clean column names → extract SRR accession IDs
# -----------------------------------------------------------------------------
# SKELETON: BAM paths look like:
#   aligned/SRR12345678/Aligned.sortedByCoord.out.bam
# The regex sub(".*(SRR[0-9]+).*", "\\1", x) extracts the accession.

clean_names <- sub(".*(SRR[0-9]+).*", "\\1", colnames(counts_matrix))
colnames(counts_matrix) <- clean_names

cat("Sample IDs extracted:", paste(clean_names, collapse = ", "), "\n")
cat("Final matrix dimensions:", nrow(counts_matrix), "genes ×",
    ncol(counts_matrix), "samples\n")

# -----------------------------------------------------------------------------
# STEP 4: Save clean matrix
# -----------------------------------------------------------------------------
write.csv(counts_matrix, file = output_file, quote = FALSE)

cat("\nClean count matrix saved →", output_file, "\n")
cat("Phase 1 | Step 5 complete.\n")
