rm(list=ls())
setwd("C:/Users/yzamriy/Documents/Tools and Methodology/DS/Git/Powerlifting/USAPL/CSV/")
install.packages("tidyverse")

library(tidyverse)
library(ggplot2)
library(car)

Raw2017 <- read_csv("2017 Raw National Championships_lifter_history.csv")
head(Raw2017)
tail(Raw2017)
dim(Raw2017)
str(Raw2017)
