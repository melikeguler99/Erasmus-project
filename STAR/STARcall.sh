#!/bin/bash

# Directory with trimmed FASTQ files
FASTQ_DIR=~/trimmed_fastq
# Output directory for STAR results
OUT_DIR=~/star_results

mkdir -p "$OUT_DIR"  # create output folder if it doesn't exist

# Loop over all trimmed FASTQ files
for R1file in "$FASTQ_DIR"/*_R1_001_trimmed.fq.gz; do
    # Skip if no files match
    [[ -e "$R1file" ]] || continue

    # Extract sample name from filename
    sample=$(basename "$R1file")
    sample=${sample%%_R1_001_trimmed.fq.gz}

    echo "Processing sample $sample ..."

    STAR --runThreadN 10 \
         --readFilesCommand zcat \
         --genomeDir /scr/k80san2/berni/Melike/STARidx \
         --outFileNamePrefix "$OUT_DIR/${sample}_" \
         --readFilesIn "$R1file"
done

