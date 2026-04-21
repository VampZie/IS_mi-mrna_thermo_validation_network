#!/usr/bin/env python3
# =============================================================================
# PHASE 3 | TARGET PREDICTION: RNAcofold OUTPUT PARSER
# Tool: RNAcofold (ViennaRNA Package)
# =============================================================================
# PURPOSE:
#   Parses raw RNAcofold output and extracts the co-folding free energy
#   (ΔG_cofold) for each miRNA–target site pair.
#
#   OUTPUT INTERPRETATION:
#     ΔG_cofold < 0       → favourable co-folding (interaction possible)
#     ΔG_cofold << ΔG_mfe → strong cooperative stabilisation
#     The delta between RNAhybrid MFE and RNAcofold energy represents
#     contextual stabilisation from flanking sequence structure.
#
# INPUT : {GROUP}_rnacofold_raw.txt  (stdout from RNAcofold pipe)
# OUTPUT: {GROUP}_rnacofold_results.csv
#           Columns: pair_id | miRNA | transcript | position | dG_cofold
# =============================================================================

import sys
import os
import re
import pandas as pd

if len(sys.argv) != 2:
    print("Usage: parse_rnacofold_results.py <GROUP>")
    sys.exit(1)

GROUP       = sys.argv[1]
INPUT_FILE  = f"{GROUP}_rnacofold_raw.txt"
OUTPUT_FILE = f"{GROUP}_rnacofold_results.csv"

print("============================================")
print(f"RNAcofold Parser | Group: {GROUP}")
print("============================================")

if not os.path.exists(INPUT_FILE):
    print(f"ERROR: RNAcofold output not found: {INPUT_FILE}")
    sys.exit(1)

# -----------------------------------------------------------------------------
# PARSING LOGIC
# -----------------------------------------------------------------------------
# SKELETON: RNAcofold output format (per interaction):
#
#   >{miRNA_ID}&{Transcript}_{position}   ← header line
#   {sequence}&{site_sequence}            ← input sequence
#   {dot_bracket_structure}  ({dG_cofold} kcal/mol = {dG1} + {dG2} + {dGint})
#
# Regex to extract ΔG_cofold:
#   pattern = r'\(\s*([-\d.]+)\s*=\s*[-\d.]+\s*\+\s*[-\d.]+\s*\+\s*[-\d.]+'
#
# Parser iterates line-by-line, tracking header/sequence/structure triplets.

records = []

with open(INPUT_FILE) as f:
    lines = f.readlines()

# SKELETON: triplet parsing logic omitted.
# Expected extraction per block:
#   pair_id    = header (after ">")
#   dG_cofold  = first parenthetical value
#   miRNA      = split pair_id on "&"[0]
#   transcript = split pair_id on "&"[1].split("_")[0]
#   position   = split pair_id on "&"[1].split("_")[1]

print(f"[SKELETON] {len(lines)} lines found in RNAcofold output.")
print("[SKELETON] Triplet parsing omitted — dG_cofold extraction not shown.")

# Build results DataFrame
df = pd.DataFrame(records, columns=["pair_id","miRNA","transcript","position","dG_cofold"])
df.to_csv(OUTPUT_FILE, index=False)

print(f"Results saved → {OUTPUT_FILE}")
print(f"Total pairs parsed: {len(df)}")
print("============================================")
