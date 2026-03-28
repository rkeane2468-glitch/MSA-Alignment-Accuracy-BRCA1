library(readxl)
library(dplyr)
library(ggplot2)
library(stringr)

df <- read_excel("C:/Users/rkean/Downloads/MSA project/results/MSA_output_results.xlsx")

df <- df %>%
  mutate(
    Tool = str_trim(as.character(Tool)),
    Tool = str_squish(Tool),
    Tool = case_when(
      str_to_lower(Tool) == "mafft" ~ "Mafft",
      str_to_lower(Tool) == "muscle" ~ "Muscle",
      str_to_lower(Tool) %in% c("clustal omega", "clustalo", "clustal o") ~ "Clustal Omega",
      str_to_lower(Tool) %in% c("clustalw", "clustal w") ~ "Clustal W",
      str_to_lower(Tool) == "msaprobs" ~ "MSAProbs",
      str_to_lower(Tool) == "kalign" ~ "Kalign",
      TRUE ~ Tool))

df$Tool <- factor(df$Tool, levels = c("Clustal Omega", "Clustal W", "Kalign", "Mafft", "MSAProbs", "Muscle"))

n_method <- df %>%
  group_by(Tool) %>%
  summarise(
    n = n(),
    y_pos = max(TC, na.rm = TRUE) + 0.002,
    .groups = "drop")

p <- ggplot(df, aes(x = Tool, y = TC)) +
  geom_boxplot(fill = "lightblue", alpha = 0.6) +
  geom_jitter(width = 0.1, alpha = 0.7) +
  geom_text(
    data = n_method,
    aes(x = Tool, y = y_pos, label = paste0("n = ", n)),
    inherit.aes = FALSE,
    size = 4
  ) +
  labs(
    title = "Alignment Accuracy Across MSA Tools",
    x = "MSA Tool",
    y = "d_TC (Alignment Accuracy)"
  ) +
  theme_minimal(base_size = 14)

p
ggsave("alignment_accuracy_boxplot.png", p, width = 8, height = 5, dpi = 300)