#!/usr/bin/env python3
# =============================================================================
# PHASE 3 | TARGET PREDICTION: RNAcofold INPUT PREPARATION
# Tool: RNAcofold (ViennaRNA Package)
# =============================================================================
# PURPOSE:
#   Prepares co-folding input sequences for RNAcofold by combining miRNA
#   sequences with their cognate 3'UTR binding-site windows (extracted from
#   RNAhybrid best-site results). The "&" separator is the RNAcofold
#   intermolecular concatenation syntax.
#
#   SCIENTIFIC RATIONALE:
#     RNAcofold computes the co-folding free energy (ΔG_cofold) of the
#     miRNA paired with its actual target context, not just the seed alone.
#     This captures non-canonical base pairing beyond the seed (positions 13–16)
#     which is critical for high-affinity repression in stroke-injured neurons.
#
#   SITE WINDOW: binding_site ± 10 nt flanking context
#
# INPUT : {GROUP}_best_sites_MFE_leq_-20.csv   (from RNAhybrid filter)
#         {GROUP}_selected_miRNAs.fa            (miRNA sequences)
#         {GROUP}_full_3utr.fa                  (3'UTR sequences)
# OUTPUT: {GROUP}_rnacofold_input.txt
#           Format: >{miRNA_ID}&{Transcript_ID}_{position}
#                   {miRNA_seq}&{site_window_seq}
# =============================================================================

import sys
import os
import pandas as pd

# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
if len(sys.argv) != 2:
    print("Usage: prepare_rnacofold_input.py <GROUP>")
    sys.exit(1)

GROUP        = sys.argv[1]
FLANK_SIZE   = 10   # nt flanking context around binding site

INPUT_SITES  = f"{GROUP}_best_sites_MFE_leq_-20.csv"
MIRNA_FA     = f"{GROUP}_selected_miRNAs.fa"
UTR_FA       = f"{GROUP}_full_3utr.fa"
OUTPUT_FILE  = f"{GROUP}_rnacofold_input.txt"

print("============================================")
print(f"RNAcofold Input Preparation | Group: {GROUP}")
print(f"Flank window: ±{FLANK_SIZE} nt")
print("============================================")

# -----------------------------------------------------------------------------
# STEP 1: Load best-site interactions
# -----------------------------------------------------------------------------
if not os.path.exists(INPUT_SITES):
    print(f"ERROR: Best-sites file not found: {INPUT_SITES}")
    sys.exit(1)

sites_df = pd.read_csv(INPUT_SITES)
print(f"Interactions to prepare: {len(sites_df)}")

# -----------------------------------------------------------------------------
# STEP 2: Load miRNA sequences (FASTA → dict)
# -----------------------------------------------------------------------------
# SKELETON: parse_fasta() reads {miRNA_ID: sequence} from *.fa
# SKELETON: miRNA sequences are reverse-complemented to match strand convention
miRNA_seqs = {}    # {miRNA_name: sequence}
print("[SKELETON] miRNA FASTA loading omitted.")

# -----------------------------------------------------------------------------
# STEP 3: Load 3'UTR sequences (FASTA → dict)
# -----------------------------------------------------------------------------
# SKELETON: parse_fasta() reads {transcript_id: utr_sequence}
utr_seqs = {}      # {transcript_id: sequence}
print("[SKELETON] 3'UTR FASTA loading omitted.")

# -----------------------------------------------------------------------------
# STEP 4: Build RNAcofold input sequences
# -----------------------------------------------------------------------------
# SKELETON: For each (miRNA, transcript, position) interaction:
#   1. Extract binding site window: utr[pos-FLANK : pos+len(miRNA)+FLANK]
#   2. Concatenate: miRNA_seq + "&" + site_window
#   3. Write FASTA-style header: >{miRNA}&{transcript}_{pos}
#
# "U" substituted for "T" (RNA convention required by RNAcofold)

records_written = 0

with open(OUTPUT_FILE, "w") as fout:
    for _, row in sites_df.iterrows():
        # SKELETON: extraction + concatenation omitted
        fout.write(f">[SKELETON]\n[SKELETON]&[SKELETON]\n")
        records_written += 1

print(f"Records written → {OUTPUT_FILE} : {records_written}")
print("RNAcofold input preparation complete.")
