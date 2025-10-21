(ggsashimi_env) melike@pulque:~/ggsashimi/examples$ #!/bin/bash

# Input files
bam_tsv="merged_bams.tsv"
annotation="annotation.gtf"
palette="palette.txt"
regions_file="positions_collapsed_extended.csv"

# Output folder
mkdir -p sashimi_plots

# Loop over CSV lines (skip header)
tail -n +2 "$regions_file" | while IFS=, read -r chr gene start end; do
    region="${chr}:${start}-${end}"
    output_file="sashimi_plots/${gene}_${chr}_${start}-${end}.pdf"

    echo "Plotting $gene ($region)..."

    ../ggsashimi.py -b "$bam_tsv" \
        -c "$region" \
        -g "$annotation" \
        -C 3 -O 3 --shrink --alpha 0.25 \
        --base-size=20 --ann-height=4 --height=3 --width=18 \
        -P "$palette" \
echo "All plots generated in sashimi_plots/"
