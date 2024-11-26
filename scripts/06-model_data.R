#### Preamble ####
# Purpose: Creates a Bayesian logistic regression model to predict whether a residential address has more than one licensed parking space.
# Author: Jing Liang
# Date: 25 November 2024
# Contact: jess.liang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, `rstanarm` packages must be installed
# Any other information needed? Make sure you are in the `Residential_Front_Yard_Parking_Etobicoke` rproj


#### Workspace setup ####
library(tidyverse)
library(rstanarm)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

### Model data ####

# Fit Bayesian logistic regression model
logistic_model <- stan_glm(
  formula = morespace1 ~ parking_type + ward,
  data = analysis_data %>%
    mutate(morespace1 = ifelse(morespace == "Yes", 1, 0)),
  family = binomial(),
  prior = normal(location = 0, scale = 10, autoscale = TRUE), # Noninformative prior for coefficients
  prior_intercept = normal(location = 0, scale = 10, autoscale = TRUE), # Noninformative prior for intercept
  seed = 853
)

#### Save model ####
saveRDS(
  logistic_model,
  file = "models/logistic_model.rds"
)
