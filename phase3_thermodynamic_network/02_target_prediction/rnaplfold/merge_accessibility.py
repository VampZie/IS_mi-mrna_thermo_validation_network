#!/usr/bin/env python3
# =============================================================================
# PHASE 3 | TARGET PREDICTION: RNAplfold ACCESSIBILITY MERGER
# Tool: RNAplfold (ViennaRNA Package)
# =============================================================================
# PURPOSE:
#   Merges per-transcript RNAplfold ".lunp" (unpaired probability) output
#   files into a single accessibility matrix for downstream intersection
#   with RNAhybrid and TargetScan candidates.
#
#   WHAT RNAplfold MEASURES:
#     Local unpaired probability (lunp) of nucleotide windows in the 3'UTR.
#     High unpaired probability → accessible site → permissive for miRNA
#     binding. Sites with low accessibility are thermodynamically occluded
#     and poor RISC recruitment candidates.
#
#   WINDOW PARAMETERS (applied during RNAplfold execution):
#     -W 80   → sliding window size (nt)
#     -u 8    → seed region length (nt) — matches canonical 7–8mer seed
#     -L 40   → maximum base-pair span
#
# INPUT : *.lunp files (one per transcript, in working directory)
# OUTPUT: merged_accessibility.csv
#           Columns: transcript_id | position | unpaired_prob_window_8
# =============================================================================

import sys
import os
import glob
import pandas as pd

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
LUNP_PATTERN  = "*.lunp"
OUTPUT_FILE   = "merged_accessibility.csv"
WINDOW_COL    = 8    # column index for 8-nt window unpaired probability

print("============================================")
print("RNAplfold Accessibility Merger")
print("============================================")
print(f"Working directory: {os.getcwd()}")

# -----------------------------------------------------------------------------
# STEP 1: Discover .lunp files
# -----------------------------------------------------------------------------
lunp_files = sorted(glob.glob(LUNP_PATTERN))
print(f"lunp files found: {len(lunp_files)}")

if len(lunp_files) == 0:
    print("ERROR: No .lunp files found. Run RNAplfold first.")
    sys.exit(1)

# -----------------------------------------------------------------------------
# STEP 2: Parse + merge
# -----------------------------------------------------------------------------
# SKELETON: Each .lunp file format (RNAplfold output):
#   Line 1: comment (#)
#   Line 2: header     (position | 1 | 2 | ... | u)
#   Lines 3+: data     (position | prob_1 | prob_2 | ... | prob_u)
#
# Extraction logic:
#   - filename  → transcript_id (strip .lunp extension)
#   - column u=8 → unpaired probability for 8-nt seed window
#   - retain positions where prob >= accessibility_threshold

records = []

for f in lunp_files:
    transcript_id = os.path.basename(f).replace(".lunp", "")
    # SKELETON: parsing logic omitted
    # Expected per transcript:
    #   [(transcript_id, position, unpaired_prob_8), ...]
    records.append({"transcript_id": transcript_id,
                    "position": None,
                    "unpaired_prob_w8": None})

# -----------------------------------------------------------------------------
# STEP 3: Assemble + export
# -----------------------------------------------------------------------------
df_merged = pd.DataFrame(records)
df_merged.to_csv(OUTPUT_FILE, index=False)

print(f"Merged accessibility matrix → {OUTPUT_FILE}")
print(f"Total records: {len(df_merged)}")
print("============================================")
