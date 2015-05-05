library(graphics)
library(lubridate)

# Read the full dataset into memory
dat <- read.table('household_power_consumption.txt', header=TRUE, sep=";")

# Use lubridate to convert the Date column from factor to date objects
dat$Date <- dmy(dat$Date)

# We need data from two dates: 2007-02-01 and 2007-02-02
day1 <- ymd("2007-02-01")
day2 <- ymd("2007-02-02")

# Take the subset corresponding to these two days and remove the 
# full table since it is not needed.
subset_to_plot <- subset(dat, Date == day1 | Date == day2)
rm(dat)

# Convert the Global Active Power column to numeric
subset_to_plot$Global_active_power <- as.numeric(as.character(subset_to_plot$Global_active_power))

# Specify the PNG file and its size
png(file="plot2.png",width=480,height=480)

# Set the background for the plot to NA
# so that it is transparent
par(bg=NA)

# We create the line plot for the Global active power
# but for the moment we leave off the x-axis ticks and
# labels
plot(subset_to_plot$Global_active_power,
     type="l",
     xaxt='n',
     xlab="",
     ylab="Global Active Power (kilowatts)")

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

dev.off()