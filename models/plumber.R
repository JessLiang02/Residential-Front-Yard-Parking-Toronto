library(plumber)
library(rstanarm)
library(tidyverse)

# Load the model
model <- readRDS("logistic_model.rds")

# Define the model version
version_number <- "0.0.1"

# Define the variables
variables <- list(
  parking_type = "The type of residential parking, character value. Choose from Boulevard Parking, Front Yard, Widened Driveway",
  ward = "The ward in the city of Toronto, character value. Choose from Eglinton-Lawrence Etobicoke-Lakeshore, 
  Etobicoke Centre, Parkdale-High Park, Trinity-Spadina, York Centre, York South-Weston, York West"
)

#* @param parking_type 
#* @param ward 
#* @get /predict_morespace
predict_morespace <- function(parking_type = "Front Yard", ward = "Etobicoke-Lakeshore") {
  # Convert inputs to appropriate types
  parking_type <- as.character(parking_type)
  ward <- as.character(ward)
  
  # Prepare the payload as a data frame
  payload <- data.frame(
    parking_type = parking_type,
    ward = ward
  )
  
  # Extract posterior samples
  posterior_samples <- as.matrix(model)  # Convert to matrix for easier manipulation
  
  # Define the generative process for prediction
  beta1 <- posterior_samples[, "parking_typeFront Yard"]
  beta2 <- posterior_samples[, "parking_typeWidened Driveway"]
  beta3 <- posterior_samples[, "wardEtobicoke-Lakeshore"]
  beta4 <- posterior_samples[, "wardEtobicoke Centre"]
  beta5 <- posterior_samples[, "wardParkdale-High Park"]
  beta6 <- posterior_samples[, "wardTrinity-Spadina"]
  beta7 <- posterior_samples[, "wardYork Centre"]
  beta8 <- posterior_samples[, "wardYork South-Weston"]
  beta9 <- posterior_samples[, "wardYork West"]
  alpha <- posterior_samples[, "(Intercept)"]
  
  # Compute the predicted value for the observation
  predicted_values <- alpha +
    beta1 * ifelse(payload$parking_type == "Front Yard", 1, 0) +
    beta2 * ifelse(payload$parking_type == "Widened Driveway", 1, 0) +
    beta3 * ifelse(payload$ward == "Etobicoke-Lakeshore", 1, 0) +
    beta4 * ifelse(payload$ward == "Etobicoke Centre", 1, 0) +
    beta5 * ifelse(payload$ward == "Parkdale-High Park", 1, 0) +
    beta6 * ifelse(payload$ward == "Trinity-Spadina", 1, 0) +
    beta7 * ifelse(payload$ward == "York Centre", 1, 0) +
    beta8 * ifelse(payload$ward == "York South-Weston", 1, 0) +
    beta9 * ifelse(payload$ward == "York West", 1, 0) 
  
  # Predict
  predicted_probs <- exp(predicted_values)/(1+exp(predicted_values))
  mean_predicted_probs <- mean(predicted_probs)
  mean_prediction <- ifelse(mean_predicted_probs > 0.5, "Yes", "No")
  
  # Store results
  result <- list(
    "Predicted to have more than 1 parking space:" = mean_prediction
  )
  
  return(result)
}
