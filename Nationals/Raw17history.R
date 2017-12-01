rm(list=ls())
#setwd("C:/Users/yzamriy/Documents/Tools and Methodology/DS/Git/Powerlifting/USAPL/CSV/")
#setwd("C:/Users/zamriyka/Documents/GitHub/USAPL/CSV/")

install.packages("tidyverse")
install.packages("Hmisc")

library(tidyverse)
library(ggplot2)
library(car)
#library(Hmisc)

Raw2017Hist <- read_csv("2017 Raw National Championships_lifter_history.csv")
#head(Raw2017Hist)
#tail(Raw2017Hist)
#dim(Raw2017Hist)
#str(Raw2017Hist)

Raw2017Hist$Placing <- as.numeric(Raw2017Hist$Placing)
#table(Raw2017Hist$Placing)

Raw2017Hist$Date <- as.Date(Raw2017Hist$Date, format = '%m/%d/%Y')
Raw2017Hist$Year <- format(Raw2017Hist$Date, '%Y')
#table(Raw2017Hist$Year)

# table(Raw2017Hist$Weightclass)
# table(Raw2017Hist$Division)
# table(Raw2017Hist$Weightclass, Raw2017Hist$Division)

# Female_old <- c('-44', '-48', '90+')
# Male_old <- c('-100', '-110', '-125', '125+')
# Uni_old <- c('-30', '-35', '-40', '-52', '-56', '-60', '-67.5', '-75', '-82.5')

Female <- c('-43', '-47', '-52', '-57', '-63', '-72', '-84', '84+')
Male <- c('-40', '-44', '-48', '-53', '-59', '-66', '-74', '-83', '-93', '-105', '-120', '120+')

pushpull <- paste(c('Bench', 'Deadlift', 'Push', 'Pull'), collapse = '|')

Raw2017Hist <- mutate(Raw2017Hist,
                  Equipped =
                      ifelse(grepl('Equipped', Competition, ignore.case = TRUE), 1, 0),
                  PushPullComp =
                      ifelse(grepl(pushpull, Competition, ignore.case = TRUE), 1, 0),
                  FullRawComp = 1 - Equipped - PushPullComp,
                  #Weightclass_old = 
                  #    ifelse(Weightclass %in% Female_old | Weightclass %in% Male_old | Weightclass %in% Uni_old, 1, 0),
                  Sex = 
                      ifelse(Weightclass %in% Female & Year == 2017 & Equipped == 0, 'f',
                      ifelse(Weightclass %in% Male & Year == 2017 & Equipped == 0, 'm', '?')))

#table(Raw2017Hist$Equipped)
#table(Raw2017Hist$PushPullComp)
#table(Raw2017Hist$FullRawComp)
#View(with(filter(Raw2017Hist, PushPullComp == 1), 
#     table(Competition)))

Sex <- 
    Raw2017Hist %>% 
    filter(Competition == '2017 Raw National Championships') %>% 
    select(Name, Sex)

Raw2017Hist <- 
  Raw2017Hist %>% 
  left_join(Sex, by = 'Name')

#table(Raw2017Hist$Sex.x, Raw2017Hist$Sex.y)

Raw2017Hist$Sex <- Raw2017Hist$Sex.y
Raw2017Hist$Sex.x <- NULL
Raw2017Hist$Sex.y <- NULL

Raw2017Hist$Sex <- factor(Raw2017Hist$Sex,
                             levels = c('f','m'),
                             labels = c("Female","Male"))

open_div <- paste(c('R-O', 'R-MI', 'R-G', 'R-LW', 'R-HW', 'R-PF'), collapse = '|')
col_hs_div <- paste(c('R-C', 'R-HS', 'R-V'), collapse = '|')

Raw2017Hist <- mutate(Raw2017Hist,
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
group_by(Raw2017Hist, Weightclass) %>% 
    dplyr::summarize(maxw = max(Weight)) %>% 
    filter(grepl('\\+', Weightclass))

#1        120+ 209.75
#2        125+ 169.20
#3         84+ 168.60
#4         90+ 120.00

Raw2017Hist <- mutate(Raw2017Hist,
                  CompAge = as.numeric(Year) - YOB,
                  Weightclass_Num =
                      ifelse(grepl("\\+", Weightclass), as.numeric(sub("\\+", "", Weightclass)) * 2,
                             as.numeric(sub("\\-", "", Weightclass))),
                  UnderWeight = Weightclass_Num - Weight,
                  UnderWeightPct = UnderWeight/Weightclass_Num * 100,
                  BombOut = ifelse(Total > 0 , 0, 1), 
                  Squat1Success = ifelse(Squat1 <= 0 | is.na(Squat1), 0, 1),
                  Squat2Success = ifelse(Squat2 <= 0 | is.na(Squat2), 0, 1),
                  Squat3Success = ifelse(Squat3 <= 0 | is.na(Squat3), 0, 1),
                  BP1Success = ifelse(`Bench press1` <= 0 | is.na(`Bench press1`), 0, 1),
                  BP2Success = ifelse(`Bench press2` <= 0 | is.na(`Bench press2`), 0, 1),
                  BP3Success = ifelse(`Bench press3` <= 0 | is.na(`Bench press3`), 0, 1),
                  DL1Success = ifelse(Deadlift1 <= 0 | is.na(Deadlift1), 0, 1),
                  DL2Success = ifelse(Deadlift2 <= 0 | is.na(Deadlift2), 0, 1),
                  DL3Success = ifelse(Deadlift3 <= 0 | is.na(Deadlift3), 0, 1),
                  SquatSuccess = Squat1Success + Squat2Success + Squat3Success,
                  BPSuccess = BP1Success + BP2Success + BP3Success,
                  DLSuccess = DL1Success + DL2Success + DL3Success,
                  TotalSuccess = SquatSuccess + BPSuccess + DLSuccess,
                  SuccessRate = TotalSuccess / 9,
                  NumOfAttemptsNA = ifelse(is.na(Squat1), 1, 0) + 
                    ifelse(is.na(Squat2), 1, 0) +
                    ifelse(is.na(Squat3), 1, 0) +
                    ifelse(is.na(`Bench press1`), 1, 0) +
                    ifelse(is.na(`Bench press2`), 1, 0) +
                    ifelse(is.na(`Bench press3`), 1, 0) +
                    ifelse(is.na(Deadlift1), 1, 0) +
                    ifelse(is.na(Deadlift2), 1, 0) +
                    ifelse(is.na(Deadlift3), 1, 0),
                  SquatBest = ifelse(SquatSuccess > 0, pmax(Squat1, Squat2, Squat3), 0),
                  BPBest = ifelse(BPSuccess > 0, pmax(`Bench press1`, `Bench press2`, `Bench press3`), 0),
                  DLBest = ifelse(DLSuccess > 0, pmax(Deadlift1, Deadlift2, Deadlift3), 0),
                  SquatShr = ifelse(Total > 0, SquatBest / Total, 0),
                  BPShr = ifelse(Total > 0, BPBest / Total, 0),
                  DLShr = ifelse(Total > 0, DLBest / Total, 0),
                  Squat1to3 = ifelse(SquatSuccess > 0, abs(Squat1/Squat3), 0),
                  BP1to3 = ifelse(BPSuccess > 0, abs(`Bench press1`/`Bench press3`), 0),
                  DL1to3 = ifelse(DLSuccess > 0, abs(Deadlift1/Deadlift3), 0))
                  
# CompExl <-
#   Raw2017Hist %>% 
#   filter(PushPullComp == 1) %>% 
#   group_by(Competition) %>% 
#   summarize(attna = min(NumOfAttemptsNA)) %>% 
#   mutate(PushPullCompExcl = ifelse(attna > 3, 1, 0))
# Raw2017Hist <- 
#   Raw2017Hist %>% 
#   left_join(select(CompExl, Competition, PushPullCompExcl), by = 'Competition')


Raw2017Hist <-  
    Raw2017Hist %>% 
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

Raw2017Histaggr <- 
    Raw2017Hist %>% 
    group_by(Name) %>% 
    summarize(CompCount = n(),
              FirstCompDate = min(Date),
              FirstCompAge = min(CompAge),
              MinWeight = min(Weight),
              MaxWeight = max(Weight),
              AvgMonthsSincePrevComp = as.numeric(mean(MonthsSincePrevComp, na.rm = TRUE)))

Raw2017Hist <- left_join(Raw2017Hist, Raw2017Histaggr, by = 'Name')

Raw2017Hist <-
    Raw2017Hist %>% 
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

Raw2017Hist <- 
    Raw2017Hist %>% 
    Hmisc::upData(labels = var_labels)

# Competitor level / Raw 2017 only

Raw2017only <- filter(Raw2017Hist, Competition == '2017 Raw National Championships')

# EDA


# Raw2017Hist <-  
#     Raw2017Hist %>% 
#     arrange(Name, desc(Date)) %>% 
#     group_by(Name) %>% 
#     mutate(CompNum = min_rank(Date))

View(group_by(Raw2017Hist, Weightclass_Num, Weightclass) %>% 
         summarize(maxw = max(Weight)))


summary(Raw2017Hist$CompCount)
table(Raw2017Hist$Weightclass)


table(Raw2017Hist$Division, Raw2017Hist$Division_group)
table(Raw2017Hist$Division_group)

select(Raw2017Hist, Name, Weightclass, Sex, Sex_final) %>%
    filter(Sex == 'f' & Sex_final == 'm')

table(Raw2017Hist$Sex, Raw2017Hist$Year)

table(Raw2017Hist$Division)

with(filter(Raw2017Hist, grepl('Pull', Competition)), 
     table(Competition))

select(Raw2017Hist, Name, Weightclass, Sex, Equipped, Weightclass_Num) %>%
    filter(Weightclass_Num == 30)

