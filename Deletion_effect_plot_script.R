library(readxl)
library(dplyr)
library(ggplot2)

df <- read_excel("C:/Users/rkean/Downloads/MSA project/results/MSA_output_results.xlsx") %>%
  rename(
    deletion_size = `Deletion size`,
    tc = 'd_TC',
    tool ='MSA Tool',
    overlap = Overlap
  ) %>%
  mutate(
    overlap = recode(overlap,
                     "N" = "Non-overlapping",
                     "Y" = "Overlapping")
  )

summary_cond <- df %>%
  group_by(tool, overlap, deletion_size) %>%
  summarise(
    mean_dTC = mean(tc, na.rm = TRUE),
    .groups = "drop"
  )

ggplot(summary_cond,
       aes(x = deletion_size,
           y = mean_dTC,
           color = tool,
           group = tool)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  facet_wrap(~ overlap) +
  theme_bw() +
  labs(
    title = "Effect of deletion size on alignment quality",
    x = "Deletion size",
    y = "Mean d_TC",
    color = "Tool"
  )
