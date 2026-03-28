library(readxl)
library(dplyr)
library(ggplot2)
library(pheatmap)

df <- read_excel("C:/Users/rkean/Downloads/MSA project/results/MSA_output_results.xlsx")

df$Dataset <- paste(df$Overlap, df$`Deletion size`, sep = "_")
heatmap_data <- df %>%
  select(`MSA Tool`, Dataset, d_TC) %>%
  tidyr::pivot_wider(names_from = Dataset, values_from = d_TC)

heatmap_matrix <- as.matrix(heatmap_data[,-1])
rownames(heatmap_matrix) <- heatmap_data$`MSA Tool`
pheatmap(heatmap_matrix,
         color = colorRampPalette(c("red","yellow","green"))(50),
         main = "MSA Tool Accuracy Heatmap")