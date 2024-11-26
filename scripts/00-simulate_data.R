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

ward_probs <- c(0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125)
parking_probs <- c(0.25, 0.5, 0.25)
morespace_probs <- c(0.95, 0.05)

ward_names <- c(
  "Eglinton-Lawrence", "Etobicoke-Lakeshore", "Etobicoke Centre",
  "Parkdale-High Park", "Trinity-Spadina", "York Centre",
  "York West", "York South-Weston"
)
parking_types <- c("Boulevard Parking", "Front Yard", "Widened Driveway")
morespace_values <- c("No", "Yes")

# Simulate dataset
simulated_data <- tibble(
  ward = sample(
    ward_names,
    size = 10000,
    replace = TRUE,
    prob = ward_probs
  ),
  parking_type = sample(
    parking_types,
    size = 10000,
    replace = TRUE,
    prob = parking_probs
  ),
  morespace = sample(
    morespace_values,
    size = 10000,
    replace = TRUE,
    prob = morespace_probs
  )
)

#### Save data ####
write_csv(simulated_data, "data/00-simulated_data/simulated_data.csv")
