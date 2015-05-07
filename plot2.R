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
png(file="plot2.png",width=480,height=480)

# Set the background for the plot to NA
# so that it is transparent
par(bg=NA)

# We create the line plot for the Global active power
# but for the moment we leave off the x-axis ticks and
# labels
plot(subset_to_plot$Date_Time,
     subset_to_plot$Global_active_power,
     type="l",
     xlab="",
     ylab="Global Active Power (kilowatts)")

dev.off()