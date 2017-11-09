rm(list=ls())
setwd("C:/Users/yzamriy/Documents/Tools and Methodology/DS/Git/Powerlifting/USAPL/CSV/")
install.packages("tidyverse")
install.packages("Hmisc")

library(tidyverse)
library(ggplot2)
library(car)
library(Hmisc)

Raw2017 <- read_csv("2017 Raw National Championships_lifter_history.csv")
head(Raw2017)
tail(Raw2017)
dim(Raw2017)
str(Raw2017)

Raw2017$Placing <- as.numeric(Raw2017$Placing)
#table(Raw2017$Placing)

Raw2017$Date <- as.Date(Raw2017$Date, format = '%m/%d/%Y')
Raw2017$Year <- format(Raw2017$Date, '%Y')
#table(Raw2017$Year)

# table(Raw2017$Weightclass)
# table(Raw2017$Division)
# table(Raw2017$Weightclass, Raw2017$Division)

Female_old <- c('-44', '-48', '90+')
Male_old <- c('-100', '-110', '-125', '125+')
Uni_old <- c('-30', '-35', '-40', '-52', '-56', '-60', '-67.5', '-75', '-82.5')

Female <- c('-43', '-47', '-52', '-57', '-63', '-72', '-84', '84+')
Male <- c('-40', '-44', '-48', '-53', '-59', '-66', '-74', '-83', '-93', '-105', '-120', '120+')

Raw2017 <- mutate(Raw2017,
                  Equipped =
                      ifelse(grepl('Equipped', Competition, ignore.case = TRUE), 1, 0),
                  Weightclass_old = 
                      ifelse(Weightclass %in% Female_old | Weightclass %in% Male_old | Weightclass %in% Uni_old, 1, 0),
                  Sex = 
                      ifelse(Weightclass %in% Female & Year == 2017 & Equipped == 0, 'f',
                      ifelse(Weightclass %in% Male & Year == 2017 & Equipped == 0, 'm', '?')))

Sex <- 
    Raw2017 %>% 
    filter(Competition == '2017 Raw National Championships') %>% 
    select(Name, Sex)

Raw2017 <- merge(Raw2017, Sex, by = 'Name')

#table(Raw2017$Sex.x, Raw2017$Sex.y)

Raw2017$Sex <- Raw2017$Sex.y
Raw2017$Sex.x <- NULL
Raw2017$Sex.y <- NULL

Raw2017$Sex <- factor(Raw2017$Sex,
                             levels = c('f','m'),
                             labels = c("Female","Male"))

open_div <- paste(c('R-O', 'R-MI', 'R-G', 'R-LW', 'R-HW', 'R-PF'), collapse = '|')
col_hs_div <- paste(c('R-C', 'R-HS', 'R-V'), collapse = '|')

Raw2017 <- mutate(Raw2017,
                  Division_group =
                      ifelse(grepl(open_div, Division), 'Open',
                             ifelse(grepl('R-M', Division), 'Master',
                                    ifelse(grepl('R-JR', Division), 'Junior',
                                           ifelse(grepl('R-Y', Division), 'Youth',
                                                  ifelse(grepl('R-T', Division), 'Teen',
                                                         ifelse(Equipped == 1, 'Equipped',
                                                                ifelse(grepl(col_hs_div, Division), 'CollegiateHS',
                                                                       '?'))))))))

# check max weights for super heavyweights
group_by(Raw2017, Weightclass) %>% 
    dplyr::summarize(maxw = max(Weight)) %>% 
    filter(grepl('\\+', Weightclass))

#1        120+ 209.75
#2        125+ 169.20
#3         84+ 168.60
#4         90+ 120.00

Raw2017 <- mutate(Raw2017,
                  CompAge = as.numeric(Year) - YOB,
                  Weightclass_Num =
                      ifelse(grepl("\\+", Weightclass), as.numeric(sub("\\+", "", Weightclass)) * 2,
                             as.numeric(sub("\\-", "", Weightclass))),
                  UnderWeight = Weightclass_Num - Weight,
                  UnderWeightPct = UnderWeight/Weightclass_Num * 100,
                  BombOut = ifelse(Total > 0 , 0, 1), 
                  Squat1Success = ifelse(Squat1 > 0 , 1, 0),
                   Squat2Success = ifelse(Squat2 > 0 , 1, 0),
                   Squat3Success = ifelse(Squat3 > 0 , 1, 0),
                   BP1Success = ifelse(`Bench press1` > 0,  1, 0),
                   BP2Success = ifelse(`Bench press2` > 0, 1, 0),
                   BP3Success = ifelse(`Bench press3` > 0, 1, 0),
                   DL1Success = ifelse(Deadlift1 > 0 , 1, 0),
                   DL2Success = ifelse(Deadlift2 > 0 , 1, 0),
                   DL3Success = ifelse(Deadlift3 > 0 , 1, 0),
                   TotalSuccess = Squat1Success + Squat2Success + Squat3Success +
                       BP1Success + BP2Success + BP3Success +
                       DL1Success + DL2Success + DL3Success,
                   SuccessRate = TotalSuccess / 9)

Raw2017 <-  
    Raw2017 %>% 
    arrange(Name, desc(Date)) %>% 
    group_by(Name) %>% 
    mutate(TotalChg = Total - lead(Total, order_by = Name),
           TotalChgPct = 100 * TotalChg / lead(Total, order_by = Name),
           PointsChg = Points - lead(Points, order_by = Name),
           PointsChgPct = 100 * PointsChg / lead(Points, order_by = Name),
           WeightChg = Weight - lead(Weight, order_by = Name),
           WeightChgPct = 100 * WeightChg / lead(Weight, order_by = Name),
           DaysSincePrevComp = as.numeric(Date - lead(Date, order_by = Name)),
           MonthsSincePrevComp = as.numeric(round(DaysSincePrevComp / 30,1)),
           TotalChgPerMonth = round(TotalChg / MonthsSincePrevComp, 1),
           TotalChgPerWeightChg = round(TotalChg / WeightChg, 1),
           PointsChgPerWeightChg = round(PointsChg / WeightChg, 1),
           CompNum = min_rank(Date))

Raw2017aggr <- 
    Raw2017 %>% 
    dplyr::group_by(Name) %>% 
    dplyr::summarize(CompCount = n(),
              FirstCompDate = min(Date),
              FirstCompAge = min(CompAge),
              MinWeight = min(Weight),
              MaxWeight = max(Weight),
              AvgMonthsSincePrevComp = as.numeric(mean(MonthsSincePrevComp, na.rm = TRUE)))

Raw2017 <- left_join(Raw2017, Raw2017aggr, by = 'Name')

Raw2017 <-
    Raw2017 %>% 
    mutate(CompAgeYrs = as.numeric(CompAge - FirstCompAge),
           CompAgeDays = as.numeric(Date - FirstCompDate))

# Creating Labels
var_labels <- c(Date = "Competition Date",
                Weight = "Lifter's Body Weight in kg",
                Total = "Total in kg",
                Points = "Wilks Points",
                Year = "Competition Year",
                Division_group = "Divisions Combined",
                CompAge = "Age During Competition",
                Weightclass_Num = "Weightclass in kg",
                UnderWeight = "Kgs under Class Weight",
                UnderWeightPct = "Percent under Class Weight",
                TotalChg = "Kg Change in Total from prev Comp",
                TotalChgPct = "Percent Change in Total from prev Comp",
                PointsChg = "Wilks Points Change from prev Comp",
                PointsChgPct = "Percent Wilks Points Change from prev Comp",
                WeightChg = "Kg Change in Lifter's Weight from prev Comp",
                WeightChgPct = "Percent Change in Lifter's Weight from prev Comp",
                TotalSuccess = "Number of Successful Attempts",
                SuccessRate = "Percent of Successful Attempts",
                BombOut = "Lifter Bombed Out",
                CompCount = "Number of Competitions",
                FirstCompDate = "Date of the first Competition",
                FirstCompAge = "Age During First Competition",
                MinWeight = "Lifter's Min Body Weight",
                MaxWeight = "Lifter's Max Body Weight",
                CompAgeYrs = "Years Competing",
                CompAgeDays = "Days Competing",
                DaysSincePrevComp = "Days Since Previous Competition",
                MonthsSincePrevComp = "Months Since Previous Competition",
                TotalChgPerMonth = "Kgs Change to Total per Month bw Competitions",
                TotalChgPerWeightChg = "Kgs Change to Total per Kg change in BW",
                PointsChgPerWeightChg = "Points Change per Kg change in BW",
                AvgMonthsSincePrevComp = "Average Number of Months bw Competitions",
                CompNum = "Competition Number")

Raw2017 <- 
    Raw2017 %>% 
    upData(labels = var_labels)

# Competitor level / Raw 2017 only

Raw2017only <- filter(Raw2017, Competition == '2017 Raw National Championships')

# EDA


Raw2017 <-  
    Raw2017 %>% 
    arrange(Name, desc(Date)) %>% 
    group_by(Name) %>% 
    mutate(CompNum = min_rank(Date))

View(group_by(Raw2017, Weightclass_Num, Weightclass) %>% 
         summarize(maxw = max(Weight)))


summary(Raw2017$CompCount)
table(Raw2017$Weightclass)


table(Raw2017$Division, Raw2017$Division_group)
table(Raw2017$Division_group)

select(Raw2017, Name, Weightclass, Sex, Sex_final) %>%
    filter(Sex == 'f' & Sex_final == 'm')

table(Raw2017$Sex, Raw2017$Year)

table(Raw2017$Division)

with(filter(Raw2017, grepl('M', Division)), 
     table(Division))

select(Raw2017, Name, Weightclass, Sex, Equipped, Weightclass_Num) %>%
    filter(Weightclass_Num == 30)

