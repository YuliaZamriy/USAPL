---
title: "USAPL Weightcalss Composition by Year"
author: "Yulia Zamriy"
date: "December 6, 2017"
output: 
  html_document: 
    keep_md: yes
---





```r
library(tidyverse)
library(ggplot2)
library(gridExtra)
library(grid)
```


```r
WclassData <- read_csv("./CSV/Raw2014_2016_Weightclass.csv")
```


```r
Female <- c('-43', '-47', '-52', '-57', '-63', '-72', '-84', '84+')
Male <- c('-40','-53', '-59', '-66', '-74', '-83', '-93', '-105', '-120', '120+')

WclassData <- mutate(WclassData, 
                    Weightclass_Num = factor(Weightclass_Num,
                                             levels = c(43, 47, 52, 57, 63, 72, 84, 85, 
                                                        40, 53, 59, 66, 74, 83, 93, 105, 120, 121),
                                             labels = c(Female, Male)))
```



```r
wc_split_f <- 
    WclassData %>%
    filter(Sex == "Female") %>% 
    group_by(Year, Weightclass_Num) %>% 
    summarize(NLifters = n()) %>% 
    mutate(perc = 100*NLifters/sum(NLifters),
           label = ifelse(perc > 2.5, paste0(round(perc,0),"%"), ""),
           labpos = ifelse(cumsum(perc) >= 97 , 3,
                        ifelse(cumsum(perc) <= 3, 99,
                               100 - cumsum(perc) + 3)))

wc_split_m <- 
    WclassData %>%
    filter(Sex == "Male") %>% 
    group_by(Year, Weightclass_Num) %>% 
    summarize(NLifters = n()) %>% 
    mutate(perc = 100*NLifters/sum(NLifters),
           label = ifelse(perc > 2, paste0(round(perc,0),"%"), ""),
           labpos = ifelse(cumsum(perc) >= 97 , 3,
                        ifelse(cumsum(perc) <= 3, 99,
                               100 - cumsum(perc) + 3)))
```




```r
theme_classic_adj <- 
    theme_classic() +
    theme(line = element_blank(),
          axis.text.y = element_blank(),
          axis.title.y = element_blank(),
          axis.text.x = element_text(size = rel(1.2), face = "bold", color = "grey40"),
          axis.title.x = element_text(size = rel(1.5), color = "grey40"),
          strip.text = element_text(size = rel(1.2), face = "bold", color = "grey40"),
          strip.background = element_rect(color = "grey40"),
          plot.title = element_text(hjust = 0.03, face = "bold.italic", color = "grey60"))
```




```r
plot_f <- ggplot(wc_split_f, aes(x = Year, y = perc, fill = Weightclass_Num)) +
        geom_bar(stat = "identity") +
        geom_text(aes(label = label, y = labpos),
                  color = "grey10",
                  fontface = "bold") + 
        labs(fill = "Weightclass", x = NULL, title = "Female Divisions") +
        scale_fill_brewer(palette = "Spectral") +
        theme_classic_adj 

plot_m <- ggplot(wc_split_m, aes(x = Year, y = perc, fill = Weightclass_Num)) +
    geom_bar(stat = "identity") +
    geom_text(aes(label = label, y = labpos),
              color = "grey10",
              fontface = "bold") + 
    labs(fill = "Weightclass", x = NULL, title = "Male Divisions") +
    scale_fill_brewer(palette = "Spectral") +
    theme_classic_adj 
```



```r
count_f1 <- wc_split_f %>% 
    group_by(Year) %>% 
    summarize(NLifters = sum(NLifters)) %>% 
    t() %>% 
    data.frame()

count_m1 <- wc_split_m %>% 
    group_by(Year) %>% 
    summarize(NLifters = sum(NLifters)) %>% 
    t() %>% 
    data.frame()
```


```r
tt <- ttheme_minimal(core=list(fg_params=list(fontface=2, col="white", fontsize = 10),
                                bg_params = list(fill = "grey40", col=NA)))

count_f2 <- tableGrob(count_f1[2,], cols = NULL, rows = NULL, theme = tt)
count_f2$widths <- unit(rep(1/ncol(count_f2), ncol(count_f2)), "npc")

count_m2 <- tableGrob(count_m1[2,], cols = NULL, rows = NULL, theme = tt)
count_m2$widths <- unit(rep(1/ncol(count_m2), ncol(count_m2)), "npc")
```



```r
countlab <- textGrob("Number\nof Lifters", 
                 gp = gpar(col = "grey40", fontsize = 10, fontface = "bold"))

blank <- rectGrob(gp = gpar(col = "white"))

counttab <- 
    arrangeGrob(countlab, count_f2, blank, count_m2, blank, nrow=1, widths = c(0.15,0.3,0.18,0.3,0.17))
```



```r
plots_fm <-
    arrangeGrob(blank, plot_f, plot_m, ncol=3, widths = c(0.12, 0.44, 0.44))
```


```r
title <- textGrob("Weightclass Composition* at USAPL Raw Nationals by Year, Open Division", 
                 gp = gpar(col = "grey40", fontsize = 15, fontface = "bold"))

note <- textGrob("* Weightclasses with less than 2% of lifters do not have value labels for aesthetics reasons", 
                 gp = gpar(col = "grey40", fontsize = 8, fontface = "italic"))
```



```r
grid.newpage()
grid.arrange(arrangeGrob(title, plots_fm, counttab, note, nrow=4, heights = c(0.1, 1, 0.1, 0.05)))
```

![](USAPLWclass_files/figure-html/unnamed-chunk-12-1.png)<!-- -->



```r
png(file = "./Charts/Weightclasses distribution Open2.png", width=600, height=400)
grid.arrange(arrangeGrob(title, plots_fm, counttab, note, nrow=4, heights = c(0.1, 1, 0.1, 0.05)))
dev.off()
```

```
## png 
##   2
```

