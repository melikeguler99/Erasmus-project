library(ggpubr)
library(dplyr)

# Get all unique splice IDs
splice_ids <- unique(combined_df$id_of_splicesite)

results <- list()

# Loop over each splice ID
for(splice in splice_ids){
  
  # Subset data for this splice
  subset_df <- combined_df %>% filter(id_of_splicesite == splice)
  
  # Check if there is more than one cancer type, otherwise t-test/Kruskal-Wallis can't be applied
  if(length(unique(subset_df$type_of_cancer)) > 1){
    
    # Perform Kruskal-Wallis test using ggpubr's stat_compare_means
    test <- tryCatch({
      stat.test <- compare_means(rel_usage ~ type_of_cancer, data = subset_df, method = "kruskal.test")
      stat.test$p
    }, error = function(e) NA)
    
    results[[splice]] <- data.frame(splice_id = splice, p_val = test)
  }
}


results_df <- do.call(rbind, results)

significant_splices <- results_df %>% filter(p_val < 0.05)
significant_splices


# Add FDR-adjusted p-values
# Make sure it's numeric
significant_splices_sorted$p_val <- as.numeric(significant_splices_sorted$p_val)

# Add FDR-adjusted p-values
significant_splices_sorted$padj <- p.adjust(significant_splices_sorted$p_val, method = "fdr")

write.table(
  significant_splices_sorted,
  "~/Desktop/splice_pvalues_fdr.tsv",  # save to Desktop
  sep = "\t",
  quote = FALSE,
  row.names = FALSE
)


# Load the file you already saved
fdr_df <- read.table("~/Desktop/splice_pvalues_fdr.tsv", 
                     header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# Take a quick look at the data
head(fdr_df)
summary(fdr_df)


# Keep only significant splice sites (padj < 0.05)
sig_splices <- subset(fdr_df, padj < 0.05)

# Check how many remain
nrow(sig_splices)
head(sig_splices)


write.table(sig_splices, 
            "~/Desktop/significant_splice_sites_FDRout.tsv", 
            sep = "\t", 
            quote = FALSE, 
            row.names = FALSE)


