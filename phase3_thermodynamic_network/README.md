# Phase 3 — Thermodynamic Validation & Network Dynamics

## Overview

This phase transforms DE gene lists into a structurally validated miRNA–mRNA regulatory
network, and then quantifies how that network rewires across disease progression.

## Module Architecture

```
Phase 2 DE Outputs
       │
       ▼
00_sequence_retrieval/     Extract ENSG → symbol mappings from GTF
       │
       ▼
01_harmonization/          Filter to protein-coding + cross-reference DE lists
       │
       ▼
02_target_prediction/      4-Tool Thermodynamic Intersection
  ├── TargetScan           Conserved seed-match prediction (position 2-8)
  ├── RNAhybrid            MFE of miRNA:3'UTR (threshold: ≤ [THRESHOLD_MFE])
  ├── RNAplfold            Local 3'UTR accessibility (optimized parameters)
  └── RNAcofold            Co-folding ΔG (miRNA + context ±10nt)
       │
       ▼  (Only interactions passing ALL 4 tools)
03_network_dynamics/       Per-state igraph network construction + analysis
  ├── 01_define_network.R        → directed bipartite graph (miRNA → mRNA)
  ├── 02_compare_progression.R   → density, Jaccard, alluvial, UpSet
  ├── 03_node_dynamics.R         → rewiring taxonomy (Lost/Gained/Expansion/Reduction/Stable)
  ├── 04_hub_quantifier.R        → degree + betweenness + eigenvector centrality
  ├── 05_edge_strength.R         → MFE distribution comparison (Wilcoxon + Cohen's d)
  ├── 06_thermo_shift.R          → ΔΔG per miRNA + regulatory flip detection
  └── 07_functional_enrichment.R → GO-BP + KEGG + Reactome (clusterProfiler)
```

## Thermodynamic Rationale

| Tool | What it measures | Threshold |
|------|-----------------|-----------|
| TargetScan | Watson-Crick seed complementarity | Canonical site types |
| RNAhybrid | Minimum Free Energy of full duplex | MFE ≤ [THRESHOLD_MFE] |
| RNAplfold | Local unpaired probability of binding site | Optimized window |
| RNAcofold | Co-folding ΔG in flanking context | ΔG < 0 (favorable) |

> **4-tool intersection**: Only interactions validated by ALL four tools enter the network.
> This produces a conservative, structurally grounded edge set.

## Key Scientific Outputs

| Analysis | Output |
|----------|--------|
| Network rewiring | `node_dynamics/Viz_B_Rewiring_ALL_LABELED.png` |
| Hub profiles | `hubs/spider_hub_{miRNA}.png` |
| Thermodynamic shift | `thermo_shift/thermo_shift_heatmap.png` |
| Regulatory flips | `thermo_shift/regulatory_flips.csv` |
| Functional pathways | `enrichment/{state}_GO_BP.png` |

## Cross-Species Design

Human (hsa) and Rat (rno) networks are constructed in parallel using identical methodology.
Conservation analysis identifies:
- **Shared hub miRNAs** → high-confidence mechanistic regulators
- **Conserved thermodynamic flips** → species-independent regulatory switches
- **Divergent rewiring patterns** → species-specific adaptive responses
