library(readxl)
library(dplyr)
library(ggplot2)
library(pheatmap)

df <- read_excel("C:/Users/rkean/Downloads/MSA project/results/MSA_output_results.xlsx")

df$Condition <- paste0(
  ifelse(df$Overlap == "Y", "Overlapping", "Non-overlapping"),
  "_del",
  df$`Deletion size`
)

rank_df <- df %>%
  group_by(Condition) %>%
  mutate(rank_dTC = rank(-d_TC, ties.method = "average")) %>%
  ungroup()

summary_df <- rank_df %>%
  group_by(`MSA Tool`) %>%
  summarise(
    mean_rank = mean(rank_dTC),
    sd_rank = sd(rank_dTC),
    .groups = "drop"
  )

ggplot(summary_df, aes(x = `MSA Tool`, y = mean_rank)) +
  geom_col() +
  geom_errorbar(aes(ymin = mean_rank - sd_rank, ymax = mean_rank + sd_rank), width = 0.2) +
  theme_bw() +
  labs(
    title = "Rank-transformed alignment scores by tool",
    x = "MSA tool",
    y = "Mean rank (lower is better)"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))