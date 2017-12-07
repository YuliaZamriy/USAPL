rm(list=ls())
#setwd("C:/Users/yzamriy/Documents/Tools and Methodology/DS/Git/Powerlifting/USAPL/CSV/")
#setwd("C:/Users/zamriyka/Documents/GitHub/USAPL/CSV/")

library(tidyverse)
library(ggplot2)
#install.packages("cowplot")
require(cowplot)
library(gridExtra)
library(grid)

Raw2012Hist <- read_csv("./CSV/RAW NATIONALS_lifter_history.csv")
Raw2013Hist <- read_csv("./CSV/2013 Raw Nationals_lifter_history.csv")
Raw2014Hist <- read_csv("./CSV/2014 Raw Nationals_lifter_history.csv")
Raw2015Hist <- read_csv("./CSV/2015 Raw Nationals_lifter_history.csv")
Raw2016Hist <- read_csv("./CSV/Raw Nationals 2016_lifter_history.csv")
Raw2017Hist <- read_csv("./CSV/2017 Raw National Championships_lifter_history.csv")

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

rm(list = c("Raw2012Hist", "Raw2012",
            "Raw2013Hist", "Raw2013", 
            "Raw2014Hist", "Raw2014", 
            "Raw2015Hist", "Raw2015",
            "Raw2016Hist", "Raw2016", 
            "Raw2017Hist", "Raw2017"))

open_div <- paste(c('R-O', 'R-MI', 'R-G', 'R-LW', 'R-HW', 'R-PF'), collapse = '|')
col_hs_div <- paste(c('R-C', 'R-HS', 'R-V'), collapse = '|')
col_hs_y_div <- paste(c('R-C', 'R-HS', 'R-V', 'R-Y'), collapse = '|')

RawHist <- mutate(RawHist,
                      Division_group =
                          ifelse(grepl(open_div, Division), 'Open',
                                 ifelse(grepl('R-M', Division), 'Master',
                                        ifelse(grepl('R-JR', Division), 'Junior',
                                              ifelse(grepl('R-T', Division), 'Teen',
                                                    ifelse(grepl(col_hs_y_div, Division), 'Col-HS-Youth','?'))))))

table(RawHist$Division_group)
table(RawHist$Division, RawHist$Division_group)

RawHist$Date <- as.Date(RawHist$Date, format = '%m/%d/%Y')
RawHist$Year <- format(RawHist$Date, '%Y')
table(RawHist$Date)
table(RawHist$Year)

table(RawHist$Weightclass, RawHist$Year)
# Weightclasses at Nationals were IPF

Female <- c('-43', '-47', '-52', '-57', '-63', '-72', '-84', '84+')
#Male <- c('-40', '-44', '-48', '-53', '-59', '-66', '-74', '-83', '-93', '-105', '-120', '120+')
Male <- c('-40','-53', '-59', '-66', '-74', '-83', '-93', '-105', '-120', '120+')

RawHist <- mutate(RawHist, Sex = ifelse(Weightclass %in% Female, 'f', 'm'))
RawHist$Sex <- factor(RawHist$Sex,
                          levels = c('f','m'),
                          labels = c("Female","Male"))
table(RawHist$Sex)

RawHist <- mutate(RawHist, 
                  Weightclass_Num =
                      ifelse(grepl("\\+", Weightclass), as.numeric(sub("\\+", "", Weightclass)) * 2,
                             as.numeric(sub("\\-", "", Weightclass))),
                  Weightclass_Num = factor(Weightclass_Num,
                                            levels = c(43, 47, 52, 57, 63, 72, 84, 168, 
                                                       40, 53, 59, 66, 74, 83, 93, 105, 120, 240),
                                           labels = c(Female, Male)))

# write out a piece of data for the Excel chart:
DataForExcel <-
    RawHist %>% 
    filter(Division_group == "Open" & Year >= 2014) %>% 
    mutate(Weightclass_Num =
               ifelse(grepl("\\+", Weightclass), as.numeric(sub("\\+", "", Weightclass)) + 1,
               as.numeric(sub("\\-", "", Weightclass)))) %>% 
    select(Sex, Year, Weightclass, Weightclass_Num)

write.csv(DataForExcel,"./CSV/Raw2014_2016_Weightclass.csv")

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

theme_classic_yz_leg <- 
    theme_classic() +
    theme(line = element_blank(),
          axis.text.y = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x = element_text(size = rel(1.2), face = "bold", color = "grey40"),
          axis.title.x = element_text(size = rel(1.5), color = "grey40"),
          strip.text = element_text(size = rel(1.2), face = "bold", color = "grey40"),
          strip.background = element_rect(color = "grey40"),
          plot.title = element_text(hjust = 0.03, face = "bold.italic", color = "grey60"))

ggplot(data = RawHist, aes(x = Year)) +
    geom_bar(aes(fill = Sex)) +
    facet_grid(.~Sex) +
    labs(x = "Year",
         y = "Lifter Count (with duplicates across divisions)") +
    scale_fill_brewer(palette = "YlGnBu") +
    geom_text(stat = "count", 
              aes(label = ..count..), 
              vjust = -0.5,
              color = "grey40",
              fontface = "bold") +
    ggtitle("Number of Lifters at USAPL Raw Nationals by Year since 2012") +
    theme_classic_yz

# Division distribution history

div_split_history_f <- 
    RawHist %>%
    filter(Sex == "Female") %>% 
    group_by(Year, Division_group) %>% 
    summarize(n = n()) %>% 
    mutate(perc = 100*n/sum(n),
           label = ifelse(perc > 2, paste0(round(perc,0),"%"), ""),
           csum = cumsum(perc),
           pos = ifelse(cumsum(perc) >= 97 , 3,
                        ifelse(cumsum(perc) <= 3, 99,
                               100 - cumsum(perc) + 3)))

div_split_history_m <- 
    RawHist %>%
    filter(Sex == "Male") %>% 
    group_by(Year, Division_group) %>% 
    summarize(n = n()) %>% 
    mutate(perc = 100*n/sum(n),
           label = ifelse(perc > 2, paste0(round(perc,0),"%"), ""),
           csum = cumsum(perc),
           pos = ifelse(cumsum(perc) >= 97 , 3,
                        ifelse(cumsum(perc) <= 3, 99,
                              100 - cumsum(perc) + 3)))

div_split_history <- bind_rows("Female" = div_split_history_f, 
                     "Male" = div_split_history_m,
                     .id = "Sex")

rm(list = c("div_split_history_f", "div_split_history_m"))

ggplot(div_split_history, aes(x = Year, y = perc, fill = Division_group)) +
    geom_bar(stat = "identity") +
    facet_grid(.~Sex) +
    geom_text(aes(label = label, y = pos),
              color = "grey10",
              fontface = "bold") + 
    labs(fill = "Divisions") +
    scale_fill_brewer(palette = "Spectral") +
    theme_classic_yz_leg +
    ggtitle("Division Split at USAPL Raw Nationals by Year")
    
    
# Weightclasses distribution history

wc_split_history_f <- 
    RawHist %>%
#    filter(Sex == "Female") %>% 
    filter(Sex == "Female" & Division_group == "Open" & Year >= 2014) %>% 
    group_by(Year, Weightclass_Num) %>% 
    summarize(n = n()) %>% 
    mutate(perc = 100*n/sum(n),
           label = ifelse(perc > 2.5, paste0(round(perc,0),"%"), ""),
           csum = cumsum(perc),
           pos = ifelse(cumsum(perc) >= 97 , 3,
                        ifelse(cumsum(perc) <= 3, 99,
                               100 - cumsum(perc) + 3)))

wc_split_history_m <- 
    RawHist %>%
#    filter(Sex == "Male") %>% 
    filter(Sex == "Male" & Division_group == "Open" & Year >= 2014) %>% 
    group_by(Year, Weightclass_Num) %>% 
    summarize(n = n()) %>% 
    mutate(perc = 100*n/sum(n),
           label = ifelse(perc > 2, paste0(round(perc,0),"%"), ""),
           csum = cumsum(perc),
           pos = ifelse(cumsum(perc) >= 97 , 3,
                        ifelse(cumsum(perc) <= 3, 99,
                               100 - cumsum(perc) + 3)))


f <- ggplot(wc_split_history_f, aes(x = Year, y = perc, fill = Weightclass_Num)) +
        geom_bar(stat = "identity") +
        geom_text(aes(label = label, y = pos),
                  color = "grey10",
                  fontface = "bold") + 
        labs(fill = "Weightclass", x = NULL, title = "Female Divisions") +
        scale_fill_brewer(palette = "Spectral") +
        theme_classic_yz_leg 

m <- ggplot(wc_split_history_m, aes(x = Year, y = perc, fill = Weightclass_Num)) +
    geom_bar(stat = "identity") +
    geom_text(aes(label = label, y = pos),
              color = "grey10",
              fontface = "bold") + 
    labs(fill = "Weightclass", x = NULL, title = "Male Divisions") +
    scale_fill_brewer(palette = "Spectral") +
    theme_classic_yz_leg 

# fm <- 
#     plot_grid(f, m, 
#               labels = c("Female", "Male"),
#               label_colour = "grey40",
#               vjust = 1) 

## Creating summary table

lf <- wc_split_history_f %>% 
    group_by(Year) %>% 
    summarize(NLifters = sum(n)) %>% 
    t() %>% 
    data.frame()

lm <- wc_split_history_m %>% 
    group_by(Year) %>% 
    summarize(NLifters = sum(n)) %>% 
    t() %>% 
    data.frame()

tt1 <- ttheme_minimal(core=list(fg_params=list(fontface=2, col="white", fontsize = 10),
                                bg_params = list(fill = "grey40", col=NA)))

lf1 <- tableGrob(lf[2,], cols = NULL, rows = NULL, theme = tt1)
lf1$widths <- unit(rep(1/ncol(lf1), ncol(lf1)), "npc")

lm1 <- tableGrob(lm[2,], cols = NULL, rows = NULL, theme = tt1)
lm1$widths <- unit(rep(1/ncol(lm1), ncol(lm1)), "npc")

tlab <- textGrob("Number\nof Lifters", 
                 gp = gpar(col = "grey40", fontsize = 10, fontface = "bold"))

# Alternative:
#tlab <- ggdraw() + 
#    draw_label("Number of Lifters",
#               size = 10,
#               fontface = "bold",
#               colour = "grey40")

blank <- rectGrob(gp = gpar(col = "white"))

lifters <- 
    arrangeGrob(tlab, lf1, blank, lm1, blank, nrow=1, widths = c(0.15,0.3,0.18,0.3,0.17))

wclasses <-
    arrangeGrob(blank, f, m, ncol=3, widths = c(0.12, 0.44, 0.44))

title <- textGrob("Weightclass Composition* at USAPL Raw Nationals by Year, Open Division", 
                 gp = gpar(col = "grey40", fontsize = 15, fontface = "bold"))

note <- textGrob("*: weightclasses with less than 2% of lifters do not have value labels for aesthetics reasons", 
                 gp = gpar(col = "grey40", fontsize = 8, fontface = "italic"))

#grid.draw(note)
# Alternative:
#title <- 
#    ggdraw() + 
#    draw_label("Weightclass Distribution at USAPL Raw Nationals by Year, Open Division",
#               fontface = "bold",
#               colour = "grey40")


grid.newpage()
grid.arrange(arrangeGrob(title, wclasses, lifters, note, nrow=4, heights = c(0.1, 1, 0.1, 0.05)))


png(file = "./Charts/Weightclasses distribution Open2.png", width=600, height=400)
grid.arrange(arrangeGrob(title, wclasses, lifters, note, nrow=4, heights = c(0.1, 1, 0.1, 0.05)))
dev.off()
