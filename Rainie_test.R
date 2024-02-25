---
title: "Newest Code"
output: html_document
date: "2024-02-25"
---

```{r setup, include=FALSE}

# Load necessary libraries
library(dataRetrieval)
library(dplyr)
library(tidyr)

# Define your parameters and site numbers
startDate <- as.Date("2021-09-15")
endDate <- as.Date("2024-01-01")
sites <- c("01362295", "01362297", "0136230002") # Example site numbers
parameterCd <- c("00060", "63680") # 00060 is streamflow, 63680 is turbidity

# Retrieve the 15-minute streamflow and turbidity data for the sites
data <- readNWISuv(siteNumbers = sites, parameterCd = parameterCd, startDate, endDate, tz = "America/Jamaica")

# Convert dateTime to Date format for grouping
data$date <- as.Date(data$dateTime)

# Assuming you have already identified the correct column names and they are accurate
correct_column_name1 <- "X_.Forest.Technology.Systems.DTS.._63680_00000"
correct_column_name2 <- "X_Analite...Observator..Analite.NEP.5000.S._63680_00000"

# Calculate global means for specific columns
global_mean_Analite <- mean(data[[correct_column_name2]], na.rm = TRUE)
global_mean_Forest <- mean(data[[correct_column_name1]], na.rm = TRUE)

# Replace NA with global means for the specific columns
data[[correct_column_name2]] <- ifelse(is.na(data[[correct_column_name2]]), global_mean_Analite, data[[correct_column_name2]])
data[[correct_column_name1]] <- ifelse(is.na(data[[correct_column_name1]]), global_mean_Forest, data[[correct_column_name1]])

# Now proceed with grouping by date and replacing NA for other general columns if needed
data <- data %>%
  group_by(date) %>%
  mutate(
    X_00060_00000 = replace_na(X_00060_00000, mean(X_00060_00000, na.rm = TRUE)),
    X_63680_00000 = replace_na(X_63680_00000, mean(X_63680_00000, na.rm = TRUE))
  ) %>%
  ungroup()

# Check if there are any missing values left
sum(is.na(data$X_00060_00000))
sum(is.na(data$X_63680_00000))
sum(is.na(data[[correct_column_name2]]))
sum(is.na(data[[correct_column_name1]]))

```

