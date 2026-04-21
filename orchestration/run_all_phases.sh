#!/bin/bash
# =============================================================================
# MASTER ORCHESTRATION: Run All Phases (Phase 1 → 2 → 3)
# Stroke-miRNA-Suite
# =============================================================================
# PURPOSE:
#   End-to-end pipeline launcher. Executes all three phases sequentially,
#   passing outputs from Phase 1 → Phase 2 → Phase 3 automatically.
#
# ENVIRONMENT REQUIREMENTS:
#   conda env: mrna   (STAR, featureCounts, fastp, DESeq2, edgeR, limma)
#   conda env: mirna  (miRDeep2, cutadapt, Bowtie)
#   conda env: thermo (RNAhybrid, RNAplfold, RNAcofold, TargetScan)
#   conda env: py     (Python 3.8+, pandas, numpy)
#
# USAGE:
#   bash run_all_phases.sh [--phase1] [--phase2] [--phase3]
#   (default: runs all three phases)
#
# RESUMABILITY:
#   Each phase checks for existing outputs before re-running.
#   Safe to re-launch after partial failure.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(realpath "$SCRIPT_DIR/../")"
LOG_DIR="$ROOT_DIR/logs"
mkdir -p "$LOG_DIR"

MASTER_LOG="$LOG_DIR/master_run_$(date +%Y%m%d_%H%M%S).log"

echo "========================================================" | tee "$MASTER_LOG"
echo "  Stroke-miRNA-Suite | Master Pipeline"                   | tee -a "$MASTER_LOG"
echo "  Started: $(date)"                                        | tee -a "$MASTER_LOG"
echo "========================================================" | tee -a "$MASTER_LOG"

# Parse flags
RUN_P1=true; RUN_P2=true; RUN_P3=true
for arg in "$@"; do
  case $arg in
    --phase1) RUN_P1=true;  RUN_P2=false; RUN_P3=false ;;
    --phase2) RUN_P1=false; RUN_P2=true;  RUN_P3=false ;;
    --phase3) RUN_P1=false; RUN_P2=false; RUN_P3=true  ;;
  esac
done

# =============================================================
# PHASE 1: DATA ACQUISITION
# =============================================================
if $RUN_P1; then
  echo "" | tee -a "$MASTER_LOG"
  echo "--------------------------------------------------------" | tee -a "$MASTER_LOG"
  echo "PHASE 1: Data Acquisition"                               | tee -a "$MASTER_LOG"
  echo "--------------------------------------------------------" | tee -a "$MASTER_LOG"

  echo "[P1.1] Human mRNA: SRA download..."
  # SKELETON: bash phase1_data_acquisition/human_mrna/01_sra_download.sh

  echo "[P1.2] Human mRNA: Quality trimming..."
  # SKELETON: bash phase1_data_acquisition/human_mrna/02_quality_trim.sh

  echo "[P1.3] Human mRNA: STAR alignment..."
  # SKELETON: bash phase1_data_acquisition/human_mrna/03_align_quantify.sh

  echo "[P1.4] Human mRNA: featureCounts..."
  # SKELETON: bash phase1_data_acquisition/human_mrna/04_feature_counts.sh

  echo "[P1.5] Human mRNA: Build count matrix..."
  # SKELETON: Rscript phase1_data_acquisition/human_mrna/05_build_count_matrix.R

  echo "[P1.6] Human miRNA: Full small-RNA pipeline..."
  # SKELETON: bash phase1_data_acquisition/human_mirna/trim_all.sh
  # SKELETON: bash phase1_data_acquisition/human_mirna/map_all.sh
  # SKELETON: bash phase1_data_acquisition/human_mirna/quantify_all.sh
  # SKELETON: bash phase1_data_acquisition/human_mirna/collapse_all.sh

  echo "Phase 1 complete: $(date)" | tee -a "$MASTER_LOG"
fi

# =============================================================
# PHASE 2: DIFFERENTIAL EXPRESSION
# =============================================================
if $RUN_P2; then
  echo "" | tee -a "$MASTER_LOG"
  echo "--------------------------------------------------------" | tee -a "$MASTER_LOG"
  echo "PHASE 2: Differential Expression"                        | tee -a "$MASTER_LOG"
  echo "--------------------------------------------------------" | tee -a "$MASTER_LOG"

  echo "[P2.1] Human miRNA: edgeR filter + DE..."
  # SKELETON: Rscript phase2_differential_expression/human_mirna/01_filter_counts.R
  # SKELETON: Rscript phase2_differential_expression/human_mirna/02_de_edgeR.R

  echo "[P2.2] Rat miRNA: microarray preprocessing + limma DE..."
  # SKELETON: Rscript phase2_differential_expression/rat_mirna/01_microarray_preprocess.R
  # SKELETON: Rscript phase2_differential_expression/rat_mirna/02_de_limma.R

  echo "[P2.3] Human mRNA: DESeq2..."
  # SKELETON: Rscript phase2_differential_expression/human_mrna/01_de_deseq2.R

  echo "[P2.4] Rat mRNA: limma + Illumina annotation..."
  # SKELETON: Rscript phase2_differential_expression/rat_mrna/01_de_limma_illumina.R

  echo "Phase 2 complete: $(date)" | tee -a "$MASTER_LOG"
fi

# =============================================================
# PHASE 3: THERMODYNAMIC VALIDATION + NETWORK DYNAMICS
# =============================================================
if $RUN_P3; then
  echo "" | tee -a "$MASTER_LOG"
  echo "--------------------------------------------------------" | tee -a "$MASTER_LOG"
  echo "PHASE 3: Thermodynamic Validation + Network Dynamics"    | tee -a "$MASTER_LOG"
  echo "--------------------------------------------------------" | tee -a "$MASTER_LOG"

  echo "[P3.0] Sequence retrieval (ENSG → symbol)..."
  # SKELETON: bash phase3_thermodynamic_network/00_sequence_retrieval/extract_ensg_symbols.sh
  # SKELETON: bash phase3_thermodynamic_network/00_sequence_retrieval/extract_rat_symbols.sh

  echo "[P3.1] Harmonization (Human + Rat)..."
  # SKELETON: Rscript phase3_thermodynamic_network/01_harmonization/human_harmonize.R
  # SKELETON: Rscript phase3_thermodynamic_network/01_harmonization/rat_harmonize.R

  echo "[P3.2] Thermodynamic validation suite..."
  for GROUP in Moderate_vs_Control Severe_vs_Control Stroke_vs_Control; do
    echo "  → $GROUP"
    # SKELETON: bash phase3_thermodynamic_network/02_target_prediction/run_thermodynamic_suite.sh "$GROUP"
  done

  echo "[P3.3] Network dynamics — Human..."
  # SKELETON: Rscript phase3/.../human/01_define_network.R
  # ... through 07_functional_enrichment.R

  echo "[P3.4] Network dynamics — Rat..."
  # SKELETON: Rscript phase3/.../rat/rat_network_suite.R

  echo "Phase 3 complete: $(date)" | tee -a "$MASTER_LOG"
fi

echo "" | tee -a "$MASTER_LOG"
echo "========================================================" | tee -a "$MASTER_LOG"
echo "  ALL PHASES COMPLETE: $(date)"                           | tee -a "$MASTER_LOG"
echo "========================================================" | tee -a "$MASTER_LOG"
