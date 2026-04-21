#!/usr/bin/env python3
# =============================================================================
# PHASE 3 | TARGET PREDICTION: MFE ENERGY FILTER
# Tool: RNAhybrid post-processing
# =============================================================================
# PURPOSE:
#   Filters miRNA–mRNA interaction candidates based on Minimum Free Energy
#   (MFE) thermodynamic criterion. Applies a context-calibrated threshold of
#   ≤ −20 kcal/mol to retain only thermodynamically stable binding events.
#
#   DUAL OUTPUT STRATEGY:
#     File 1 — All filtered interactions (MFE ≤ threshold)
#     File 2 — Best binding site per miRNA–transcript pair (strongest MFE)
#       Rationale: Multiple binding sites per transcript can inflate interaction
#       counts. The "best site" file provides a conservative, biologically
#       realistic estimate of regulatory capacity.
#
# USAGE:
#   python filter_by_energy.py <GROUP>
#   Must be run from within: target_prediction/<GROUP>/energy/rnahybrid/
#
# INPUT : {GROUP}_RNAhybrid_parsed_result.csv
# OUTPUT: {GROUP}_RNAhybrid_MFE_filtered.csv
#         {GROUP}_best_sites_MFE_filtered.csv
# =============================================================================

import sys
import os
import pandas as pd

if len(sys.argv) != 2:
    print("Usage: filter_by_energy.py <GROUP>")
    sys.exit(1)

GROUP = sys.argv[1]

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
input_file     = f"{GROUP}_RNAhybrid_parsed_result.csv"
filtered_output = f"{GROUP}_RNAhybrid_MFE_filtered.csv"
best_output    = f"{GROUP}_best_sites_MFE_filtered.csv"

ENERGY_THRESHOLD = float(os.getenv("THRESHOLD_MFE", -99.9))   # kcal/mol (REDACTED)

print("-----------------------------------------------------")
print(f"GROUP          : {GROUP}")
print(f"Working dir    : {os.getcwd()}")
print(f"Input file     : {input_file}")
print(f"MFE threshold  : ≤ {ENERGY_THRESHOLD} kcal/mol")
print("-----------------------------------------------------")

# -----------------------------------------------------------------------------
# PRECONDITIONS
# -----------------------------------------------------------------------------
if not os.path.exists(input_file):
    print(f"ERROR: Parsed RNAhybrid file not found: {input_file}")
    sys.exit(1)

if os.path.getsize(input_file) == 0:
    print("WARNING: Parsed file is empty — no interactions to filter.")
    pd.DataFrame().to_csv(filtered_output, index=False)
    pd.DataFrame().to_csv(best_output, index=False)
    sys.exit(0)

# -----------------------------------------------------------------------------
# STEP 1: Load interaction table
# -----------------------------------------------------------------------------
# SKELETON: Input CSV columns (from parse_output.sh):
#   miRNA_Name | Transcript_ID | MFE | Position | Target_Seq | miRNA_Seq
df = pd.read_csv(input_file)

if df.empty:
    print("No interactions in parsed file.")
    df.to_csv(filtered_output, index=False)
    df.to_csv(best_output, index=False)
    sys.exit(0)

print(f"Total raw interactions loaded: {len(df)}")

# -----------------------------------------------------------------------------
# STEP 2: MFE column cleaning
# -----------------------------------------------------------------------------
# SKELETON: MFE values may contain quote artifacts from shell parsing.
# Strip whitespace and quotes, then coerce to numeric.
# Rows with non-numeric MFE (coercion failures) are dropped.

df["MFE"] = (
    df["MFE"]
    .astype(str)
    .str.replace('"', '', regex=False)
    .str.strip()
)
df["MFE"] = pd.to_numeric(df["MFE"], errors="coerce")
df = df.dropna(subset=["MFE"])

# -----------------------------------------------------------------------------
# STEP 3: Apply MFE threshold filter
# -----------------------------------------------------------------------------
df_filtered = df[df["MFE"] <= ENERGY_THRESHOLD].sort_values("MFE")
df_filtered.to_csv(filtered_output, index=False)

# -----------------------------------------------------------------------------
# STEP 4: Best-site deduplication
# -----------------------------------------------------------------------------
# SKELETON: For each (Transcript_ID, miRNA_Name) pair, retain only the
# interaction with the lowest (most negative) MFE value.
# This prevents one abundant transcript from dominating the interaction count.

if not df_filtered.empty:
    df_best = df_filtered.drop_duplicates(
        subset=["Transcript_ID", "miRNA_Name"],
        keep="first"   # already sorted by MFE ascending
    )
else:
    df_best = df_filtered.copy()

df_best.to_csv(best_output, index=False)

# -----------------------------------------------------------------------------
# SUMMARY REPORT
# -----------------------------------------------------------------------------
print(f"Total interactions                    : {len(df)}")
print(f"After MFE filter (≤ {ENERGY_THRESHOLD})       : {len(df_filtered)}")
print(f"Best sites (unique miRNA–transcript)  : {len(df_best)}")
print(f"Filtered file  → {filtered_output}")
print(f"Best sites file → {best_output}")
print("-----------------------------------------------------")
