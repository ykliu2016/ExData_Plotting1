

# set working directory to the folder where run_analysis.R is 
# wdir <- dirname(sys.frame(1)$ofile)  # Please note this line only works if the script is sourced as a whole.
# setwd(wdir)

wdir <- "/Users/kurtliu/Documents/Data Scientiest_Course/Exploratory Analysis" 
setwd(wdir)


# If the dataset hasn't been downloaded and unzipped, it will be downloaded and unzipped now to the working directory
if (!file.exists(file.path(wdir, "./Dataset.zip"))) {
        fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileurl, destfile = './Dataset.zip', method="curl")
        unzip("./Dataset.zip", exdir = "./")
}

# Check readyness of data file
if (!file.exists(file.path(wdir, "./household_power_consumption.txt"))) stop("Data is not ready.")

# read the two days (1/2/2007 ~ 2/2/2007) and the columns names
cols <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?", nrows = 1)
hpc <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", skip = 66637, nrows = 2880)
names(hpc) <- names(cols)

hpc$dt <- strptime(paste(hpc$Date, hpc$Time), "%d/%m/%Y %H:%M:%S")
hpc$Date <- as.Date(hpc$Date, "%d/%m/%Y")
hpc$Day <- strftime(hpc$Date, "%a")
hpc$x <- as.numeric(hpc$dt - strptime("1/2/2007 00:00:00", "%d/%m/%Y %H:%M:%S"))/60

xlabel <- c(unique(hpc$Day), strftime(max(hpc$Date) + 1, "%a"))
sub_metering <- list(hpc$Sub_metering_1, hpc$Sub_metering_2, hpc$Sub_metering_3)
list_colors <- c("black", "red", "blue") 



# Open graphic device PNG
png(filename = "plot4.png", width = 480, height = 480)

# Set parameters for a 2x2 matrix on canvas
par(mfcol = c(2, 2))

# Chart 1 
# Draw line chart on Global Active Power column and time series column x (in minutes)
plot(hpc$x, hpc$Global_active_power, type="n", xaxt = "n", xlab = "", ylab = "Global Active Power (kilowatts)")
# Customise X axis to show week days
axis(1, at=c(0, 1440, 2880), labels = xlabel)

# Draw line for Global_active_power
lines(hpc$x, hpc$Global_active_power, type="l")


# Chart 2
# Draw line charts for energy sub metering vs. time series (in minutes)
plot(hpc$x, hpc$Sub_metering_1, type="n", xaxt = "n", xlab = "", ylab = "Energy Sub Metering")
# Customise X axis
axis(1, at=c(0, 1440, 2880), labels = xlabel)

# Draw lines with different sub meterings with different columns
for (i in 1:3) {
        lines(hpc$x, sub_metering[[i]], type = "l", col = list_colors[i])
}

# Add legend
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = list_colors, lty = c(1, 1, 1))

# Chart 3
# Draw line chart on Voltage column and time series column x (in minutes)
plot(hpc$x, hpc$Voltage, type="n", xaxt = "n", xlab = "datetime", ylab = "Voltage")
# Customise X axis to show week days
axis(1, at=c(0, 1440, 2880), labels = xlabel)

# Draw line for Voltage
lines(hpc$x, hpc$Voltage, type="l")


# Chart 4
# Draw line chart on Global_reactive_power column and time series column x (in minutes)
plot(hpc$x, hpc$Global_reactive_power, type="n", xaxt = "n", xlab = "datetime", ylab = "Global_reactive_power")
# Customise X axis to show week days
axis(1, at=c(0, 1440, 2880), labels = xlabel)

# Draw line for Global_reactive_power
lines(hpc$x, hpc$Global_reactive_power, type="l")



# Close graphic device PNG
dev.off()



