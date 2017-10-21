rm(list=ls())
setwd("C:/Users/yzamriy/Documents/Tools and Methodology/DS/Git/Powerlifting")
#install.packages("tidyverse")

library(tidyverse)
library(ggplot2)
library(car)

Raw2017 <- read_csv("./USAPL/CSV/2017 Raw National Championships.csv")
str(Raw2017)
filter(Raw2017,Name == "Yuliya Zamriy")$Wilks_coef

Female <- c('-43', '-47', '-52', '-57', '-63', '-72', '-84', '84+')
Male <- c('-40', '-44', '-48', '-53', '-59', '-66', '-74', '-83', '-93', '-105', '-120', '120+')

Raw2017$Sex <- 'f'
Raw2017$Sex[Raw2017$Weightclass %in% Male] <- 'm'

Raw2017$Sex_factor <- factor(Raw2017$Sex,
                            levels = c('f','m'),
                            labels = c("Female","Male"))

Raw2017$Weightclass_Num <- as.numeric(Raw2017$Weightclass) * -1
Raw2017$Weightclass_Num[Raw2017$Weightclass == '120+'] <- 125
Raw2017$Weightclass_Num[Raw2017$Weightclass == '84+'] <- mean(Raw2017$Weight[Raw2017$Weightclass == '84+'])

table(Raw2017$Weightclass, Raw2017$Sex)

Raw2017$Wilks_coef <- wilks_coef('f', Raw2017$Weight)
Raw2017$Wilks_coef[Raw2017$Sex == 'm'] <- wilks_coef('m', Raw2017$Weight[Raw2017$Sex=='m'])

raw <- ggplot(data = Raw2017[Raw2017$Total > 0,], aes(x = Weight, y = Points, color = Sex_factor))
raw + geom_point(alpha = 0.3, size = 3) +
    geom_smooth(method = "loess") +
    scale_x_continuous(breaks = seq(40, 200, 10)) 

fem_data <- filter(Raw2017, Total > 0 & Sex == 'f')

fem <- ggplot(data = fem_data, aes(x = Weight, y = Points, color = Weightclass))
fem + geom_point(alpha = 0.5, size = 2) +
    scale_x_continuous(breaks = seq(40, 200, 10)) +
    geom_vline(aes(xintercept = Weightclass_Num, color = Weightclass), 
               linetype = 3,
               lwd = 1) 

fem2 <- ggplot(data = fem_data, aes(x = Weight, y = Points))
fem2 + geom_point(alpha = 0.5, size = 2, color = "green") +
        scale_x_continuous(breaks = seq(40, 200, 10)) +
        geom_vline(aes(xintercept = Weightclass_Num, color = Weightclass), 
               linetype = 3,
               lwd = 1.5) +
        geom_smooth(color = "orange", method = 'loess')

fem2 + geom_point(alpha = 0.3, size = 2, color = "green") +
    scale_x_continuous(breaks = seq(40, 200, 10)) +
    scale_y_continuous(breaks = seq(150, 550, 25)) +
    geom_pointrange(aes(x = Weightclass_Num, y = Points, color = Weightclass),
                    stat = "summary",
                    fun.ymin = min,
                    fun.ymax = max,
                    fun.y = median,
                    lwd = 1) +
    xlab("Bodyweight (kg)") +
    ylab("Wilks Points") +
    ggtitle("Wilks Points distribution across female weightclasses",
            subtitle = "at Raw Nationals 2017")
    


