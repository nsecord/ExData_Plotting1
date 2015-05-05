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
png(file="plot1.png",width=480,height=480)

# Set the background for the plot to NA
# so that it is transparent
par(bg=NA)

# Plot a histogram of Global Active Power
plot1 <- hist(subset_to_plot$Global_active_power, 
              col="red", nclass = 20, 
              main="Global Active Power", 
              xlab="Global Active Power (kilowatts)")
dev.off()