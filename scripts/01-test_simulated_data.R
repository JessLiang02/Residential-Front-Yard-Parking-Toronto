#### Preamble ####
# Purpose: Test the simulated dataset.
# Author: Jing Liang
# Date: 25 November 2024
# Contact: jess.liang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, `testthat` packages must be installed
# Any other information needed? Make sure you are in the `Residential_Front_Yard_Parking_Etobicoke` rproj



#### Workspace setup ####
library(tidyverse)
library(testthat)

simulated_data <- read_csv("data/00-simulated_data/simulated_data.csv")

#### Test data ####
# Test 1: Check that all ward names are valid
test_that("All ward names are valid", {
  valid_ward_names <- c(
    "Eglinton-Lawrence", "Etobicoke-Lakeshore", "Etobicoke Centre",
    "Parkdale-High Park", "Trinity-Spadina", "York Centre",
    "York West", "York South-Weston"
  )
  expect_true(all(simulated_data$ward %in% valid_ward_names))
})

# Test 2: Check that morespace contains only binary values ("No" or "Yes")
test_that("Morespace column is binary (No or Yes)", {
  expect_true(all(simulated_data$morespace %in% c("No", "Yes")))
})

# Test 3: Check that parking types are limited to the expected 3 types
test_that("Parking types are valid", {
  valid_parking_types <- c("Boulevard Parking", "Front Yard", "Widened Driveway")
  expect_true(all(simulated_data$parking_type %in% valid_parking_types))
})

# Test 4: Check that the dataset has exactly 10,000 rows
test_that("Dataset has 10,000 rows", {
  expect_equal(nrow(simulated_data), 10000)
})

# Test 5: Check that there are no missing values in the dataset
test_that("No missing values in ward, parking_type, or morespace columns", {
  expect_false(any(is.na(simulated_data$ward)))
  expect_false(any(is.na(simulated_data$parking_type)))
  expect_false(any(is.na(simulated_data$morespace)))
})

