# chi ve kw degeri yaratan kod

library(dplyr)

# Step 1: Create binary column for chi-square
combined_df <- combined_df %>%
  mutate(usage_bin = ifelse(rel_usage > 0, "used", "not_used"))

# Step 2: Run both tests per splice site
results2 <- combined_df %>%
  group_by(id_of_splicesite) %>%
  do({
    # Chi-square test (used vs not_used)
    tab <- table(.$usage_bin, .$type_of_cancer)
    chi_p <- if(all(dim(tab) > 1)) {
      chisq.test(tab, simulate.p.value = TRUE, B = 10000)$p.value
    } else {
      NA
    }
    
    # Kruskal–Wallis test (continuous rel_usage)
    kw_p <- if(length(unique(.$type_of_cancer)) > 1) {
      kruskal.test(rel_usage ~ type_of_cancer, data = .)$p.value
    } else {
      NA
    }
    
    data.frame(chi_p = chi_p, kw_p = kw_p)
  }) %>%
  ungroup() %>%
  # Step 3: Adjust p-values globally (FDR) for each test separately
  mutate(
    chi_p_adj = p.adjust(chi_p, method = "fdr"),
    kw_p_adj = p.adjust(kw_p, method = "fdr")
  )

# 0.05 filter
library(dplyr)

filtered_results <- results2 %>%
  group_by(id_of_splicesite) %>%
  filter(any((chi_p < 0.05 & chi_p_adj < 0.05) |
               (kw_p  < 0.05 & kw_p_adj  < 0.05))) %>%
  ungroup()

# Save as .tsv
write.table(filtered_results, "~/Desktop/filtered_results.tsv", 
            sep = "\t", quote = FALSE, row.names = FALSE)

# histogram of p-vals
library(ggplot2)
library(tidyr)

# Reshape data into long format
long_df <- results2 %>%
  select(kw_p, chi_p) %>%
  pivot_longer(cols = c(kw_p, chi_p), names_to = "test", values_to = "p_value")

ggplot(long_df, aes(x = p_value, fill = test)) +
  geom_histogram(binwidth = 0.02, color = "black", alpha = 0.6, position = "identity") +
  scale_x_continuous(breaks = seq(0, 1, 0.1)) +
  labs(title = "Histogram of p-values", x = "p-value", y = "Count") +
  scale_fill_manual(values = c("kw_p" = "skyblue", "chi_p" = "orange"))
