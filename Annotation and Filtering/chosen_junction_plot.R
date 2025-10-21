library(ggplot2)

junction <- "X:67546762-67643256_(AR)_3"
subset_df <- subset(combined_df, id_of_splicesite == junction)

ggplot(subset_df, aes(x = type_of_cancer, y = rel_usage)) +
  geom_boxplot(fill = "skyblue", alpha = 0.6) +
  labs(
    title = paste("Distribution of Relative Usage for", junction),
    x = "Cancer Type",
    y = "Relative Usage"
  ) +
  theme_minimal(base_size = 14)
