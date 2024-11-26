#### Preamble ####
# Purpose: Downloads the raw dataset from the City of Toronto's Open Data Portal.
# Author: Jing Liang
# Date: 25 November 2024
# Contact: jess.liang@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `opendatatoronto, `tidyverse` packages must be installed
# Any other information needed? Make sure you are in the `Residential_Front_Yard_Parking_Etobicoke` rproj


#### Workspace setup ####
library(opendatatoronto)
library(tidyverse)

#### Download data ####
# Conduct a search for available data files that are related to the theme
data_packages <- search_packages("Residential Front Yard Parking")
# Retreive all the resources available within the data files
data_resources <- data_packages %>%
  list_package_resources()
# Retrieve the second resource (the .csv file)  and save it as a dataframe
raw_data <- data_resources[2,] %>%
  get_resource()

#### Save data ####
write_csv(raw_data, "data/01-raw_data/raw_data.csv") 

         
