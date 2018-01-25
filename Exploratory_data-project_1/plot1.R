hpc<-read.csv("household_power_consumption.txt",
              header = TRUE,sep = ";",colClasses = "character")
library(lubridate)
i <- dmy(hpc$Date) == dmy("01/02/2007") | dmy(hpc$Date) == dmy("02/02/2007")
hpc_select<-hpc[i,]
hpc_select[,3:9]<-sapply(hpc_select[,3:9],as.numeric)
date<-dmy_hms(paste(hpc_select$Date,hpc_select$Time))

hist(hpc_select$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")
dev.copy(png, file = "plot1.png")
dev.off()