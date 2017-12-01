rm(list=ls())
setwd("C:/Users/yzamriy/Documents/Tools and Methodology/DS/Git/Powerlifting/USAPL/CSV/")
#setwd("C:/Users/zamriyka/Documents/GitHub/USAPL/CSV/")

library(tidyverse)
library(ggplot2)

Raw2012Hist <- read_csv("RAW NATIONALS_lifter_history.csv")
Raw2013Hist <- read_csv("2013 Raw Nationals_lifter_history.csv")
Raw2014Hist <- read_csv("2014 Raw Nationals_lifter_history.csv")
Raw2015Hist <- read_csv("2015 Raw Nationals_lifter_history.csv")
Raw2016Hist <- read_csv("Raw Nationals 2016_lifter_history.csv")
Raw2017Hist <- read_csv("2017 Raw National Championships_lifter_history.csv")

str(Raw2012Hist)
str(Raw2013Hist)
str(Raw2014Hist)
str(Raw2015Hist)
str(Raw2016Hist)
str(Raw2017Hist)

Raw2012Hist$Placing <- as.numeric(Raw2012Hist$Placing)
Raw2013Hist$Placing <- as.numeric(Raw2013Hist$Placing)
Raw2014Hist$Placing <- as.numeric(Raw2014Hist$Placing)
Raw2015Hist$Placing <- as.numeric(Raw2015Hist$Placing)
Raw2016Hist$Placing <- as.numeric(Raw2016Hist$Placing)
Raw2017Hist$Placing <- as.numeric(Raw2017Hist$Placing)

Raw2012 <- filter(Raw2012Hist, Link == 'competitions-view?id=616')
Raw2013 <- filter(Raw2013Hist, Link == 'competitions-view?id=500')
Raw2014 <- filter(Raw2014Hist, Link == 'competitions-view?id=860')
Raw2015 <- filter(Raw2015Hist, Link == 'competitions-view?id=992')
Raw2016 <- filter(Raw2016Hist, Link == 'competitions-view?id=1354')
Raw2017 <- filter(Raw2017Hist, Link == 'competitions-view?id=1776')

Raw2012 <- Raw2012 %>% 
    mutate(Name_1 = ifelse(grepl("\\(", Name), substr(tolower(Name), 1, regexpr("\\(", Name)-2), tolower(Name)))

Raw2012 <- Raw2012 %>% 
    distinct(Name_1, Division, .keep_all = TRUE)

Raw2013 <- Raw2013 %>% 
    mutate(Name_1 = ifelse(grepl("\\ -", Name), substr(tolower(Name), 1, regexpr("\\ -", Name)-1), tolower(Name)))

Raw2013 <- Raw2013 %>% 
    distinct(Name_1, Division, .keep_all = TRUE)

table(Raw2013$Weightclass)
#-84 -83 -74 -72 -66 -63 -59 -57 -53 -52 -47 -43 
#  2  30  30  34  21  27   7  14   1  13   4   1 

Raw2013 <- mutate(Raw2013, Weightclass = as.character(Weightclass))
table(Raw2013$Weightclass)
#-43 -47 -52 -53 -57 -59 -63 -66 -72 -74 -83 -84 
#  1   4  13   1  14   7  27  21  34  30  30   2 

Raw2012 <- mutate(Raw2012,
                  Squat2 = as.numeric(Squat2),
                  Squat3 = as.numeric(Squat3),
                  `Bench press2` = as.numeric(`Bench press2`),
                  `Bench press3` = as.numeric(`Bench press3`),
                  Deadlift2 = as.numeric(Deadlift2),
                  Deadlift3 = as.numeric(Deadlift3))

Raw2013 <- mutate(Raw2013,
                  Squat2 = as.numeric(Squat2),
                  Squat3 = as.numeric(Squat3),
                  `Bench press2` = as.numeric(`Bench press2`),
                  `Bench press3` = as.numeric(`Bench press3`),
                  Deadlift2 = as.numeric(Deadlift2),
                  Deadlift3 = as.numeric(Deadlift3))

Raw2012$YOB <- as.integer(Raw2012$YOB)
Raw2013$YOB <- as.integer(Raw2013$YOB)
Raw2014$YOB <- as.integer(Raw2014$YOB)
Raw2015$YOB <- as.integer(Raw2015$YOB)

RawHist <- bind_rows("Raw2012" = Raw2012, 
                     "Raw2013" = Raw2013, 
                     "Raw2014" = Raw2014, 
                     "Raw2015" = Raw2015, 
                     "Raw2016" = Raw2016, 
                     "Raw2017" = Raw2017,
                     .id = "Meet")


open_div <- paste(c('R-O', 'R-MI', 'R-G', 'R-LW', 'R-HW', 'R-PF'), collapse = '|')
col_hs_div <- paste(c('R-C', 'R-HS', 'R-V'), collapse = '|')

RawHist <- mutate(RawHist,
                      Division_group =
                          ifelse(grepl(open_div, Division), 'Open',
                                 ifelse(grepl('R-M', Division), 'Master',
                                        ifelse(grepl('R-JR', Division), 'Junior',
                                               ifelse(grepl('R-Y', Division), 'Youth',
                                                      ifelse(grepl('R-T', Division), 'Teen',
                                                                    ifelse(grepl(col_hs_div, Division), 'CollegiateHS',
                                                                           '?')))))))

table(RawHist$Division_group)
table(RawHist$Division, RawHist$Division_group)

RawHist$Date <- as.Date(RawHist$Date, format = '%m/%d/%Y')
RawHist$Year <- format(RawHist$Date, '%Y')
table(RawHist$Date)
table(RawHist$Year)

table(RawHist$Weightclass, RawHist$Year)
# Weightclasses at Nationals were IPF

Female <- c('-43', '-47', '-52', '-57', '-63', '-72', '-84', '84+')
Male <- c('-40', '-44', '-48', '-53', '-59', '-66', '-74', '-83', '-93', '-105', '-120', '120+')

RawHist <- mutate(RawHist, Sex = ifelse(Weightclass %in% Female, 'f', 'm'))
RawHist$Sex <- factor(RawHist$Sex,
                          levels = c('f','m'),
                          labels = c("Female","Male"))
table(RawHist$Sex)

# Charts

theme_classic_yz <- 
    theme_classic() +
    theme(legend.position = "none",
          line = element_blank(),
          axis.text.y = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x = element_text(size = rel(1.2), face = "bold", color = "grey40"),
          axis.title.x = element_text(size = rel(1.5), color = "grey40"),
          strip.text = element_text(size = rel(1.2), face = "bold", color = "grey40"),
          strip.background = element_rect(color = "grey40"),
          plot.title = element_text(hjust = 0.5, size = rel(1.5), face = "bold", color = "grey40"))

g <- ggplot(data = RawHist, 
            aes(x = Year, fill = Sex)) 

g + geom_bar() +
    facet_grid(.~Sex) +
    labs(x = "Year",
         y = "Lifter Count (with duplicates across divisions)") +
    scale_fill_manual("",
                      values = c("Male" = "orange", 
                                 "Female" = "darkgreen"))  +
    geom_text(stat = "count", 
              aes(label = ..count..), 
              vjust = -0.5,
              color = "grey40",
              fontface = "bold") +
    ggtitle("Number of Lifters at USAPL Raw Nationals by Year since 2012") +
    theme_classic_yz

