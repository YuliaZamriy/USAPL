rm(list=ls())
setwd("C:/Users/yzamriy/Documents/Tools and Methodology/DS/Powerlifting/CSV")
install.packages("tidyverse")

library(tidyverse)
library(ggplot2)
library(car)

Raw2014 <- read_csv("./USAPL/CSV/2014 Raw Nationals.csv")
Raw2015 <- read_csv("./USAPL/CSV/2015 Raw Nationals.csv")
Raw2016 <- read_csv("./USAPL/CSV/Raw Nationals 2016.csv")
Raw2017 <- read_csv("./USAPL/CSV/2017 Raw National Championships.csv")

Raw2016$Placing <- as.numeric(Raw2016$Placing)
Raw2017$Placing <- as.numeric(Raw2017$Placing)

Raw2014_2017 <- bind_rows("Raw2014" = Raw2014, 
                          "Raw2015" = Raw2015, 
                          "Raw2016" = Raw2016, 
                          "Raw2017" = Raw2017,
                          .id = "Meet")

Female <- c('-43', '-47', '-52', '-57', '-63', '-72', '-84', '84+')
Male <- c('-40', '-44', '-48', '-53', '-59', '-66', '-74', '-83', '-93', '-105', '-120', '120+')

Raw2014_2017$Sex <- 'f'
Raw2014_2017$Sex[Raw2014_2017$Weightclass %in% Male] <- 'm'
Raw2014_2017$Sex_factor <- factor(Raw2014_2017$Sex,
                                  levels = c('f','m'),
                                  labels = c("Female","Male"))

Raw2014_2017 <- subset(Raw2014_2017, Weightclass != '-40')
Raw2014_2017$Weightclass_Num <- as.numeric(Raw2014_2017$Weightclass) * -1
Raw2014_2017$Weightclass_Num[Raw2014_2017$Weightclass == '120+'] <- 125
Raw2014_2017$Weightclass_Num[Raw2014_2017$Weightclass == '84+'] <- 107 /# about average weight

Raw2014_2017$Bomb <- 1
Raw2014_2017$Bomb[Raw2014_2017$Total > 0] <- 0
Raw2014_2017$Bomb <- factor(Raw2014_2017$Bomb, 
                            levels = c(1, 0),
                            labels = c("Bombed out", "Totaled"))

fem_data14_17 <- filter(Raw2014_2017, Total > 0 & Sex == 'f')

table(fem_data14_17$Meet)

fem14_17 <- ggplot(data = fem_data14_17, aes(x = Weight, y = Points, color = Meet)) 
fem14_17 + geom_point(alpha = 0.2, size = 2) +
    scale_x_continuous(breaks = seq(40, 200, 10)) +
    scale_y_continuous(breaks = seq(100, 550, 50)) +
    geom_smooth(se = FALSE, method = "loess", lwd = 1.5) +
    xlab("Bodyweight (kg)") +
    ylab("Wilks Points") +
    ggtitle("Wilks Points distribution across female weightclasses",
            subtitle = "For USAPL Raw National Champtionships 2014-2016")

mal_data14_17 <- filter(Raw2014_2017, Total > 0 & Sex == 'm')

table(mal_data14_17$Meet)

mal14_17 <- ggplot(data = mal_data14_17, aes(x = Weight, y = Points, color = Meet)) 
mal14_17 + geom_point(alpha = 0.2, size = 2) +
    scale_x_continuous(breaks = seq(40, 200, 10)) +
    scale_y_continuous(breaks = seq(100, 550, 50)) +
    geom_smooth(se = FALSE, method = "loess", lwd = 1.5) +
    xlab("Bodyweight (kg)") +
    ylab("Wilks Points") +
    ggtitle("Wilks Points distribution across male weightclasses",
            subtitle = "For USAPL Raw National Champtionships 2014-2016")

both <- ggplot(data = Raw2014_2017, aes(x = Meet, fill = Sex_factor))
both + geom_bar(position = "dodge") +
    ylab("Total Number of Competitors") +
    scale_y_continuous(limits = c(0,700), breaks = seq(0, 700, 100)) +
    scale_fill_manual("",
                     values = c("Male" = "orange", 
                                  "Female" = "lightgreen"))  +
    geom_text(stat = "count", 
              aes(label = ..count..), 
              position = position_dodge(1),
              vjust = -0.5)

table(Raw2014_2017$Meet, Raw2014_2017$Sex_factor)
