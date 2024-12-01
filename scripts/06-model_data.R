#### Preamble ####
# Purpose: Creates a Bayesian logistic regression model to predict whether a residential address has more than one licensed parking space.
# Author: Jing Liang
# Date: 25 November 2024
# Contact: jess.liang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, `rstanarm`, and `arrow` packages must be installed
# Any other information needed? Make sure you are in the `Residential_Front_Yard_Parking_Etobicoke` rproj


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)

#### Read data ####
analysis_data <- read_parquet("data/02-analysis_data/analysis_data.parquet")

### Model data ####

# Fit Bayesian logistic regression model
Bayesian_logistic_model <- stan_glm(
  formula = morespace1 ~ parking_type + ward,
  data = analysis_data %>%
    mutate(morespace1 = ifelse(morespace == "Yes", 1, 0)),
  family = binomial(),
  prior = normal(location = 0, scale = 10, autoscale = TRUE), # Noninformative prior for coefficients
  prior_intercept = normal(location = 0, scale = 10, autoscale = TRUE), # Noninformative prior for intercept
  seed = 853
)

Frequentist_logistic_model <- glm(morespace1 ~ parking_type + ward, 
                                  data = analysis_data %>% mutate(morespace1 = ifelse(morespace == "Yes", 1, 0)),
                                  family="binomial")

#### Save models ####
saveRDS(
  Bayesian_logistic_model,
  file = "models/Bayesian_logistic_model.rds"
)

saveRDS(
  Frequentist_logistic_model,
  file = "models/Frequentist_logistic_model.rds"
)

### Model comparison

# Set a seed for reproducibility
set.seed(853)

# Manually split data into training (80%) and testing (20%) sets
n <- nrow(analysis_data)
train_indices <- sample(1:n, size = floor(0.8 * n))  
train_data <- analysis_data[train_indices, ] 
test_data <- analysis_data[-train_indices, ]

# Fit models on the training data
Bayesian_logistic_model <- stan_glm(
  formula = morespace1 ~ parking_type + ward,
  data = train_data %>%
    mutate(morespace1 = ifelse(morespace == "Yes", 1, 0)),
  family = binomial(),
  prior = normal(location = 0, scale = 10, autoscale = TRUE), # Noninformative prior for coefficients
  prior_intercept = normal(location = 0, scale = 10, autoscale = TRUE), # Noninformative prior for intercept
  seed = 853
)

Frequentist_logistic_model <- glm(morespace1 ~ parking_type + ward, 
                                  data = train_data %>% mutate(morespace1 = ifelse(morespace == "Yes", 1, 0)),
                                  family = "binomial")

# Assess prediction accuracy on the testing data
assess_models <- function(model, data, type = "frequentist") {
  if (type == "bayesian") {
    # Generate posterior predictions and take column means
    predictions <- posterior_predict(model, newdata = data)
    predicted_probs <- colMeans(predictions)  # Compute the mean for each observation
  } else {
    # For Frequentist model, use predict to get probabilities
    predicted_probs <- predict(model, newdata = data, type = "response")
  }
  
  # Convert probabilities to binary predictions using a 0.5 threshold
  predicted_classes <- ifelse(predicted_probs >= 0.5, 1, 0)
  
  # Extract true values
  true_classes <- ifelse(data$morespace == "Yes", 1, 0)
  
  # Ensure lengths match
  if (length(predicted_classes) != length(true_classes)) {
    stop("Mismatch in lengths of predicted_classes and true_classes")
  }
  
  # Calculate accuracy
  accuracy <- mean(predicted_classes == true_classes)
  
  return(accuracy)
}


# Test both models on the testing data
bayesian_accuracy <- assess_models(Bayesian_logistic_model, test_data, type = "bayesian")
frequentist_accuracy <- assess_models(Frequentist_logistic_model, test_data, type = "frequentist")

# Print accuracies
cat("Bayesian Model Accuracy:", bayesian_accuracy, "\n")
cat("Frequentist Model Accuracy:", frequentist_accuracy, "\n")



