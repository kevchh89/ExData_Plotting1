rm(list = ls())
library(lubridate)
dayss<-c(rep('Sun',24),rep('Mon',24),rep('Tue',24),rep('Wed',24),rep('Thu',24),rep('Fri',24),rep('Sat',24))
hourss<-rep(0:23,7)
dypp<-paste(dayss,hourss)
DT<-read.delim(file.choose(),sep = ";")
DT$Global_active_power<-as.numeric(DT$Global_active_power)
DT$Date<-as.Date(DT$Date)
DT$Date<-wday(DT$Date,label=T)
DT$Time<-hms(as.character(DT$Time))
DT$Time<-hour(DT$Time)
library(dplyr)
DT2<-DT %>%
  group_by(Date, Time) %>% 
  summarise_at(vars("Global_active_power"), mean)
DayHour<-paste(DT2$Date,DT2$Time)
DF<-as.data.frame(list(DH=DayHour,Kw=DT2$Global_active_power/1000))
DF$DH<-factor(DF$DH,levels = dypp)

rowloc<-c(grep('Thu',DF$DH),grep('Fri',DF$DH))

png('plot2.png',height = 480,width = 480)
{
  plot(as.numeric(DF$DH)[rowloc],DT2$Global_active_power[rowloc], type='l',xaxt='none',xlab = "",ylab = 'Global Active Power (kilowatts)')
axis(1, seq(97,145,24),las=1,labels = c('Thu','Fri','Sat'))
}
dev.off()

