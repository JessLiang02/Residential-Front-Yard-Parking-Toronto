#### Preamble ####
# Purpose: Conduct exploratory data analysis on the analysis data.
# Author: Jing Liang
# Date: 25 November 2024
# Contact: jess.liang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `Residential_Front_Yard_Parking_Etobicoke` rproj


#### Workspace setup ####
library(tidyverse)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

### EDA ####

# Summarize morespace percentages by ward
morespace_vs_ward <- analysis_data %>%
  group_by(ward, morespace) %>%
  summarise(count = n(), .groups = "drop") %>%
  mutate(percentage = count / sum(count) * 100)

# Barplot: Morespace (%) vs. Ward
ggplot(morespace_vs_ward, aes(x = ward, y = percentage, fill = factor(morespace))) +
  geom_bar(stat = "identity", position = "fill") +
  labs(
    title = "More space (>2 parking spaces) vs. Ward",
    x = "Ward",
    y = "Percentage (%)",
    fill = "Morespace"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Summarize morespace percentages by parking type
morespace_vs_parking <- analysis_data %>%
  group_by(parking_type, morespace) %>%
  summarise(count = n(), .groups = "drop") %>%
  mutate(percentage = count / sum(count) * 100)

# Barplot: Morespace (%) vs. Parking Type
ggplot(morespace_vs_parking, aes(x = parking_type, y = percentage, fill = factor(morespace))) +
  geom_bar(stat = "identity", position = "fill") +
  labs(
    title = "More space (>2 parking spaces) vs. Parking Type",
    x = "Parking Type",
    y = "Percentage (%)",
    fill = "Morespace"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
