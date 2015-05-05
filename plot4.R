library(graphics)
library(lubridate)

# Read the full dataset into memory
dat <- read.table('household_power_consumption.txt', header=TRUE, sep=";", na.strings="?")

# Use lubridate to convert the Date column from factor to date objects
dat$Date <- dmy(dat$Date)

# We need data from two dates: 2007-02-01 and 2007-02-02
day1 <- ymd("2007-02-01")
day2 <- ymd("2007-02-02")

# Take the subset corresponding to these two days and remove the 
# full table since it is not needed.
subset_to_plot <- subset(dat, Date == day1 | Date == day2)
rm(dat)

# Specify the PNG file and its size
png(file="plot4.png",width=480,height=480)

# Set the background for the plot to NA
# so that it is transparent
par(bg=NA, mfrow=c(2,2))

################
#  Plot 1
################
# We create the line plot for the Global active power
# but for the moment we leave off the x-axis ticks and
# labels
plot(subset_to_plot$Global_active_power,
     type="l",
     xaxt='n',
     xlab="",
     ylab="Global Active Power")

# For labelling the x-axis we need the abbreviated weekdays
# for our two dates plus the next day that marks the end of
# the data
day3 <- ymd("2007-02-03")
x_labels <- c(weekdays(day1, abbreviate=TRUE),
              weekdays(day2, abbreviate=TRUE),
              weekdays(day3, abbreviate=TRUE))

# The x-ticks are set at the start of each day.
# Obviously, day1 starts at the 1st measurement,
# day2 starts 1 measurement after the length of
# day1 and the day3 tick will be the first after 
# the complete dataset.
x_ticks <- c(1,
             sum(subset_to_plot$Date == day1)+1,
             length(subset_to_plot$Date)+1)

# To create our custom x-axis labels, we use the axis
# command with our ticks and labels
axis(1, at=x_ticks, labels=x_labels)

################
#  Plot 2
################
# We create the line plot for the Voltage as a function of
# time but for the moment we leave off the x-axis ticks 
plot(subset_to_plot$Voltage,
     type="l",
     xaxt='n',
     xlim=c(1,nrow(subset_to_plot)),
     ylim=c(min(subset_to_plot$Voltage),max(subset_to_plot$Voltage)),
     xlab="datetime",
     ylab="Voltage")

# For the x-axis we can reuse the ticks and labels
# created in Plot 1
axis(1, at=x_ticks, labels=x_labels)

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

# To start we create a blank plot that will hold our 
# 3 lines with just the limits for the x and y axes
# and a label for the y axis.
plot(0,
     type="n",
     xlim=c(1,nrow(subset_to_plot)),
     ylim=c(0,max_y),
     xaxt='n',
     xlab="",
     ylab="Energy sub metering")

colors <- c("black","red", "blue")
# Next we add a line for each 
for (i in seq_along(columns)) { 
  lines(subset_to_plot[columns[i]], col=colors[i], type="l")
}

# We create the legend in the top right corner with the vector 
# 'columns' that holds the column names and the vector 'colors'
# that has our list of colors for the lines
legend("topright",
       bty = "n",
       columns, 
       lty=c(1,1), 
       col=colors)

# Again for the x-axis we can reuse the ticks and labels
# created with Plot 1
axis(1, at=x_ticks, labels=x_labels)

################
#  Plot 4
################
# The last plot is a line plot of Global reactive power
# as a function of time
plot(subset_to_plot$Global_reactive_power,
     type="l",
     xaxt='n',
     ylim=c(0,max(subset_to_plot$Global_reactive_power)),
     xlab="datetime",
     ylab="Global_reactive_power")

# For the x-axis we can reuse the ticks and labels
# created in Plot 1
axis(1, at=x_ticks, labels=x_labels)

dev.off()