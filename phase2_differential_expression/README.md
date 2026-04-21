# Phase 2 — Differential Expression Analysis

## Overview

Multi-engine differential expression analysis across 4 disease progression contrasts using
the optimal statistical framework for each platform type.

## Engine Selection Rationale

| Dataset | Platform | Engine | Why |
|---------|----------|--------|-----|
| GSE202708 (Human miRNA) | small-RNA-seq | **edgeR** (glmLRT) | Count-based NB model; superior for sparse miRNA-seq libraries |
| GSE46266 (Rat miRNA) | Microarray (Agilent) | **limma** (eBayes) | Appropriate for normalized continuous array intensities |
| GSE202518 (Human mRNA) | RNA-seq | **DESeq2** | Recommended for bulk RNA-seq; superior shrinkage estimation |
| GSE46267 (Rat mRNA) | Microarray (Illumina) | **limma + illuminaRatv1.db** | Probe annotation via Bioconductor rat annotation package |

## Significance Thresholds

| Platform | P-value | FDR | |logFC| |
|----------|---------|-----|---------|
| RNA-seq / miRNA-seq | padj < 0.05 | Yes | > 1 |
| Microarray | P.Value < 0.05 | Raw (n=3/group) | ≥ 1 |

> **Note:** Microarray datasets (rat model) use raw p-values due to small sample size (n=3 per group), where FDR correction is overly conservative.

## Disease Model (4 Contrasts)

```
Control ──────► Moderate  (early ischemic response)
         ──────► Severe    (advanced ischemic burden)
Moderate ──────► Severe    (progression signature)
Control ──────► Stroke    (clinical composite, avg Moderate+Severe)
```

## Outputs per Contrast

```
DE_{contrast}_ALL.csv     ← Full result table (all tested features)
DE_{contrast}_SIG.csv     ← FDR-significant features
DE_{contrast}_UP.csv      ← Upregulated subset
DE_{contrast}_DOWN.csv    ← Downregulated subset
```

## Key Visualizations

- **Volcano plots**: logFC vs −log10(p) per contrast
- **MA plots**: mean expression vs logFC
- **PCA plots**: sample-level separation per contrast
- **Heatmaps**: Top 50–100 DE features per contrast
