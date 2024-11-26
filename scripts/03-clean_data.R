#### Preamble ####
# Purpose: Cleans the raw dataset obtained from the City of Toronto's Open Data Portal.
# Author: Jing Liang
# Date: 25 November 2024
# Contact: jess.liang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `arrow`, `janitor`, `tidyverse` packages must be installed
# Any other information needed? Make sure you are in the `Residential_Front_Yard_Parking_Etobicoke` rproj

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)

#### Clean data ####
raw_data <- read_csv("data/01-raw_data/raw_data.csv")

cleaned_data <-
  raw_data %>%
  janitor::clean_names() %>%
  select(licensed_spaces, parking_type, ward) %>%
  filter(licensed_spaces >= 1) %>%
  mutate(morespace = ifelse(licensed_spaces > 1, 1, 0)) %>%
  select(-licensed_spaces) %>%
  mutate(
    ward_name = case_when(
      ward %in% c(31, 32) ~ "Beaches-East York",
      ward %in% c(17, 18) ~ "Davenport",
      ward %in% c(33, 34) ~ "Don Valley East",
      ward %in% c(25, 26) ~ "Don Valley West",
      ward %in% c(15, 16) ~ "Eglinton-Lawrence",
      ward %in% c(3, 4) ~ "Etobicoke Centre",
      ward %in% c(1, 2) ~ "Etobicoke North",
      ward %in% c(5, 6) ~ "Etobicoke-Lakeshore",
      ward %in% c(13, 14) ~ "Parkdale-High Park",
      ward %in% c(39, 40) ~ "Scarborough Agincourt",
      ward %in% c(37, 38) ~ "Scarborough Centre",
      ward %in% c(43, 44) ~ "Scarborough East",
      ward %in% c(35, 36) ~ "Scarborough Southwest",
      ward %in% c(41, 42) ~ "Scarborough-Rouge River",
      ward %in% c(21, 22) ~ "St. Paul's",
      ward %in% c(27, 28) ~ "Toronto Centre-Rosedale",
      ward %in% c(29, 30) ~ "Toronto-Danforth",
      ward %in% c(19, 20) ~ "Trinity-Spadina",
      ward %in% c(23, 24) ~ "Willowdale",
      ward %in% c(9, 10) ~ "York Centre",
      ward %in% c(11, 12) ~ "York South-Weston",
      ward %in% c(7, 8) ~ "York West",
      TRUE ~ "Unknown"
    )
  ) %>%
  select(-ward) %>%
  rename(ward = ward_name) %>%
  tidyr::drop_na()


analysis_data <- cleaned_data %>%
  count(ward) %>%
  filter(n > 100) %>%
  inner_join(cleaned_data, by = "ward") %>%
  select(-n) %>%
  mutate(morespace = ifelse(morespace == 1, "Yes", "No"))

#### Save data ####
write_parquet(analysis_data, "data/02-analysis_data/analysis_data.parquet")
