# Stroke-miRNA-Suite | Full Pipeline Overview

> Scientific narrative connecting Phase 1 → Phase 2 → Phase 3

---

## 1. Scientific Question

**How does the miRNA–mRNA regulatory network of the ischemic brain rewire across progressive disease severity?**

Specifically:
- Which miRNAs gain or lose regulatory control during stroke progression?
- Are the surviving miRNA–mRNA interactions thermodynamically more stable (rigid) in severe disease?
- Are these changes conserved between human and rat models?

---

## 2. Full Data Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│  PHASE 1 — Data Acquisition                                             │
│                                                                         │
│  GSE202708 (Human, miRNA-seq) ─────────────────────────┐               │
│    prefetch → cutadapt → miRDeep2 → count matrix       │               │
│                                                          ▼               │
│  GSE202518 (Human, mRNA RNA-seq) ──────────────> human count matrices  │
│    prefetch → fastp → STAR → featureCounts → matrix    │               │
│                                                          │               │
│  GSE46266 (Rat, miRNA microarray) ─ raw signal files   │               │
│  GSE46267 (Rat, mRNA microarray)  ─ raw expression     │               │
└───────────────────────────────────┬─────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  PHASE 2 — Differential Expression                                      │
│                                                                         │
│  Human miRNA  → edgeR (glmLRT)           4 contrasts                   │
│  Rat miRNA    → limma (eBayes)            4 contrasts                   │
│  Human mRNA   → DESeq2                   4 contrasts                   │
│  Rat mRNA     → limma + illuminaRatv1.db 4 contrasts                   │
│                                                                         │
│  Output per contrast: UP / DOWN gene lists (logFC > 1, FDR < 0.05)     │
└───────────────────────────────────┬─────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│  PHASE 3 — Thermodynamic Validation + Network Dynamics                  │
│                                                                         │
│  Step 0: ENSG → Gene Symbol extraction (AWK + GENCODE/Ensembl GTF)     │
│  Step 1: Harmonization (protein-coding filter + DE cross-reference)     │
│                                                                         │
│  Step 2: 4-Tool Thermodynamic Engine                                    │
│    TargetScan ──► conserved seed matches (7mer-m8 / 8mer)              │
│    RNAhybrid  ──► MFE of full duplex      (threshold: ≤ -20 kcal/mol)  │
│    RNAplfold  ──► 3'UTR local accessibility (W=80, u=8, L=40)          │
│    RNAcofold  ──► co-fold ΔG in site context (±10 nt flanking)        │
│         │                                                               │
│         └──► INTERSECTION → validated edge list (only 4/4 passing)    │
│                                                                         │
│  Step 3: Network Dynamics (igraph)                                      │
│    Build bipartite networks per disease state (Moderate/Severe/Stroke)  │
│    ► Progression comparison (Jaccard, density, alluvial, UpSet)        │
│    ► Node rewiring (Lost/Gained/Expansion/Reduction/Stable)            │
│    ► Hub quantification (degree + betweenness + eigenvector)           │
│    ► Edge strength shift (MFE distribution, Wilcoxon, Cohen's d)       │
│    ► Thermodynamic shift ΔΔG + regulatory flip detection               │
│    ► Functional enrichment (GO-BP, KEGG, Reactome)                    │
│                                                                         │
│  Species: PARALLEL human (hsa) + rat (rno) → Cross-species comparison  │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Key Conceptual Innovations

### 3.1 The "Regulatory Rigidification" Hypothesis
As ischemic injury progresses, weaker miRNA–mRNA interactions are lost (thermodynamically unstable), leaving only the strongest binders. The surviving stroke-state network is therefore more **rigid** — fewer edges, but each edge is thermodynamically entrenched.

This is quantified by comparing mean MFE distributions:
- **Moderate state**: broader MFE distribution (mixed weak/strong binders)
- **Stroke state**: narrower distribution shifted toward lower MFE (strong binders only)

### 3.2 The "Regulatory Flip" Phenomenon
Certain miRNAs switch from **weak binders** (MFE > −25) in Moderate to **strong binders** (MFE < −30) in Stroke. These represent miRNAs whose functional context is radically altered by the ischemic environment — likely due to changes in mRNA 3'UTR accessibility caused by alternative polyadenylation under hypoxic stress.

### 3.3 Cross-Species Conservation as Mechanistic Validation
Hub miRNAs and thermodynamic shifts conserved between human and rat models have passed an independent species-level replication test — providing mechanistic evidence beyond statistical significance.

---

## 4. Contrast Naming Convention

| Label | Human model | Rat model |
|-------|-------------|-----------|
| Early-phase | Moderate_vs_Control | Acute_vs_Control |
| Late-phase | Severe_vs_Control | Subacute_vs_Control |
| Phase-transition | Severe_vs_Moderate | Subacute_vs_Acute |
| Clinical composite | Stroke_vs_Control | Stroke_vs_Control |

---

## 5. Software Versions Used

| Tool | Version | Phase |
|------|---------|-------|
| STAR | 2.7.10b | P1 |
| featureCounts | 2.0.3 | P1 |
| fastp | 0.23.2 | P1 |
| miRDeep2 | 2.0.1 | P1 |
| cutadapt | 4.1 | P1 |
| DESeq2 | 1.38.0 | P2 |
| edgeR | 3.40.0 | P2 |
| limma | 3.54.0 | P2 |
| RNAhybrid | 2.1.2 | P3 |
| ViennaRNA | 2.6.2 | P3 |
| igraph (R) | 1.4.0 | P3 |
| clusterProfiler | 4.6.0 | P3 |
| GENCODE annotation | v49 (GRCh38) | P1/P3 |
| miRBase | v22.1 | P1 |
