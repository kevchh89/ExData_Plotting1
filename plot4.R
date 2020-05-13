library(lubridate)
DT<-read.delim(file.choose(),sep = ";")
DT$Global_intensity <- as.Date(DT$Date, format="%d/%m/%Y")
DT$Global_active_power <- as.numeric(DT$Global_active_power)
DT$Global_reactive_power <- as.numeric(DT$Global_reactive_power)
DT$Voltage <- as.numeric(DT$Voltage)
DT$Global_intensity <- as.numeric(DT$Global_intensity)
DT$Sub_metering_1 <- as.numeric(DT$Sub_metering_1)
DT$Sub_metering_2 <- as.numeric(DT$Sub_metering_2)
DT$Sub_metering_3 <- as.numeric(DT$Sub_metering_3)
DT2<-subset(DT, Global_intensity == "2007-02-01" | Date =="2007-02-02")
FullTimeDate <- paste(DT2$Date, DT2$Time, sep=" ")
FullTimeDate<-dmy_hms(FullTimeDate)
DT3 <- cbind(DT2, FullTimeDate)

png('plot4.png',height = 480,width = 480)



par(mfrow=c(2,2),mar=c(4,4,2,2))
{
  ### 1
  plot(as.numeric(DT3$FullTimeDate),DT3$Global_active_power, 
       type='l',xaxt='none',xlab = "",ylab = 'Global Active Power')
  axis(1, seq(min(as.numeric(DT3$FullTimeDate)),max(as.numeric(DT3$FullTimeDate)),43200),las=1,labels = c('Thu','Fri'))
  ### 2
  plot(as.numeric(DT3$FullTimeDate),DT3$Voltage, 
       type='l',xaxt='none',xlab = "datetime",ylab = 'Voltage')
  axis(1, seq(min(as.numeric(DT3$FullTimeDate)),max(as.numeric(DT3$FullTimeDate)),43200),las=1,labels = c('Thu','Fri'))
  ### 3
  plot(as.numeric(DT3$FullTimeDate),DT3$Sub_metering_1, type='l',xaxt='none',xlab = "",
       ylab = 'Energy sub metering',ylim = c(1,50))
  axis(1, seq(min(as.numeric(DT3$FullTimeDate)),max(as.numeric(DT3$FullTimeDate)),43200),las=1,labels = c('Thu','Fri'))
  lines(as.numeric(DT3$FullTimeDate),DT3$Sub_metering_2,col='red')
  lines(as.numeric(DT3$FullTimeDate),DT3$Sub_metering_3,col='blue')
  legend('topright',95,legend=c('Sub_metering_1','Sub_metering_1','Sub_metering_3'),
         col = c('black','red','blue'),lty = c(1,1,1),cex=0.2)
  ### 4
  plot(as.numeric(DT3$FullTimeDate),DT3$Global_reactive_power, 
       type='l',xaxt='none',xlab = "datetime",
       ylab = 'Global Reactive Power')
  axis(1, seq(min(as.numeric(DT3$FullTimeDate)),max(as.numeric(DT3$FullTimeDate)),43200),las=1,labels = c('Thu','Fri'))
}

dev.off()



