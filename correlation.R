

```{r}
library(dataRetrieval)
data1 <- readNWISdv("01362297","00060")
readNWISpCode("all")

# Load packages

library(dataRetrieval)
library(dplyr)



# Set up parameter codes and dates

startDate <- as.Date("2021-09-15")

endDate <- as.Date("2024-01-01")

sites <- c("01362295", "01362297", "0136230002") # 01362295 is Panther Kill upstream of project site, 01362297 is Panther Kill downstream of project site, and 0136230002 is Woodland Creek

parameterCd <-  c("00060", "63680") # 00060 is streamflow, 63680 is turbidity

###upstream project site###

# Retrieve the 15-minute streamflow and turbidity data for the 3 sites

data <- readNWISuv(siteNumbers = sites, parameterCd, startDate, endDate, tz = "America/Jamaica")
View(data)
###upstream###

startDate <- as.Date("2021-09-15")

endDate <- as.Date("2024-01-01")

sites <- c( "01362295") # 01362295 is Panther Kill upstream of project site, 01362297 is Panther Kill downstream of project site, and 0136230002 is Woodland Creek

parameterCd <-   c("63680") # 00060 is streamflow, 63680 is turbidity



# Retrieve the 15-minute streamflow and turbidity data for the 3 sites

data_upstream <- readNWISuv(siteNumbers = sites, parameterCd, startDate, endDate, tz = "America/Jamaica")
View(data_upstream)

# unique(data_downstream$X_63680_00000_cd)
# unique(data_downstream$X_63680_00000)
# data_upstream$X_63680_00000

# Assuming you have a data table named 'my_data_table' and you want to count missing values in the 'my_column' column
my_column <- "X_63680_00000"
missing_rows_count <- sum(is.na(data_upstream[[my_column]]))
missing_rows_count*100/nrow(data_upstream)


###downstream###
startDate <- as.Date("2021-09-15")

endDate <- as.Date("2024-01-01")

sites <- c( "01362297") # 01362295 is Panther Kill upstream of project site, 01362297 is Panther Kill downstream of project site, and 0136230002 is Woodland Creek

parameterCd <-   c("00060", "63680") # 00060 is streamflow, 63680 is turbidity



# Retrieve the 15-minute streamflow and turbidity data for the 3 sites

data_downstream <- readNWISuv(siteNumbers = sites, parameterCd, startDate, endDate, tz = "America/Jamaica")
View(data_downstream)

unique(data_downstream$X_63680_00000_cd)
unique(data_downstream$X_63680_00000)
#data_upstream$X_63680_00000

# Assuming you have a data table named 'my_data_table' and you want to count missing values in the 'my_column' column
my_column <- "X_00060_00000"
missing_rows_count <- sum(is.na(data_downstream[[my_column]]))
missing_rows_count*100/nrow(data_downstream)

#data_upstream$X_63680_00000

# Assuming you have a data table named 'my_data_table' and you want to count missing values in the 'my_column' column
my_column <- "X_63680_00000"
missing_rows_count <- sum(is.na(data_downstream[[my_column]]))
missing_rows_count*100/nrow(data_downstream)
missing_values <- data_downstream[is.na(data_downstream[["X_63680_00000"]]), ]
View(missing_values)

####

# Assuming you have a data frame named 'my_data_frame' and the time column is 'time_column'
missing_values$Date <- as.Date(missing_values$dateTime)

frequency_table <- table(missing_values$Date)

# Print the result
View(frequency_table)

##########################################################

###April and December###

# Assuming you have a data frame named 'my_data_frame' and a time column named 'time_column'
#missing_values$Date <- as.Date(my_data_frame$time_column)

# Specify the time period you're interested in
start_date <- as.Date("2022-04-01")
end_date <- as.Date("2022-05-01")

# Use logical indexing to filter rows within the specified time period
filtered_data <- missing_values[missing_values$Date >= start_date & missing_values$Date <= end_date, ]

# Print the resulting subset
View(filtered_data)


# Assuming you have a data frame named 'my_data_frame' and the time column is 'time_column'
#missing_values$Date <- as.Date(missing_values$dateTime)

frequency_table_april_streamflow <- table(filtered_data$Date)

# Print the result
View(frequency_table_april_streamflow)


####december

# Assuming you have a data frame named 'my_data_frame' and a time column named 'time_column'
#missing_values$Date <- as.Date(my_data_frame$time_column)

# Specify the time period you're interested in
start_date <- as.Date("2023-12-01")
end_date <- as.Date("2024-01-01")

# Use logical indexing to filter rows within the specified time period
filtered_data_dec <- missing_values[missing_values$Date >= start_date & missing_values$Date <= end_date, ]

# Print the resulting subset
View(filtered_data_dec)


# Assuming you have a data frame named 'my_data_frame' and the time column is 'time_column'
#missing_values$Date <- as.Date(missing_values$dateTime)

frequency_table_dec_streamflow <- table(filtered_data_dec$Date)

# Print the result
View(frequency_table_dec_streamflow)

##April data has more missing data than december for storms 
#############################################################################
data_downstream$Date <- as.Date(data_downstream$dateTime)
fequency_table_all <- table(data_downstream$Date)
View(fequency_table_all)

## missing values - mean values 
## check if the missing values are actually peak values 
## check if the missing time slot is associated with highest 'streamflow' value during the storm periods.
## median values 
## threshold 0 - 15 minute - 96 observations 95/96


# Load necessary libraries
library(dataRetrieval)
library(dplyr)
package.install("ggplot2")
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