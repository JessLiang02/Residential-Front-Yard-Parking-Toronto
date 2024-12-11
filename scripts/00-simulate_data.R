#### Preamble ####
# Purpose: Simulates the residential parking dataset from the City of Toronto's Open Data Portal.
# Author: Jing Liang
# Date: 25 November 2024
# Contact: jess.liang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `Residential_Front_Yard_Parking_Etobicoke` rproj


#### Workspace setup ####
library(tidyverse)
set.seed(853)

#### Simulate dataset ####
# Probabilities for ward selection
ward_probs <- c(0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125)

# Ward names
ward_names <- c(
  "Eglinton-Lawrence", "Etobicoke-Lakeshore", "Etobicoke Centre",
  "Parkdale-High Park", "Trinity-Spadina", "York Centre",
  "York West", "York South-Weston"
)

# Parking types and their conditional probabilities for each ward
parking_types <- c("Boulevard Parking", "Front Yard", "Widened Driveway")
parking_probs_by_ward <- list(
  "Eglinton-Lawrence"     = c(0.2, 0.6, 0.2),
  "Etobicoke-Lakeshore"   = c(0.3, 0.5, 0.2),
  "Etobicoke Centre"      = c(0.4, 0.4, 0.2),
  "Parkdale-High Park"    = c(0.1, 0.7, 0.2),
  "Trinity-Spadina"       = c(0.2, 0.5, 0.3),
  "York Centre"           = c(0.3, 0.4, 0.3),
  "York West"             = c(0.25, 0.5, 0.25),
  "York South-Weston"     = c(0.35, 0.4, 0.25)
)

# Morespace values
morespace_values <- c("No", "Yes")

# Morespace conditional probabilities based on parking type
morespace_probs_by_parking <- list(
  "Boulevard Parking" = c(0.95, 0.05),
  "Front Yard"        = c(0.90, 0.10),
  "Widened Driveway"  = c(0.85, 0.15)
)

# Simulate dataset
set.seed(123)  # For reproducibility

simulated_data <- tibble(
  ward = sample(
    ward_names,
    size = 10000,
    replace = TRUE,
    prob = ward_probs
  )
) %>%
  rowwise() %>%
  mutate(
    parking_type = sample(
      parking_types,
      size = 1,
      replace = TRUE,
      prob = parking_probs_by_ward[[ward]]
    ),
    morespace = sample(
      morespace_values,
      size = 1,
      replace = TRUE,
      prob = morespace_probs_by_parking[[parking_type]]
    )
  )

# View first few rows of the simulated data
print(head(simulated_data))

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
