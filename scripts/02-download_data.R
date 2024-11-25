#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


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
write_csv(raw_data, "data/raw_data/ttc_bus_rawdata.csv") 

#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(the_raw_data, "data/data/raw_data.csv") 

         
