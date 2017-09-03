# USAPL Competition Data Prep
Yulia Zamriy  
September 2, 2017  


## Overview

This file contains the code to import and process csv files containing the results of USAPL Raw National competitions for 2014, 2015 and 2016.
Output: Clean data set ready for the main analysis. 
The code for the analysis is contained in the file called "USAPL_Raw_Nationals_Attempt_Analysis.rmd"

### Data Import

**Step 1.** Prepare works space

- Clean workspace

- Set working directory to the location for the csv files

- Install and load nessary packages

- Load the data


```r
rm(list=ls())
setwd("C:/Users/yzamriy/Documents/Tools and Methodology/DS/Powerlifting/Clean code")
#install.packages("tidyverse")
library(tidyverse)

Raw2014 <- read_csv("2014 Raw Nationals.csv")
Raw2015 <- read_csv("2015 Raw Nationals.csv")
Raw2016 <- read_csv("Raw Nationals 2016.csv")
```


```r
str(Raw2014)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	445 obs. of  20 variables:
##  $ Weightclass : chr  "-52" "-52" "-57" "-57" ...
##  $ Link        : chr  "lifters-view?id=2047" "lifters-view?id=6121" "lifters-view?id=22585" "lifters-view?id=4904" ...
##  $ Placing     : num  1 5 3 2 3 1 2 4 8 14 ...
##  $ Name        : chr  "Ashley Will" "Shelby Sweat" "Laura McGuill" "Elaine Wang" ...
##  $ YOB         : int  1994 1991 1991 1991 1993 1992 1993 1991 1991 1993 ...
##  $ Team        : chr  NA NA NA NA ...
##  $ State       : chr  NA NA NA NA ...
##  $ Weight      : num  51.8 50.3 56.3 56.9 56 62.7 61.7 62.5 61.2 62.2 ...
##  $ Squat1      : num  102.5 67.5 112.5 100 -67.5 ...
##  $ Squat2      : num  -108 80 120 110 70 ...
##  $ Squat3      : num  -107.5 -85 125 -117.5 77.5 ...
##  $ Bench press1: num  42.5 40 52.5 55 50 -62.5 75 60 55 62.5 ...
##  $ Bench press2: num  45 -45 57.5 60 -55 62.5 -82.5 62.5 60 65 ...
##  $ Bench press3: num  47.5 -45 62.5 -65 -55 70 -82.5 -65 62.5 -70 ...
##  $ Deadlift1   : num  105 95 140 -120 100 ...
##  $ Deadlift2   : num  110 102 150 120 110 ...
##  $ Deadlift3   : num  -112 110 -155 132 118 ...
##  $ Total       : num  260 230 338 302 245 ...
##  $ Points      : num  325 294 395 352 288 ...
##  $ Drug tested : chr  NA NA NA NA ...
##  - attr(*, "spec")=List of 2
##   ..$ cols   :List of 20
##   .. ..$ Weightclass : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ Link        : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ Placing     : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Name        : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ YOB         : list()
##   .. .. ..- attr(*, "class")= chr  "collector_integer" "collector"
##   .. ..$ Team        : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ State       : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ Weight      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Squat1      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Squat2      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Squat3      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Bench press1: list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Bench press2: list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Bench press3: list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Deadlift1   : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Deadlift2   : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Deadlift3   : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Total       : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Points      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Drug tested : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   ..$ default: list()
##   .. ..- attr(*, "class")= chr  "collector_guess" "collector"
##   ..- attr(*, "class")= chr "col_spec"
```

```r
str(Raw2015)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	990 obs. of  20 variables:
##  $ Weightclass : chr  "-63" "84+" "84+" "-43" ...
##  $ Link        : chr  "lifters-view?id=16331" "lifters-view?id=14292" "lifters-view?id=14787" "lifters-view?id=24776" ...
##  $ Placing     : num  5 1 1 1 1 2 3 1 4 4 ...
##  $ Name        : chr  "Kiara Pereira" "LeeAnn Hewitt" "Allie Perry" "Tam Nguyen" ...
##  $ YOB         : int  1998 1999 2000 1995 1994 1994 1993 1994 1992 1992 ...
##  $ Team        : chr  NA NA NA NA ...
##  $ State       : chr  "CT" "FL" "OH" "IN" ...
##  $ Weight      : num  60.7 148.8 94.8 43 47 ...
##  $ Squat1      : num  80 205 92.5 70 -90 75 82.5 110 97.5 100 ...
##  $ Squat2      : num  90 222.5 102.5 77.5 90 ...
##  $ Squat3      : num  95 240 110 80 92.5 ...
##  $ Bench press1: num  -52.5 92.5 50 35 45 47.5 47.5 70 60 50 ...
##  $ Bench press2: num  -60 102.5 55 40.5 47.5 ...
##  $ Bench press3: num  -60 107.5 -57.5 42.5 50 ...
##  $ Deadlift1   : num  90 185 108 95 108 ...
##  $ Deadlift2   : num  -100 200 -118 100 112 ...
##  $ Deadlift3   : num  NA 212 128 108 122 ...
##  $ Total       : num  0 560 292 230 265 ...
##  $ Points      : num  0 431 248 329 356 ...
##  $ Drug tested : chr  NA NA NA NA ...
##  - attr(*, "spec")=List of 2
##   ..$ cols   :List of 20
##   .. ..$ Weightclass : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ Link        : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ Placing     : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Name        : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ YOB         : list()
##   .. .. ..- attr(*, "class")= chr  "collector_integer" "collector"
##   .. ..$ Team        : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ State       : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ Weight      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Squat1      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Squat2      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Squat3      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Bench press1: list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Bench press2: list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Bench press3: list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Deadlift1   : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Deadlift2   : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Deadlift3   : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Total       : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Points      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Drug tested : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   ..$ default: list()
##   .. ..- attr(*, "class")= chr  "collector_guess" "collector"
##   ..- attr(*, "class")= chr "col_spec"
```

```r
str(Raw2016)
```

```
## Classes 'tbl_df', 'tbl' and 'data.frame':	1063 obs. of  20 variables:
##  $ Weightclass : chr  "-63" "-83" "-105" "-52" ...
##  $ Link        : chr  "lifters-view?id=27318" "lifters-view?id=31949" "lifters-view?id=15420" "lifters-view?id=30593" ...
##  $ Placing     : chr  "8." "-" "-" "1." ...
##  $ Name        : chr  "Danielle Oliveri" "Nick Mccouch" "Christopher Thacker" "Sydney Rivera" ...
##  $ YOB         : int  1993 1990 1977 2003 1995 1994 1995 1994 1993 1995 ...
##  $ Team        : chr  "Squats & Science" NA "Zia" NA ...
##  $ State       : chr  "PA" "GA" "IL" "GA" ...
##  $ Weight      : num  62 81.3 104.1 51.3 38.4 ...
##  $ Squat1      : num  135 -215 -280 67.5 75 ...
##  $ Squat2      : num  142.5 -227.5 -290 72.5 77.5 ...
##  $ Squat3      : num  147.5 -235 -295 77.5 82.5 ...
##  $ Bench press1: num  82.5 -142.5 -175 35 40 ...
##  $ Bench press2: num  85 -1000 -180 40 42.5 60 47.5 47.5 47.5 50 ...
##  $ Bench press3: num  87.5 -150 -182.5 -45 45 ...
##  $ Deadlift1   : num  142.5 -237.5 -270 77.5 92.5 ...
##  $ Deadlift2   : num  150 -265 -280 85 -95 ...
##  $ Deadlift3   : num  155 -265 -280 -90 -95 ...
##  $ Total       : num  390 0 0 202 220 ...
##  $ Points      : num  424 0 0 255 329 ...
##  $ Drug tested : chr  NA "Failure" NA NA ...
##  - attr(*, "spec")=List of 2
##   ..$ cols   :List of 20
##   .. ..$ Weightclass : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ Link        : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ Placing     : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ Name        : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ YOB         : list()
##   .. .. ..- attr(*, "class")= chr  "collector_integer" "collector"
##   .. ..$ Team        : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ State       : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   .. ..$ Weight      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Squat1      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Squat2      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Squat3      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Bench press1: list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Bench press2: list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Bench press3: list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Deadlift1   : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Deadlift2   : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Deadlift3   : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Total       : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Points      : list()
##   .. .. ..- attr(*, "class")= chr  "collector_double" "collector"
##   .. ..$ Drug tested : list()
##   .. .. ..- attr(*, "class")= chr  "collector_character" "collector"
##   ..$ default: list()
##   .. ..- attr(*, "class")= chr  "collector_guess" "collector"
##   ..- attr(*, "class")= chr "col_spec"
```

**Step 2.** Combine three datasets into one

- *Placing* variable in Raw2016 was processed as char. 

- Create an ID variable *Meet* for each file called Meet


```r
Raw2016$Placing <- as.numeric(Raw2016$Placing)

Raw2014_2016 <- bind_rows("Raw2014" = Raw2014, 
                          "Raw2015" = Raw2015, 
                          "Raw2016" = Raw2016, 
                          .id = "Meet")
```


```r
dim(Raw2014_2016)
```

```
## [1] 2498   21
```

```r
table(Raw2014_2016$Meet)
```

```
## 
## Raw2014 Raw2015 Raw2016 
##     445     990    1063
```

**Step 3.** Recode weight classes from char to numeric:

 - Weight classes are different for men vs. women. Hence, we can create *Sex* indicator and *Sex_factor* based on weight class. 
 
 - There was one record in 2015 for a lifter in 40kg class (Youth). Since it's uncommon for youth compete at Raw Nationals, this record is deleted
 
 - Char weight classes are preceeded by '-' to indicate 'under' specific weight
 
 - Two weight classes that need special treatment for conversion to numeric are 84kg+ and 120kg+. For convenience, they will are recoded to 90 and 125 (so that in graphs they are visibly separate from under 84/120)


```r
table(Raw2014_2016$Weightclass)
```

```
## 
## -105 -120  -40  -43  -47  -52  -53  -57  -59  -63  -66  -72  -74  -83  -84 
##  264  151    1    9   39   79    7  142   59  221  123  226  215  277  135 
##  -93 120+  84+ 
##  349  101  100
```


```r
Female <- c('-43', '-47', '-52', '-57', '-63', '-72', '-84', '84+')
Male <- c('-40', '-44', '-48', '-53', '-59', '-66', '-74', '-83', '-93', '-105', '-120', '120+')

Raw2014_2016$Sex <- 'f'
Raw2014_2016$Sex[Raw2014_2016$Weightclass %in% Male] <- 'm'
Raw2014_2016$Sex_factor <- factor(Raw2014_2016$Sex,
                           levels = c('f','m'),
                           labels = c("Female","Male"))

Raw2014_2016 <- subset(Raw2014_2016, Weightclass != '-40')
Raw2014_2016$Weightclass_Num <- as.numeric(Raw2014_2016$Weightclass) * -1
Raw2014_2016$Weightclass_Num[Raw2014_2016$Weightclass == '120+'] <- 125
Raw2014_2016$Weightclass_Num[Raw2014_2016$Weightclass == '84+'] <- 90
```


```r
table(Raw2014_2016$Weightclass, Raw2014_2016$Weightclass_Num)
```

```
##       
##         43  47  52  53  57  59  63  66  72  74  83  84  90  93 105 120 125
##   -105   0   0   0   0   0   0   0   0   0   0   0   0   0   0 264   0   0
##   -120   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 151   0
##   -43    9   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
##   -47    0  39   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0
##   -52    0   0  79   0   0   0   0   0   0   0   0   0   0   0   0   0   0
##   -53    0   0   0   7   0   0   0   0   0   0   0   0   0   0   0   0   0
##   -57    0   0   0   0 142   0   0   0   0   0   0   0   0   0   0   0   0
##   -59    0   0   0   0   0  59   0   0   0   0   0   0   0   0   0   0   0
##   -63    0   0   0   0   0   0 221   0   0   0   0   0   0   0   0   0   0
##   -66    0   0   0   0   0   0   0 123   0   0   0   0   0   0   0   0   0
##   -72    0   0   0   0   0   0   0   0 226   0   0   0   0   0   0   0   0
##   -74    0   0   0   0   0   0   0   0   0 215   0   0   0   0   0   0   0
##   -83    0   0   0   0   0   0   0   0   0   0 277   0   0   0   0   0   0
##   -84    0   0   0   0   0   0   0   0   0   0   0 135   0   0   0   0   0
##   -93    0   0   0   0   0   0   0   0   0   0   0   0   0 349   0   0   0
##   120+   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0   0 101
##   84+    0   0   0   0   0   0   0   0   0   0   0   0 100   0   0   0   0
```

```r
table(Raw2014_2016$Sex, Raw2014_2016$Weightclass_Num)
```

```
##    
##      43  47  52  53  57  59  63  66  72  74  83  84  90  93 105 120 125
##   f   9  39  79   0 142   0 221   0 226   0   0 135 100   0   0   0   0
##   m   0   0   0   7   0  59   0 123   0 215 277   0   0 349 264 151 101
```

```r
table(Raw2014_2016$Sex, Raw2014_2016$Sex_factor)
```

```
##    
##     Female Male
##   f    951    0
##   m      0 1546
```

**Step 4.** Recode NAs for 9 attemps into 0

- Variables 10:18 are: Squat1:Deadlift3


```r
summary(Raw2014_2016[,10:18])
```

```
##      Squat1           Squat2           Squat3         Bench press1    
##  Min.   :-317.5   Min.   :-410.0   Min.   :-375.00   Min.   :-222.50  
##  1st Qu.: 102.5   1st Qu.:  85.0   1st Qu.:-160.00   1st Qu.:  60.00  
##  Median : 150.0   Median : 145.0   Median : 107.50   Median : 100.00  
##  Mean   : 130.0   Mean   : 103.2   Mean   :  28.56   Mean   :  88.39  
##  3rd Qu.: 205.0   3rd Qu.: 210.0   3rd Qu.: 192.50   3rd Qu.: 137.50  
##  Max.   : 410.0   Max.   : 435.0   Max.   : 456.00   Max.   : 245.00  
##  NA's   :7        NA's   :18       NA's   :55        NA's   :13       
##   Bench press2       Bench press3       Deadlift1        Deadlift2     
##  Min.   :-1000.00   Min.   :-262.50   Min.   :-317.5   Min.   :-350.0  
##  1st Qu.:   47.50   1st Qu.:-127.50   1st Qu.: 130.0   1st Qu.: 122.5  
##  Median :   85.00   Median : -60.00   Median : 182.5   Median : 175.0  
##  Mean   :   64.92   Mean   : -14.16   Mean   : 164.8   Mean   : 131.7  
##  3rd Qu.:  140.00   3rd Qu.: 105.00   3rd Qu.: 232.5   3rd Qu.: 237.5  
##  Max.   :  255.00   Max.   : 265.50   Max.   : 352.5   Max.   : 362.5  
##  NA's   :29         NA's   :71        NA's   :22       NA's   :60      
##    Deadlift3       
##  Min.   :-365.000  
##  1st Qu.:-227.500  
##  Median :  96.250  
##  Mean   :  -6.996  
##  3rd Qu.: 192.500  
##  Max.   : 383.000  
##  NA's   :137
```


```r
recode_na <- function(x) {
    x[is.na(x)] <- 0
    x
}

Raw2014_2016[,10:18] <- lapply(Raw2014_2016[,10:18], recode_na)
```


```r
summary(Raw2014_2016[,10:18])
```

```
##      Squat1           Squat2           Squat3         Bench press1    
##  Min.   :-317.5   Min.   :-410.0   Min.   :-375.00   Min.   :-222.50  
##  1st Qu.: 102.5   1st Qu.:  85.0   1st Qu.:-157.50   1st Qu.:  60.00  
##  Median : 150.0   Median : 145.0   Median : 105.00   Median :  97.50  
##  Mean   : 129.6   Mean   : 102.5   Mean   :  27.93   Mean   :  87.93  
##  3rd Qu.: 202.5   3rd Qu.: 210.0   3rd Qu.: 190.00   3rd Qu.: 137.50  
##  Max.   : 410.0   Max.   : 435.0   Max.   : 456.00   Max.   : 245.00  
##   Bench press2       Bench press3       Deadlift1        Deadlift2     
##  Min.   :-1000.00   Min.   :-262.50   Min.   :-317.5   Min.   :-350.0  
##  1st Qu.:   47.50   1st Qu.:-125.00   1st Qu.: 130.0   1st Qu.: 117.5  
##  Median :   82.50   Median : -57.50   Median : 182.5   Median : 172.5  
##  Mean   :   64.17   Mean   : -13.76   Mean   : 163.3   Mean   : 128.5  
##  3rd Qu.:  140.00   3rd Qu.: 102.50   3rd Qu.: 232.5   3rd Qu.: 237.5  
##  Max.   :  255.00   Max.   : 265.50   Max.   : 352.5   Max.   : 362.5  
##    Deadlift3       
##  Min.   :-365.000  
##  1st Qu.:-225.000  
##  Median :   0.000  
##  Mean   :  -6.612  
##  3rd Qu.: 187.500  
##  Max.   : 383.000
```

**Step 5.** Create a counter for successful attempts

- Failed attempts are represented as negative numbers

- *Success*: number of successful attempts (possible values: 0 to 9)

- *Success_rate*: % of successful attempts


```r
recode_neg_to_zero <- function(x, y) {
    x[y <= 0] <- 0
    x
}

Raw2014_2016$Squat1_success <- 1
Raw2014_2016$Squat2_success <- 1
Raw2014_2016$Squat3_success <- 1
Raw2014_2016$BP1_success <- 1
Raw2014_2016$BP2_success <- 1
Raw2014_2016$BP3_success <- 1
Raw2014_2016$DL1_success <- 1
Raw2014_2016$DL2_success <- 1
Raw2014_2016$DL3_success <- 1

Raw2014_2016$Squat1_success <- 
    mapply(recode_neg_to_zero, Raw2014_2016$Squat1_success , Raw2014_2016$Squat1)
Raw2014_2016$Squat2_success <- 
    mapply(recode_neg_to_zero, Raw2014_2016$Squat2_success , Raw2014_2016$Squat2)
Raw2014_2016$Squat3_success <- 
    mapply(recode_neg_to_zero, Raw2014_2016$Squat3_success , Raw2014_2016$Squat3)
Raw2014_2016$BP1_success <- 
    mapply(recode_neg_to_zero, Raw2014_2016$BP1_success , Raw2014_2016$`Bench press1`)
Raw2014_2016$BP2_success <- 
    mapply(recode_neg_to_zero, Raw2014_2016$BP2_success , Raw2014_2016$`Bench press2`)
Raw2014_2016$BP3_success <- 
    mapply(recode_neg_to_zero, Raw2014_2016$BP3_success , Raw2014_2016$`Bench press3`)
Raw2014_2016$DL1_success <- 
    mapply(recode_neg_to_zero, Raw2014_2016$DL1_success , Raw2014_2016$Deadlift1)
Raw2014_2016$DL2_success <- 
    mapply(recode_neg_to_zero, Raw2014_2016$DL2_success , Raw2014_2016$Deadlift2)
Raw2014_2016$DL3_success <- 
    mapply(recode_neg_to_zero, Raw2014_2016$DL3_success , Raw2014_2016$Deadlift3)

Raw2014_2016$Success <- 
    Raw2014_2016$Squat1_success + 
    Raw2014_2016$Squat2_success +
    Raw2014_2016$Squat3_success +
    Raw2014_2016$BP1_success +
    Raw2014_2016$BP2_success +
    Raw2014_2016$BP3_success +
    Raw2014_2016$DL1_success +
    Raw2014_2016$DL2_success +
    Raw2014_2016$DL3_success

Raw2014_2016$Success_rate <- Raw2014_2016$Success/9
```


```r
lapply(Raw2014_2016[,25:34], table)
```

```
## $Squat1_success
## 
##    0    1 
##  278 2219 
## 
## $Squat2_success
## 
##    0    1 
##  524 1973 
## 
## $Squat3_success
## 
##    0    1 
## 1073 1424 
## 
## $BP1_success
## 
##    0    1 
##  209 2288 
## 
## $BP2_success
## 
##    0    1 
##  536 1961 
## 
## $BP3_success
## 
##    0    1 
## 1441 1056 
## 
## $DL1_success
## 
##    0    1 
##  167 2330 
## 
## $DL2_success
## 
##    0    1 
##  445 2052 
## 
## $DL3_success
## 
##    0    1 
## 1287 1210 
## 
## $Success
## 
##   0   1   2   3   4   5   6   7   8   9 
##  22  13   9  60 144 304 500 613 573 259
```

```r
summary(Raw2014_2016$Success_rate)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0000  0.6667  0.7778  0.7348  0.8889  1.0000
```

**Step 6.** Create a pattern for each possible combination of success/fail for each lift

- This pattern will be used to subset the dataset to focus on the groups of interest

- Result: 3 character variables: *Success_attempts*, *BP_attempts*, *Deadlift_attempts* and 3 factor variable corresponding to each


```r
success_count <- function(attempt1, attempt2, attempt3, attempts) {
    
    if((attempt1 <= 0) & (attempt2 <= 0) & (attempt3 <= 0)) {
        attempts <- '000'
    }
    else if((attempt1 > 0) & (attempt2 <= 0) & (attempt3 <= 0)) {
        attempts <- '100'
    }
    else if((attempt1 > 0) & (attempt2 > 0) & (attempt3 <= 0)) {
        attempts <- '110'
    }
    else if((attempt1 > 0) & (attempt2 <= 0) & (attempt3 > 0)) {
        attempts <- '101'
    }
    else if((attempt1 <= 0) & (attempt2 > 0) & (attempt3 <= 0)) {
        attempts <- '010'
    }
    else if((attempt1 <= 0) & (attempt2 > 0) & (attempt3 > 0)) {
        attempts <- '011'
    }
    else if((attempt1 <= 0) & (attempt2 <= 0) & (attempt3 > 0)){
        attempts <- '001'
    }
    else{
        attempts <- '111'
    }
}

Raw2014_2016$Squat_attempts <- ''
Raw2014_2016$BP_attempts <- ''
Raw2014_2016$Deadlift_attempts <- ''

Raw2014_2016$Squat_attempts <- mapply(success_count, 
                                      Raw2014_2016$Squat1, 
                                      Raw2014_2016$Squat2, 
                                      Raw2014_2016$Squat3, 
                                      Raw2014_2016$Squat_attempts)

Raw2014_2016$BP_attempts <- mapply(success_count, 
                                   Raw2014_2016$`Bench press1`, 
                                   Raw2014_2016$`Bench press2`, 
                                   Raw2014_2016$`Bench press3`, 
                                   Raw2014_2016$BP_attempts)

Raw2014_2016$Deadlift_attempts <- mapply(success_count, 
                                         Raw2014_2016$Deadlift1, 
                                         Raw2014_2016$Deadlift2, 
                                         Raw2014_2016$Deadlift3, 
                                         Raw2014_2016$Deadlift_attempts)

Attempts_levels <- c("000" , "001" , "010" , "011" , "100" , "101" , "110" , "111")
Attempts_labels <- c("000" , "001" , "010" , "011" , "100" , "101" , "Failed 3rd" , "All 3 Successful")

Raw2014_2016$Squat_attempts_factor <- factor(Raw2014_2016$Squat_attempts,
                                      levels = Attempts_levels,
                                      labels = Attempts_labels)

Raw2014_2016$BP_attempts_factor <- factor(Raw2014_2016$BP_attempts,
                                   levels = Attempts_levels,
                                   labels = Attempts_labels)

Raw2014_2016$Deadlift_attempts_factor <- factor(Raw2014_2016$Deadlift_attempts,
                                         levels = Attempts_levels,
                                         labels = Attempts_labels)
```


```r
table(Raw2014_2016$Squat_attempts, Raw2014_2016$Success)
```

```
##      
##         0   1   2   3   4   5   6   7   8   9
##   000  22   3   3   4  12   6   6   0   0   0
##   001   0   0   1   5  12  16   9   4   0   0
##   010   0   3   0  12   9  33  26   3   0   0
##   011   0   0   1   0   3  10  28  27  20   0
##   100   0   7   1  24  59  83  57  21   0   0
##   101   0   0   2   1   7  22  53  58  26   0
##   110   0   0   1  10  40 113 218 202  95   0
##   111   0   0   0   4   2  21 103 298 432 259
```

```r
table(Raw2014_2016$BP_attempts, Raw2014_2016$Success)
```

```
##      
##         0   1   2   3   4   5   6   7   8   9
##   000  22  13   5  10   7   1   0   0   0   0
##   001   0   0   0   2   3   3   5   2   0   0
##   010   0   0   0  10  13  18  23  10   0   0
##   011   0   0   0   1   3  12  15  14  17   0
##   100   0   0   3  33  63  98  89  39   0   0
##   101   0   0   0   0   3  25  30  49  31   0
##   110   0   0   1   4  50 128 263 335 203   0
##   111   0   0   0   0   2  19  75 164 322 259
```

```r
table(Raw2014_2016$Deadlift_attempts, Raw2014_2016$Success)
```

```
##      
##         0   1   2   3   4   5   6   7   8   9
##   000  22  10   6  14  10   5   1   0   0   0
##   001   0   0   0   1   2   3   2   2   0   0
##   010   0   1   0   7   5  10  14   6   0   0
##   011   0   0   0   1   2   4  16  18   5   0
##   100   0   2   3  34  72  89  61  20   0   0
##   101   0   0   0   0   3  10  23  29  21   0
##   110   0   0   0   3  46 150 261 280 155   0
##   111   0   0   0   0   4  33 122 258 392 259
```

```r
table(Raw2014_2016$Squat_attempts, Raw2014_2016$Squat_attempts_factor)
```

```
##      
##        000  001  010  011  100  101 Failed 3rd All 3 Successful
##   000   56    0    0    0    0    0          0                0
##   001    0   47    0    0    0    0          0                0
##   010    0    0   86    0    0    0          0                0
##   011    0    0    0   89    0    0          0                0
##   100    0    0    0    0  252    0          0                0
##   101    0    0    0    0    0  169          0                0
##   110    0    0    0    0    0    0        679                0
##   111    0    0    0    0    0    0          0             1119
```

```r
table(Raw2014_2016$BP_attempts, Raw2014_2016$BP_attempts_factor)
```

```
##      
##       000 001 010 011 100 101 Failed 3rd All 3 Successful
##   000  58   0   0   0   0   0          0                0
##   001   0  15   0   0   0   0          0                0
##   010   0   0  74   0   0   0          0                0
##   011   0   0   0  62   0   0          0                0
##   100   0   0   0   0 325   0          0                0
##   101   0   0   0   0   0 138          0                0
##   110   0   0   0   0   0   0        984                0
##   111   0   0   0   0   0   0          0              841
```

```r
table(Raw2014_2016$Deadlift_attempts, Raw2014_2016$Deadlift_attempts_factor)
```

```
##      
##        000  001  010  011  100  101 Failed 3rd All 3 Successful
##   000   68    0    0    0    0    0          0                0
##   001    0   10    0    0    0    0          0                0
##   010    0    0   43    0    0    0          0                0
##   011    0    0    0   46    0    0          0                0
##   100    0    0    0    0  281    0          0                0
##   101    0    0    0    0    0   86          0                0
##   110    0    0    0    0    0    0        895                0
##   111    0    0    0    0    0    0          0             1068
```

**Step 7.** Create flags for lifters that successfully completed all 3 attempts on each lift


```r
Raw2014_2016$Squat_111 <- 0
Raw2014_2016$Squat_111[Raw2014_2016$Squat_attempts == '111'] <- 1
Raw2014_2016$BP_111 <- 0
Raw2014_2016$BP_111[Raw2014_2016$BP_attempts == '111'] <- 1
Raw2014_2016$Deadlift_111 <- 0
Raw2014_2016$Deadlift_111[Raw2014_2016$Deadlift_attempts == '111'] <- 1
```


```r
table(Raw2014_2016$Squat_111, Raw2014_2016$Sex)
```

```
##    
##       f   m
##   0 536 842
##   1 415 704
```

```r
table(Raw2014_2016$BP_111, Raw2014_2016$Sex)
```

```
##    
##        f    m
##   0  631 1025
##   1  320  521
```

```r
table(Raw2014_2016$Deadlift_111, Raw2014_2016$Sex)
```

```
##    
##       f   m
##   0 470 959
##   1 481 587
```

**Step 8.** Create variables for the relative and absolute differences between attempts

- Since failed attempts are negative, we will extract absolute values for the analysis

- If 3rd attempt is failed or equal 0, then *pct_of* and *kg_diff* variables are set to 0


```r
Raw2014_2016$Squat1_pct_of_3rd <- abs(Raw2014_2016$Squat1 / Raw2014_2016$Squat3)
Raw2014_2016$Squat2_pct_of_3rd <- abs(Raw2014_2016$Squat2 / Raw2014_2016$Squat3)
Raw2014_2016$BP1_pct_of_3rd <- abs(Raw2014_2016$`Bench press1` / Raw2014_2016$`Bench press3`)
Raw2014_2016$BP2_pct_of_3rd <- abs(Raw2014_2016$`Bench press2` / Raw2014_2016$`Bench press3`)
Raw2014_2016$DL1_pct_of_3rd <- abs(Raw2014_2016$Deadlift1 / Raw2014_2016$Deadlift3)
Raw2014_2016$DL2_pct_of_3rd <- abs(Raw2014_2016$Deadlift2 / Raw2014_2016$Deadlift3)

Raw2014_2016$Squat1_pct_of_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$Squat1_pct_of_3rd, Raw2014_2016$Squat3)
Raw2014_2016$Squat2_pct_of_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$Squat2_pct_of_3rd, Raw2014_2016$Squat3)
Raw2014_2016$BP1_pct_of_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$BP1_pct_of_3rd, Raw2014_2016$`Bench press3`)
Raw2014_2016$BP2_pct_of_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$BP2_pct_of_3rd, Raw2014_2016$`Bench press3`)
Raw2014_2016$DL1_pct_of_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$DL1_pct_of_3rd, Raw2014_2016$Deadlift3)
Raw2014_2016$DL2_pct_of_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$DL2_pct_of_3rd, Raw2014_2016$Deadlift3)

Raw2014_2016$Squat1_kg_diff_3rd <- abs(Raw2014_2016$Squat3) - abs(Raw2014_2016$Squat1)
Raw2014_2016$Squat2_kg_diff_3rd <- abs(Raw2014_2016$Squat3) - abs(Raw2014_2016$Squat2)
Raw2014_2016$BP1_kg_diff_3rd <- abs(Raw2014_2016$`Bench press3`) - abs(Raw2014_2016$`Bench press1`)
Raw2014_2016$BP2_kg_diff_3rd <- abs(Raw2014_2016$`Bench press3`) - abs(Raw2014_2016$`Bench press2`)
Raw2014_2016$DL1_kg_diff_3rd <- abs(Raw2014_2016$Deadlift3) - abs(Raw2014_2016$Deadlift1)
Raw2014_2016$DL2_kg_diff_3rd <- abs(Raw2014_2016$Deadlift3) - abs(Raw2014_2016$Deadlift2)

Raw2014_2016$Squat1_kg_diff_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$Squat1_kg_diff_3rd, Raw2014_2016$Squat1_kg_diff_3rd)
Raw2014_2016$Squat2_kg_diff_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$Squat2_kg_diff_3rd, Raw2014_2016$Squat2_kg_diff_3rd)
Raw2014_2016$BP1_kg_diff_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$BP1_kg_diff_3rd, Raw2014_2016$BP1_kg_diff_3rd)
Raw2014_2016$BP2_kg_diff_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$BP2_kg_diff_3rd, Raw2014_2016$BP2_kg_diff_3rd)
Raw2014_2016$DL1_kg_diff_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$DL1_kg_diff_3rd, Raw2014_2016$DL1_kg_diff_3rd)
Raw2014_2016$DL2_kg_diff_3rd <- 
    mapply(recode_neg_to_zero, Raw2014_2016$DL2_kg_diff_3rd, Raw2014_2016$DL2_kg_diff_3rd)
```

```r
summary(Raw2014_2016[,45:56])
```

```
##  Squat1_pct_of_3rd Squat2_pct_of_3rd BP1_pct_of_3rd   BP2_pct_of_3rd  
##  Min.   :0.0000    Min.   :0.0000    Min.   :0.0000   Min.   :0.0000  
##  1st Qu.:0.0000    1st Qu.:0.0000    1st Qu.:0.0000   1st Qu.:0.0000  
##  Median :0.8605    Median :0.9348    Median :0.0000   Median :0.0000  
##  Mean   :0.5150    Mean   :0.5475    Mean   :0.3831   Mean   :0.4071  
##  3rd Qu.:0.9111    3rd Qu.:0.9643    3rd Qu.:0.9032   3rd Qu.:0.9600  
##  Max.   :1.0000    Max.   :1.0000    Max.   :1.0000   Max.   :1.0000  
##  DL1_pct_of_3rd   DL2_pct_of_3rd   Squat1_kg_diff_3rd Squat2_kg_diff_3rd
##  Min.   :0.0000   Min.   :0.0000   Min.   : 0.0       Min.   : 0.000    
##  1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:10.0       1st Qu.: 2.500    
##  Median :0.0000   Median :0.0000   Median :15.0       Median : 5.000    
##  Mean   :0.4346   Mean   :0.4637   Mean   :15.8       Mean   : 6.262    
##  3rd Qu.:0.9000   3rd Qu.:0.9577   3rd Qu.:20.0       3rd Qu.:10.000    
##  Max.   :1.0000   Max.   :1.0000   Max.   :97.5       Max.   :52.500    
##  BP1_kg_diff_3rd  BP2_kg_diff_3rd DL1_kg_diff_3rd  DL2_kg_diff_3rd
##  Min.   : 0.000   Min.   : 0.00   Min.   :  0.00   Min.   : 0.00  
##  1st Qu.: 7.500   1st Qu.: 2.50   1st Qu.: 12.50   1st Qu.: 5.00  
##  Median :10.000   Median : 2.50   Median : 17.50   Median : 7.50  
##  Mean   : 9.881   Mean   : 3.73   Mean   : 18.58   Mean   : 7.37  
##  3rd Qu.:12.500   3rd Qu.: 5.00   3rd Qu.: 25.00   3rd Qu.:10.00  
##  Max.   :55.000   Max.   :22.50   Max.   :190.00   Max.   :55.00
```

**Step 9.** Calculate best successful attempt and create ratio of best lifts out of Total (sum of 3 best lifts)

- If a lifter fails all 3 attempts on one of the 3 lifts, their official Total = 0


```r
Raw2014_2016$Squat_best <- apply(Raw2014_2016[,c("Squat1", "Squat2", "Squat3")], 1, max)
Raw2014_2016$BP_best <- apply(Raw2014_2016[,c("Bench press1", "Bench press2", "Bench press3")], 1, max)
Raw2014_2016$DL_best <- apply(Raw2014_2016[,c("Deadlift1", "Deadlift2", "Deadlift3")], 1, max)

Raw2014_2016$Squat_best <- mapply(recode_neg_to_zero, Raw2014_2016$Squat_best, Raw2014_2016$Squat_best)
Raw2014_2016$BP_best <- mapply(recode_neg_to_zero, Raw2014_2016$BP_best, Raw2014_2016$BP_best)
Raw2014_2016$DL_best <- mapply(recode_neg_to_zero, Raw2014_2016$DL_best, Raw2014_2016$DL_best)

Raw2014_2016$Squat_shr <- Raw2014_2016$Squat_best / Raw2014_2016$Total
Raw2014_2016$BP_shr <- Raw2014_2016$BP_best / Raw2014_2016$Total
Raw2014_2016$DL_shr <- Raw2014_2016$DL_best / Raw2014_2016$Total

Raw2014_2016$Squat_shr <- mapply(recode_neg_to_zero, Raw2014_2016$Squat_shr, Raw2014_2016$Total)
Raw2014_2016$BP_shr <- mapply(recode_neg_to_zero, Raw2014_2016$BP_shr, Raw2014_2016$Total)
Raw2014_2016$DL_shr <- mapply(recode_neg_to_zero, Raw2014_2016$DL_shr, Raw2014_2016$Total)
```


```r
summary(Raw2014_2016[,57:62])
```

```
##    Squat_best       BP_best         DL_best        Squat_shr     
##  Min.   :  0.0   Min.   :  0.0   Min.   :  0.0   Min.   :0.0000  
##  1st Qu.:122.5   1st Qu.: 70.0   1st Qu.:147.5   1st Qu.:0.3386  
##  Median :175.0   Median :112.5   Median :202.5   Median :0.3560  
##  Mean   :173.2   Mean   :110.6   Mean   :197.9   Mean   :0.3406  
##  3rd Qu.:222.5   3rd Qu.:147.5   3rd Qu.:250.0   3rd Qu.:0.3726  
##  Max.   :456.0   Max.   :265.5   Max.   :383.0   Max.   :1.0000  
##      BP_shr           DL_shr      
##  Min.   :0.0000   Min.   :0.0000  
##  1st Qu.:0.2013   1st Qu.:0.3947  
##  Median :0.2226   Median :0.4157  
##  Mean   :0.2142   Mean   :0.3999  
##  3rd Qu.:0.2423   3rd Qu.:0.4381  
##  Max.   :0.5833   Max.   :1.0000
```

```r
aggregate(Squat_best ~ Sex, data = Raw2014_2016, mean)
```

```
##   Sex Squat_best
## 1   f   116.8764
## 2   m   207.9159
```

```r
aggregate(BP_best ~ Sex, data = Raw2014_2016, mean)
```

```
##   Sex   BP_best
## 1   f  67.04364
## 2   m 137.33732
```

```r
aggregate(DL_best ~ Sex, data = Raw2014_2016, mean)
```

```
##   Sex  DL_best
## 1   f 143.1020
## 2   m 231.6164
```

**Step 10.** Create a grouping variable for Wilks points (standardization metric across weight classes)

- Within "Raw" division, Wilks points usually range between 200 and 500. Currently Wilks max is held by Ray Williams with 593.5 points, but there are only around 60 lifters (male and female) with scores above 500


```r
aggregate(Points ~ Sex, data = Raw2014_2016, mean)
```

```
##   Sex   Points
## 1   f 336.0769
## 2   m 368.9860
```

```r
Raw2014_2016$Points_group <- 250
Raw2014_2016$Points_group[Raw2014_2016$Points > 250] <- 275
Raw2014_2016$Points_group[Raw2014_2016$Points > 275] <- 300
Raw2014_2016$Points_group[Raw2014_2016$Points > 300] <- 325
Raw2014_2016$Points_group[Raw2014_2016$Points > 325] <- 350
Raw2014_2016$Points_group[Raw2014_2016$Points > 350] <- 375
Raw2014_2016$Points_group[Raw2014_2016$Points > 375] <- 400
Raw2014_2016$Points_group[Raw2014_2016$Points > 400] <- 425
Raw2014_2016$Points_group[Raw2014_2016$Points > 425] <- 450
Raw2014_2016$Points_group[Raw2014_2016$Points > 450] <- 475
Raw2014_2016$Points_group[Raw2014_2016$Points > 475] <- 500
```


```r
aggregate(Points ~ Points_group, data = Raw2014_2016, max)
```

```
##    Points_group Points
## 1           250 249.35
## 2           275 274.91
## 3           300 299.94
## 4           325 325.00
## 5           350 349.92
## 6           375 374.89
## 7           400 399.97
## 8           425 424.88
## 9           450 449.87
## 10          475 474.90
## 11          500 581.69
```

```r
table(Raw2014_2016$Points_group, Raw2014_2016$Sex)
```

```
##      
##         f   m
##   250 105 123
##   275  52  32
##   300  67  38
##   325 109  85
##   350 136 137
##   375 165 192
##   400 144 266
##   425  94 257
##   450  38 211
##   475  21 108
##   500  20  97
```

**Step 11.** Create a counter variable for number of Raw Nationals for each lifter 

- Possible values for *meet_count*: 1 to 3


```r
Raw2014_2016 <- 
    Raw2014_2016 %>%
    group_by(Name) %>%
    mutate(meet_count = n_distinct(Meet))
```


```r
table(Raw2014_2016$meet_count)
```

```
## 
##    1    2    3 
## 1568  680  249
```




