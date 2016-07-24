

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

# Open graphic device PNG
png(filename = "plot1.png", width = 480, height = 480)

# Draw histogram on Global Active Power column
hist(hpc$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")

# Close graphic device PNG
dev.off()



