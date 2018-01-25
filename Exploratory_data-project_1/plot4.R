hpc<-read.csv("household_power_consumption.txt",
              header = TRUE,sep = ";",colClasses = "character")
library(lubridate)
i <- dmy(hpc$Date) == dmy("01/02/2007") | dmy(hpc$Date) == dmy("02/02/2007")
hpc_select<-hpc[i,]
hpc_select[,3:9]<-sapply(hpc_select[,3:9],as.numeric)
date<-dmy_hms(paste(hpc_select$Date,hpc_select$Time))

par(mfrow= c(2,2))
plot(date,hpc_select$Global_active_power, type = "l",
      xlab="", ylab="Global Active Power (kilowatts)")
plot(date,hpc_select$Voltage, type = "l",
      xlab="datetime", ylab="Voltage")
plot(date,hpc_select$Sub_metering_1,type="l", col="black",xlab = "", 
      ylab = "Energy sub metering")
lines(date,hpc_select$Sub_metering_2,col="red")
lines(date,hpc_select$Sub_metering_3,col="blue")
legend("topright", col = c("black","red","blue"),
        lty = 1,legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty = "n")
plot(date,hpc_select$Global_reactive_power, type = "l",
      xlab="datetime", ylab="Global_reactive_power")
dev.copy(png, file = "plot4.png")
dev.off()