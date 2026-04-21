<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&pause=900&color=2EC4B6&background=FFFFFF00&center=true&vCenter=true&width=600&lines=Welcome+to+IS_mi-mrna_thermo_validation_network+%F0%9F%A7%AC;Precision+Ischemic+Stroke+Bioinformatics;Thermodynamic+Interaction+Mapping..." alt="Animated Welcome Banner" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Research_Skeleton-orange?style=for-the-badge&logo=googlescholar" alt="Research Status" />
  <img src="https://img.shields.io/badge/Focus-Ischemic_Stroke-blue?style=for-the-badge&logo=brain" alt="Focus Area" />
  <img src="https://img.shields.io/badge/Workflow-4--Tool_Thermodynamics-brightgreen?style=for-the-badge&logo=databricks" alt="Workflow" />
</p>

---

<div align="center">
  <h2>⚡ IS_mi-mrna_thermo_validation_network ⚡</h2>
  <sub>Validation of known miRNA–mRNA regulatory states in Ischemic Stroke via thermodynamic stability, seed duplex formation, and structural accessibility filtering.</sub>
</div>

---

## 📋 Research Methodology Reference
This repository contains the **computational engineering skeleton** developed for a dissertation study on **Ischemic Stroke regulatory dynamics**. 

> [!IMPORTANT]
> **Methodological Reference:** To protect ongoing biological discoveries and proprietary findings, specific biological thresholds and filtering constants have been masked (e.g., [THRESHOLD_MFE]). However, the **operational logic**, **infrastructure**, and **file-handling architectures** are fully preserved as a technical showcase.

---

> [!CAUTION]
> **STRICT INTELLECTUAL PROPERTY NOTICE & NON-REPLICATION DIRECTIVE**
>
> This repository displays a proprietary scientific architecture and methodological framework. **Unauthorized replication, imitation, or derivative utilization of the specific scientific concepts, hierarchical logic, or pipeline architectures contained herein is strictly prohibited.**
>
> Any attempt to reconstruct this logic or present these specific conceptual workflows as independent or original work will be considered a direct violation of international academic integrity, ethical research standards, and copyright laws. This repository serves as a **closed-reference technical portfolio demonstration only**; the methodology, prior art, and algorithmic hierarchies displayed are the exclusive intellectual property of **Vidit Zainith**.

---

## 📁 Pipeline Architecture (Mermaid)

```mermaid
graph TD
    %% --- CONFERENCE-GRADE STYLE DEFINITIONS ---
    classDef stage0 fill:#b2182b,stroke:#000,stroke-width:2px,color:#fff
    classDef stage1 fill:#1F1F1F,stroke:#000,stroke-width:3px,color:#fff
    classDef stage2 fill:#613CBC,stroke:#000,stroke-width:2px,color:#fff
    classDef stage3 fill:#007ACC,stroke:#000,stroke-width:2px,color:#fff
    classDef stage4 fill:#D65D0E,stroke:#000,stroke-width:3px,color:#fff
    classDef stage5 fill:#15803D,stroke:#000,stroke-width:3px,color:#fff
    classDef stage6 fill:#225ea8,stroke:#000,stroke-width:2px,color:#fff

    %% --- WORKFLOW NODES ---
    subgraph S0 ["I. MULTI-ENGINE DIFFERENTIAL EXPRESSION"]
        A0["<b>Input: Count Matrices / Raw Arrays</b><br/>(Human hsa & Rat rno models)"]:::stage0
        A0 --> A1["<b>Engine Processing</b><br/>(edgeR · DESeq2 · limma)"]:::stage0
        A1 --> A2["<b>Significance Gate</b><br/>(Filtered logFC & FDR Thresholds)"]:::stage0
    end

    subgraph S1 ["II. TRANSCRIPTOMIC HARMONIZATION"]
        A2 --> B1["<b>Genomic Retrieval</b><br/>(ENSG/ENSRNOG Extraction)"]:::stage2
        A2 --> B2["<b>ID Standardization</b><br/>(Annotation Mapping)"]:::stage2
        A2 --> B3["<b>Seed Backbone</b><br/>(TargetScan Architecture)"]:::stage2
    end

    subgraph S2 ["III. INTERACTION FILTERING"]
        B1 & B2 & B3 --> D["<b>Transcriptome-TargetScan Alignment</b><br/>(CWCS++ Score Filter < -X.XX)"]:::stage3
    end

    subgraph S3 ["IV. THERMODYNAMIC VALIDATION"]
        direction TB
        D --> E1["<b>Global Hybridization</b><br/>RNAhybrid </br>(MFE ≤ [THRESHOLD])<br/>"]:::stage4
        D --> E2["<b>Co-Folding Stability</b><br/>RNAcofold </br>(Minimum Energy Opt)<br/>"]:::stage4
        D --> E3["<b>Local Accessibility</b><br/>RNAplfold </br>(Probability Thresholds)<br/>"]:::stage4
    end

    subgraph S4 ["V. REGULATORY NETWORK CONSTRUCTION"]
        E1 & E2 & E3 --> F["<b>Logic Gate Consensus</b><br/>(Four-Tier Validation Intersection)"]:::stage5
        F --> G[("<b>High-Confidence Regulatory<br/>Networks (Validated Edges)</b>")]:::stage5
    end

    subgraph S5 ["VI. NETWORK DYNAMICS & EVOLUTION"]
        direction TB
        G --> H1["<b>Centrality Topology</b><br/>(Hub Quantification: Degree/Betweenness)"]:::stage6
        G --> H2["<b>Graph Rewiring Metrics</b><br/>(Jaccard Distance · Alluvial Flux)"]:::stage6
        G --> H3["<b>Thermodynamic Flip Analysis</b><br/>(ΔΔG Distribution Shift · Rigidification)"]:::stage6
        G --> H4["<b>Functional Convergence</b><br/>(GO / KEGG / Reactome Enrichment)"]:::stage6
    end

    %% --- LAYOUT HINTS ---
    linkStyle default stroke:#333,stroke-width:2.5px
```

---

## 📁 Repository Structure

```text
IS_mi-mrna_thermo_validation_network/
│
├── phase1_data_acquisition/          ← Raw data ingest (FASTQ → count matrices)
├── phase2_differential_expression/   ← Multi-engine DE analysis (edgeR, DESeq2, limma)
├── phase3_thermodynamic_network/     ← Thermodynamic validation + network analysis
├── orchestration/                    ← Master pipeline launcher (run_all_phases.sh)
├── examples/                         ← Synthetic data for demonstration
└── README.md
```

- [`phase1_data_acquisition/`](./phase1_data_acquisition/) — SRA tools, STAR, and miRDeep2 quantification workflows.
- [`phase2_differential_expression/`](./phase2_differential_expression/) — Robust multi-platform DE framework for RNA-seq and Microarray.
- [`phase3_thermodynamic_network/`](./phase3_thermodynamic_network/) — The core thermodynamic engine integrating 4 sequence-structure tools.

---

## 💡 Why Thermodynamic Validation?

This framework solves the **"Target Specificity Problem"** in miRNA analysis by moving beyond simple seed matches. By intersecting four structural tools—TargetScan, RNAhybrid, RNAplfold, and RNAcofold—it captures the **regulatory entropy loss** occurring during the transition from healthy to ischemic states.

### Key Contributions
| Feature | Detail |
|---------|--------|
| **Multi-engine DE** | edgeR (miRNA-seq) · DESeq2 (RNA-seq) · limma (microarray) |
| **4-tool thermodynamics** | RNAhybrid (MFE ≤ [THRESHOLD_MFE]) · RNAplfold · RNAcofold · TargetScan |
| **Cross-species validation** | Human (hsa) + Rat (rno) parallel networks |
| **Network rigidity metric** | Degree rewiring quantification across progression states |
| **Regulatory flip detection** | miRNAs switching binding affinity class across states |

---

## 🛠️ Technologies & Research Arsenal

![R](https://img.shields.io/badge/R-DESeq2%20|%20edgeR%20|%20limma-276DC3?style=flat-square&logo=r)
![Python](https://img.shields.io/badge/Python-BioPython%20|%20Pandas-FFD43B?style=flat-square&logo=python)
![Bash](https://img.shields.io/badge/Shell-Automation-4EAA25?style=flat-square&logo=gnubash)
![Bioinformatics](https://img.shields.io/badge/Tools-miRDeep2%20|%20STAR%20|%20ViennaRNA-red?style=flat-square)

---

## 📜 Intellectual Property & Legal Notice

- **Research Status:** Manuscript in Communication / Proprietary Clinical Methodology.
- **OWNER:** **Vidit Zainith ([@VampZie](https://github.com/VampZie))** served as the **Principal Computational Architect and Bug-Resolution Lead** for the implementation and optimization of these multi-omics modules.
- **Portfolio Disclaimer:** This repository is curated exclusively for **Professional Portfolio Demonstration**. The methodologies, skeleton-logics, and algorithmic architectures represent prioritized research assets of the owner **Vidit Zainith ([@VampZie](https://github.com/VampZie))**.
- **Legal Enforcement:** Unauthorized replication, commercial redistribution, or derivative utilization of the proprietary logic structures contained herein without explicit written authorization is strictly prohibited. Any infringement of Intellectual Property Rights (IPR) will be addressed through formal legal channels in accordance with international copyright and academic integrity laws.
- **Temporal Attribution (Prior Art):** This repository was published and archived on this platform as of **April 21, 2026**. This timestamp serves as public, immutable evidence of methodological authorship and prior art for all internal architectures displayed.

---

<div align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&pause=2000&color=F37335&background=FFFFFF00&center=true&vCenter=true&lines=Prior+Art+Archived:+2026-04-21+%F0%9F%9B%A1%EF%B8%8F" alt="IPR Protective Banner" />
</div>

---

<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&pause=2000&color=F37335&background=FFFFFF00&center=true&vCenter=true&lines=All+Systems+Operational!+%F0%9F%AB%A7" alt="Happy Analyzing Banner" />
</p>
