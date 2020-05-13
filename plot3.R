rm(list = ls())
library(lubridate)
dayss<-c(rep('Sun',24),rep('Mon',24),rep('Tue',24),rep('Wed',24),rep('Thu',24),rep('Fri',24),rep('Sat',24))
hourss<-rep(0:23,7)
dypp<-paste(dayss,hourss)
DT<-read.delim(file.choose(),sep = ";")
DT$Sub_metering_1<-as.numeric(DT$Sub_metering_1)
DT$Sub_metering_2<-as.numeric(DT$Sub_metering_2)
DT$Sub_metering_3<-as.numeric(DT$Sub_metering_3)
DT$Date<-as.Date(DT$Date)

DT$Date<-wday(DT$Date,label=T)
DT$Time<-hms(as.character(DT$Time))
DT$Time<-hour(DT$Time)
library(dplyr)
DT2<-DT %>%
  group_by(Date, Time) %>% 
  summarise_all(mean,na.rm=T)
DayHour<-paste(DT2$Date,DT2$Time)
DF<-as.data.frame(list(DH=DayHour,GAP=DT2$Global_active_power,
                       GRP=DT2$Global_reactive_power,VOL=DT2$Voltage,SM1=DT2$Sub_metering_1,
                       SM2=DT2$Sub_metering_2,SM3=DT2$Sub_metering_3))
DF$DH<-factor(DF$DH,levels = dypp)

rowloc<-c(grep('Thu',DF$DH),grep('Fri',DF$DH))
par(mfrow=c(2,2))


png('plot3.png',height = 480,width = 480)
{
  plot(as.numeric(DF$DH)[rowloc],DT2$Sub_metering_1[rowloc], type='l',xaxt='none',xlab = "",
       ylab = 'Energy sub metering',ylim = c(1,50))
  axis(1, seq(97,145,24),las=1,labels = c('Thu','Fri','Sat'))
  lines(as.numeric(DF$DH)[rowloc],DT$Sub_metering_2[rowloc],col='red')
  lines(as.numeric(DF$DH)[rowloc],DT$Sub_metering_3[rowloc],col='blue')
  legend('topright',95,legend=c('Sub_metering_1','Sub_metering_1','Sub_metering_3'),
         col = c('black','red','blue'),lty = c(1,1,1),cex=0.6)
}

dev.off()



