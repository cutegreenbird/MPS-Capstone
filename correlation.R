---
title: "Correlation"
output: html_document
date: "2024-02-25"
---

```{r setup, include=FALSE}

# Load necessary libraries
library(dataRetrieval)
library(dplyr)
library(ggplot2)

# Define parameters and site numbers for data retrieval
startDate <- as.Date("2023-04-01")
endDate <- as.Date("2023-12-30")
sites <- "01362295" # Update this with your actual site number
parameterCd <- "63680" # Turbidity code

# Retrieve the 15-minute turbidity data for the site
data_upstream <- readNWISuv(siteNumbers = sites, parameterCd = parameterCd, startDate = startDate, endDate = endDate, tz = "America/Jamaica")

# Assuming turbidity values have been extracted as follows
# For April: Rows 1 to 2879, For December: Rows 23246 to 26124
turbidity_april <- data_upstream$X_63680_00000[1:2879]
turbidity_december <- data_upstream$X_63680_00000[23246:26124]

# Prepare the data for plotting
combined_data <- data.frame(
  Turbidity = c(turbidity_april, turbidity_december),
  Month = factor(c(rep("April", length(turbidity_april)), rep("December", length(turbidity_december)))),
  Day = c(1:length(turbidity_april), 1:length(turbidity_december))
)

# Calculate the correlation between April and December turbidity values
correlation_coefficient <- cor(turbidity_april, turbidity_december, use = "complete.obs")

# Prepare the data for plotting as before
combined_data <- data.frame(
  Turbidity = c(turbidity_april, turbidity_december),
  Month = factor(c(rep("April", length(turbidity_april)), rep("December", length(turbidity_december)))),
  Day = c(1:length(turbidity_april), 1:length(turbidity_december))
)

# Plotting with annotation of the correlation coefficient
ggplot(combined_data, aes(x = Day, y = Turbidity, color = Month)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  scale_x_continuous(name = "Day", breaks = seq(0, max(combined_data$Day), by = 5), 
                     limits = c(1, max(combined_data$Day))) +
  scale_y_continuous(name = "Turbidity") +
  labs(title = paste("Turbidity Comparison: April vs December | Correlation:", round(correlation_coefficient, 3)), color = "Month") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  annotate("text", x = Inf, y = Inf, label = paste("Correlation:", round(correlation_coefficient, 3)), 
           hjust = 1.1, vjust = 2, size = 5, color = "black")

```
