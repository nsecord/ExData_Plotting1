library(graphics)
library(lubridate)

# Read the full dataset into memory
dat <- read.table('household_power_consumption.txt', header=TRUE, sep=";", na.strings="?")

# Take the subset corresponding to these two days and remove the 
# full table since it is not needed.
subset_to_plot <- subset(dat, Date == "1/2/2007" | Date == "2/2/2007")
rm(dat)

# Paste together dates and times and convert to a single POSIXct variable
# using the lubridate function dmy_hms()
dates_times <- paste(subset_to_plot$Date,subset_to_plot$Time)
subset_to_plot$Date_Time <- dmy_hms(dates_times)

# Specify the PNG file and its size
png(file="plot4.png",width=480,height=480)

# Set the background for the plot to NA
# so that it is transparent
par(bg=NA, mfrow=c(2,2))

################
#  Plot 1
################
# We create the line plot for the Global active power
plot(subset_to_plot$Date_Time,
     subset_to_plot$Global_active_power,
     type="l",
     xlab="",
     ylab="Global Active Power (kilowatts)")

################
#  Plot 2
################
# We create the line plot for the Voltage as a function of
# time but for the moment we leave off the x-axis ticks 
plot(subset_to_plot$Date_Time,
     subset_to_plot$Voltage,
     type="l",
     xlab="datetime",
     ylab="Voltage")

################
#  Plot 3
################
# For this plot, we need the columns corresponding to the 
# 3 sub metering measurements.  We can get the names of 
# columns using grep
columns <- names(subset_to_plot)[grep("Sub_metering", names(subset_to_plot))]

# To set the y axis limits we need to know the maximum value in
# the 3 series
max_y <- max(subset_to_plot[columns])

# Define the set of colors we will use for plotting the lines
colors <- c("black","red", "blue")

# To start we create a plot with a line for the first element
# in our list of columns.  We also defin
plot(subset_to_plot$Date_Time, 
     subset_to_plot[[columns[1]]],
     type="l",
     col=colors[1],
     ylim=c(0,max_y),
     xlab="",
     ylab="Energy sub metering")

# For the remaining elements, we overlay the lines on
# top of the existing plot
for (i in 2:length(columns)) {
  lines(subset_to_plot$Date_Time,
        subset_to_plot[[columns[i]]], 
        col=colors[i], 
        type="l")
}

# Create the legend with the column names and colors
# previously defined
legend("topright",
       bty = "n",
       columns, 
       lty=c(1,1), 
       col=colors)

################
#  Plot 4
################
# The last plot is a line plot of Global reactive power
# as a function of time
plot(subset_to_plot$Date_Time,
     subset_to_plot$Global_reactive_power,
     type="l",
     ylim=c(0,max(subset_to_plot$Global_reactive_power)),
     xlab="datetime",
     ylab="Global_reactive_power")

dev.off()