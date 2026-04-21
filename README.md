# IS_mi-mrna_thermo_validation_network

> **Validation of known miRNA–mRNA regulatory states in Ischemic Stroke via thermodynamic stability, seed duplex formation, and structural accessibility filtering — with co-expression network dynamics analysis.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20HPC-lightgrey)]()
[![R version](https://img.shields.io/badge/R-%3E%3D4.2-276DC3?logo=r)]()
[![Python](https://img.shields.io/badge/Python-%3E%3D3.8-3776AB?logo=python)]()

---

## Scientific Overview

This pipeline characterizes the dynamic miRNA–mRNA regulatory landscape across four stages of ischemic brain injury:

```
Control → Moderate TBI → Severe TBI → Stroke
```

Using **dual-species** (human + rat) and **dual-platform** (RNA-seq + microarray) data integration, each predicted interaction is validated through a stringent **4-tool thermodynamic intersection** before entering the network.

### Key Contributions

| Feature | Detail |
|---------|--------|
| **Multi-engine DE** | edgeR (miRNA-seq) · DESeq2 (RNA-seq) · limma (microarray) |
| **4-tool thermodynamics** | TargetScan · RNAhybrid (MFE ≤ [THRESHOLD_MFE]) · RNAplfold · RNAcofold |
| **Cross-species validation** | Human (hsa) + Rat (rno) parallel networks |
| **Network rigidity metric** | Degree rewiring quantification across progression states |
| **Regulatory flip detection** | miRNAs switching binding affinity class across states |

---

## Pipeline Architecture

```
IS_mi-mrna_thermo_validation_network/
│
├── phase1_data_acquisition/          ← Raw data ingest (FASTQ → count matrices)
│   ├── human_mrna/                   ← SRA → STAR → featureCounts → CSV
│   └── human_mirna/                  ← cutadapt → miRDeep2 → count matrix
│
├── phase2_differential_expression/   ← Multi-engine DE analysis
│   ├── human_mirna/                  ← edgeR (glmLRT, 4 contrasts)
│   ├── rat_mirna/                    ← limma (quantile norm + eBayes)
│   ├── human_mrna/                   ← DESeq2 (dual-model: 3-group + stroke)
│   └── rat_mrna/                     ← limma + illuminaRatv1.db annotation
│
├── phase3_thermodynamic_network/     ← Thermodynamic validation + network analysis
│   ├── 00_sequence_retrieval/        ← ENSG/ENSRNOG → gene symbol extraction
│   ├── 01_harmonization/             ← DE result harmonization (protein-coding filter)
│   ├── 02_target_prediction/         ← TargetScan · RNAhybrid · RNAplfold · RNAcofold
│   └── 03_network_dynamics/          ← igraph networks + rewiring + enrichment
│       ├── human/                    ← 7 analysis scripts (human model)
│       └── rat/                      ← Mirrored suite (rat model)
│
├── orchestration/                    ← Master pipeline launcher (run_all_phases.sh)
└── examples/                         ← Synthetic data for demonstration
```

---

## Datasets

| Dataset | Species | Platform | Groups | GEO |
|---------|---------|----------|--------|-----|
| GSE202708 | Human | small-RNA-seq (miRNA) | Control · Moderate · Severe | [Link](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE202708) |
| GSE202518 | Human | RNA-seq (mRNA) | Control · Moderate · Severe | [Link](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE202518) |
| GSE46266  | Rat   | Microarray (miRNA) | Control · Acute · Subacute | [Link](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE46266) |
| GSE46267  | Rat   | Microarray (mRNA)  | Control · Acute · Subacute | [Link](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE46267) |

---

## Environments

```bash
# Create environments
conda env create -f environment.yml

# Available environments:
#   mrna   → R 4.2+, DESeq2, edgeR, limma, STAR, featureCounts, fastp
#   mirna  → miRDeep2, cutadapt, Bowtie, R (edgeR)
#   thermo → RNAhybrid, RNAplfold, RNAcofold (ViennaRNA 2.6+), TargetScan
#   py     → Python 3.8+, pandas, numpy, biopython
```

---

## Quick Start

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/IS_mi-mrna_thermo_validation_network.git
cd IS_mi-mrna_thermo_validation_network

# Run full pipeline (requires HPC + datasets)
bash orchestration/run_all_phases.sh

# Run specific phase only
bash orchestration/run_all_phases.sh --phase2

# Demo with synthetic data
cd examples/
Rscript ../phase2_differential_expression/human_mirna/02_de_edgeR.R
```

---

## Phase Summaries

| Phase | Input | Output | Key Tools |
|-------|-------|--------|-----------|
| **Phase 1** | SRA accessions | Count matrices (CSV) | prefetch, fastp, STAR, featureCounts, miRDeep2 |
| **Phase 2** | Count matrices | DE lists (quantitatively filtered) | edgeR, DESeq2, limma |
| **Phase 3** | DE lists | Validated networks + figures | RNAhybrid, RNAplfold, RNAcofold, igraph, ggplot2 |

---

## Reference

This pipeline was developed as part of a doctoral dissertation on multi-omics characterization of ischemic stroke regulatory dynamics. The 4-tool thermodynamic validation framework and cross-species network rigidity quantification represent novel methodological contributions to computational neuroscience.

> *Thermodynamic stability, seed duplex formation, and structural accessibility filtering reveal progressive regulatory entropy loss in ischemic stroke miRNA–mRNA networks.*

---

## License

MIT License — see [LICENSE](LICENSE) for details.
