# Phase 1 — Raw Data Acquisition

## Overview

This phase downloads, processes, and quantifies raw sequencing data for all four GEO datasets used in the pipeline, producing clean count matrices ready for differential expression analysis.

## Datasets & Processing Streams

### Human mRNA (GSE202518) — RNA-seq pipeline

```
NCBI SRA
   │
   ├── 01_sra_download.sh      prefetch + fasterq-dump (retry-safe, resumable)
   │
   ├── 02_quality_trim.sh      fastp --detect_adapter_for_pe (PE auto-detect)
   │                           Output: trimmed/{SRR}_1/2.trimmed.fastq.gz
   │                           + per-sample fastp HTML/JSON QC reports
   │
   ├── 03_align_quantify.sh    STAR 2-pass mode → GRCh38 (GENCODE v49)
   │                           Output: Aligned.sortedByCoord.out.bam
   │                                   ReadsPerGene.out.tab (strand-aware)
   │
   ├── 04_feature_counts.sh    featureCounts -s 2 (reverse-strand validated)
   │                           Output: gene_counts_stranded.txt
   │
   └── 05_build_count_matrix.R Extract SRR IDs from BAM paths
                               Drop annotation columns (Chr/Start/End/Strand/Length)
                               Output: gene_counts_clean_matrix.csv  → Phase 2
```

### Human miRNA (GSE202708) — small-RNA-seq pipeline

```
NCBI SRA (small-RNA FASTQ)
   │
   ├── trim_all.sh      cutadapt   3' adapter: Illumina small-RNA (TGGAATTCTCGG...)
   │                               -m 16, -M 30, -q 20, --discard-untrimmed
   │
   ├── map_all.sh       miRDeep2 mapper.pl → Bowtie → GRCh38
   │                    Output: reads_collapsed.fa + reads_collapsed_vs_genome.arf
   │
   ├── quantify_all.sh  miRDeep2 quantifier.pl → miRBase v22.1 (hsa)
   │                    Output: miRNAs_expressed_all_samples_*.csv
   │
   ├── collapse_all.sh  Merges per-sample quantifier CSVs
   │
   └── build_count_matrix.R   Collapses duplicate mature entries (sum)
                               Outer-join across all samples
                               Output: miRNA_count_matrix.csv  → Phase 2
```

## Reference Files Required

| File | Purpose | Source |
|------|---------|--------|
| `gencode.v49.primary_assembly.annotation.gtf` | STAR + featureCounts annotation | [GENCODE v49](https://www.gencodegenes.org/human/release_49.html) |
| `GRCh38.primary_assembly.genome.fa` | STAR genome index | GENCODE |
| `GRCh38_bowtie_index/` | Bowtie index for miRDeep2 | Built from above |
| `mature_hsa.fa` | miRBase v22.1 mature sequences | [miRBase](https://www.mirbase.org/) |
| `hairpin_hsa.fa` | miRBase v22.1 hairpin sequences | miRBase |

## Key Design Decisions

- **Stranded mode (`-s 2`)**: Confirmed via RSeQC `infer_experiment.py` on pilot samples before setting featureCounts strandedness.
- **STAR 2-pass mode**: Enables novel splice junction detection critical for stroke-altered splicing patterns.
- **miRDeep2 vs other quantifiers**: Provides both expression quantification AND novel miRNA discovery — future-proofing for novel regulatory candidates.
- **cutadapt over Trimmomatic for small-RNA**: More aggressive 3' adapter trimming essential for accurate seed-sequence preservation in 18–24 nt reads.

## Outputs → Phase 2

| File | Used by |
|------|---------|
| `gene_counts_clean_matrix.csv` | Phase 2 — `human_mrna/01_de_deseq2.R` |
| `miRNA_count_matrix.csv` | Phase 2 — `human_mirna/01_filter_counts.R` |
