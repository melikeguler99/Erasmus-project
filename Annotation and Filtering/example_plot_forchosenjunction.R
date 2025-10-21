library(ggpubr)

# selected junction
junction <- "1:999613-999866_(HES4)_5"
subset_df <- subset(combined_df, id_of_splicesite == junction)

# ggpubr boxplot
ggboxplot(
  data = subset_df,
  x = "type_of_cancer",
  y = "rel_usage",
  color = "type_of_cancer",     # colors as cancer type
  palette = "jco",              
  add = "jitter"                # addition of data points 
) +
  labs(
    title = paste("Distribution of Relative Usage for", junction),
    x = "Cancer Type",
    y = "Relative Usage"
  ) +
  theme_minimal(base_size = 14) # temiz tema
