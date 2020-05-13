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
  summarise_at(vars("Sub_metering_1"), mean)
DayHour<-paste(DT2$Date,DT2$Time)
DF<-as.data.frame(list(DH=DayHour,Kw=DT2$Sub_metering_1))
DF$DH<-factor(DF$DH,levels = dypp)

rowloc<-c(grep('Thu',DF$DH),grep('Fri',DF$DH))

DT3<-DT %>%
  group_by(Date, Time) %>% 
  summarise_at(vars("Sub_metering_2"), mean)
DayHour2<-paste(DT3$Date,DT3$Time)
DF2<-as.data.frame(list(DH=DayHour2,Kw=DT3$Sub_metering_2))
DF2$DH<-factor(DF2$DH,levels = dypp)

rowloc2<-c(grep('Thu',DF$DH),grep('Fri',DF2$DH))
plot(as.numeric(DF2$DH)[rowloc2],DT3$Sub_metering_2[rowloc2], type='l',xaxt='none',xlab = "",ylab = 'Global Active Power (kilowatts)')
DT4<-DT %>%
  group_by(Date,Time) %>% 
  summarise_all(mean,na.rm=T)
DayHour3<-paste(DT4$Date,DT4$Time)
DF3<-as.data.frame(list(DH=DayHour3,Kw=DT4$Sub_metering_3))
DF3$DH<-factor(DF3$DH,levels = dypp)

rowloc3<-c(grep('Thu',DF3$DH),grep('Fri',DF3$DH))


png('plot3.png',height = 480,width = 480)
{
  plot(as.numeric(DF$DH)[rowloc],DT2$Sub_metering_1[rowloc], type='l',xaxt='none',xlab = "",ylab = 'Energy sub metering',ylim = c(1,15))
  axis(1, seq(97,145,24),las=1,labels = c('Thu','Fri','Sat'))
  lines(as.numeric(DF2$DH)[rowloc2],DT3$Sub_metering_2[rowloc2],col='red')
  lines(as.numeric(DF3$DH)[rowloc3],DT4$Sub_metering_3[rowloc3],col='blue')
  legend('topright',95,legend=c('Sub_metering_1','Sub_metering_1','Sub_metering_3'),
         col = c('black','red','blue'),lty = c(1,1,1),cex=0.5)
  
}

dev.off()



