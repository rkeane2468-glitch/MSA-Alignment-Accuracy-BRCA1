library(readxl)
library(dplyr)
library(ggplot2)

df <- read_excel("C:/Users/rkean/Downloads/MSA project/results/MSA_output_results.xlsx")

ggplot(df, aes(x = Overlap, y = d_TC, fill = Overlap)) +
  geom_boxplot(width = 0.6, outlier.size = 2) +
  scale_fill_manual(values = c("N" = "#F8766D", "Y" = "#00BFC4")) +
  theme_bw(base_size = 12) +
  labs(
    title = "Effect of Overlapping Deletions on Alignment Accuracy",
    x = "Overlap",
    y = "d_TC",
    fill = "Overlap"
  ) +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "right"
  )