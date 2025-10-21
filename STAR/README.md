In common short read sequencing, the DNA insert (original molecule to be sequenced) is downstream from the read primer, meaning that the 5' adapters will not appear in the sequenced read. But, if the fragment is shorter than the number of bases sequenced, one will sequence into the 3' adapter. To make it clear: In Illumina sequencing, adapter sequences will only occur at the 3' end of the read and only if the DNA insert is shorter than the number of sequencing cycles.

This problem has been eliminated with ***Trim-galore!**.

See: https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/

Output files were aligned with the STAR.The resulting ***SJ.out.tab*** files were selected and filed according to the disease.

SJ.out.tab contains high confidence collapsed splice junctions in tab-delimited format. Note that  
STAR defines the junction start/end as intronic bases, while many other software define them as  
exonic bases. The columns have the following meaning:  
column 1: chromosome  
column 2: first base of the intron (1-based)  
column 3: last base of the intron (1-based)  
column 4: strand (0: undefined, 1: +, 2: -)  
column 5: intron motif: 0: non-canonical; 1: GT/AG, 2: CT/AC, 3: GC/AG, 4: CT/GC, 5: AT/AC, 6: GT/AT  
column 6: 0: unannotated, 1: annotated (only if splice junctions database is used)  
column 7: number of unique mapping reads crossing the junction  
**column 8: number of multi-mapping reads crossing the junction**  
column 9: maximum spliced ​​alignment overhang  
The filtering for this output file is controlled by the --outSJfilter* parameters, as described in  
Section 14.16. Output Filtering: Splice Junctions.


Using the 8th column, the relative read numbers of the isoforms were found.


