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

# Distribution of parking types by ward
parking_type_vs_ward <- analysis_data %>%
  group_by(ward, parking_type) %>%
  summarise(count = n(), .groups = "drop")

# Barplot: Parking Type Distribution by Ward
ggplot(parking_type_vs_ward, aes(x = ward, y = count, fill = parking_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Distribution of Parking Types by Ward",
    x = "Ward",
    y = "Count",
    fill = "Parking Type"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Proportion of morespace by parking type
morespace_parking_prop <- analysis_data %>%
  group_by(parking_type, morespace) %>%
  summarise(count = n(), .groups = "drop") %>%
  group_by(parking_type) %>%
  mutate(percentage = count / sum(count) * 100)

# Pie Chart: Morespace Proportion by Parking Type
ggplot(morespace_parking_prop, aes(x = "", y = percentage, fill = morespace)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  facet_wrap(~parking_type) +
  labs(
    title = "Proportion of Morespace by Parking Type",
    fill = "Morespace"
  ) +
  theme_minimal()

# Count of morespace by ward and parking type
morespace_ward_parking <- analysis_data %>%
  group_by(ward, parking_type, morespace) %>%
  summarise(count = n(), .groups = "drop")

# Heatmap: Count of Morespace by Ward and Parking Type
ggplot(morespace_ward_parking, aes(x = ward, y = parking_type, fill = count)) +
  geom_tile() +
  facet_wrap(~morespace) +
  scale_fill_gradient(low = "white", high = "steelblue") +
  labs(
    title = "Count of Morespace by Ward and Parking Type",
    x = "Ward",
    y = "Parking Type",
    fill = "Count"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Summary table of morespace by ward and parking type
morespace_summary_table <- analysis_data %>%
  group_by(ward, parking_type, morespace) %>%
  summarise(count = n(), .groups = "drop") %>%
  pivot_wider(names_from = morespace, values_from = count, values_fill = list(count = 0))
morespace_summary_table

