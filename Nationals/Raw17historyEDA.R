summary(Raw2017only$Points)
sum(is.na(Raw2017only$Points))
sum(Raw2017only$Points == 0)

ind_vars <- c("Weight", "Sex", "Division_group", "CompAge", "UnderWeight", "UnderWeightPct", "WeightChg",
              "WeightChgPct", "CompCount", "FirstCompAge", "CompAgeYrs", "CompAgeDays",
              "DaysSincePrevComp","MonthsSincePrevComp", "TotalChgPerMonth", "AvgMonthsSincePrevComp")

all_num_vars <- c("Points", "Weight", "CompAge", "UnderWeight", "UnderWeightPct", "WeightChg",
              "WeightChgPct", "CompCount", "FirstCompAge", "CompAgeDays",
              "DaysSincePrevComp","AvgMonthsSincePrevComp")

num_var_labels <- c("Lifter's Body Weight in kg",
                "Age During Competition",
                "Kgs under Class Weight",
                "Pct under Class Weight",
                "Kg Change in Lifter's BW from prev Comp",
                "Pct Change in Lifter's BW from prev Comp",
                "Number of Competitions",
                "Age During First Competition",
                "Days Competing",
                "Days Since Previous Competition",
                "Avg Number of Months b/w Comps")

# num_vars <- Raw2017only[,sapply(Raw2017only, is.numeric)]

# Correlation Matrix
num_vars <-
    Raw2017only %>% 
    select(one_of(all_num_vars))
num_vars$Name <- NULL

points_cor <- data.frame(cor(num_vars)[-1,1])
points_cor <- rownames_to_column(points_cor)
colnames(points_cor) <- c("LifterParameters", "Correlation_with_Points")

points_cor <- 
    points_cor %>% 
    cbind(num_var_labels)

cor_plot <- ggplot(data = points_cor, 
                   mapping = aes(x = reorder(num_var_labels, Correlation_with_Points), 
                                 y = Correlation_with_Points))
cor_plot + 
    geom_bar(stat="Identity", aes(fill = num_var_labels)) +
    geom_text(aes(label = round(Correlation_with_Points,3)),
              hjust = ifelse(points_cor$Correlation_with_Points >= 0, -0.4, 1.2)) +
    theme_bw() +
    theme(legend.position="none") +
    labs(y = "Correlation with Wilks Points",
         x = "Lifter Parameters") +
    ylim(-0.4, 0.4) +
    coord_flip() +
    ggtitle("Correlation between Lifter Success (Wilks Points) and Their Entry Parameters",
            subtitle = "at Raw Nationals 2017")
    
# Charts

g <- ggplot(data = Raw2017only, 
            mapping = aes(CompCount, group = Division_group, fill = Sex)) 

g + geom_bar() +
    labs(x = "Number of Competitions",
         y = "Lifter Count") +
    scale_x_continuous(breaks = seq(0,26,2)) +
    scale_fill_manual("",
                      values = c("Male" = "orange", 
                                 "Female" = "darkgreen"))  +
    ggtitle("Competition Experience (Number of Comps) of Lifters at Raw Natiionals in 2017") +
    facet_grid(Division_group ~ Sex) +
    theme(legend.position = "none")

g <- ggplot(data = Raw2017only, 
            mapping = aes(CompAgeYrs, group = Division_group, fill = Sex)) 

g + geom_bar() +
    labs(x = "Number of Years Competing",
         y = "Lifter Count") +
    scale_x_continuous(breaks = seq(0,5,1)) +
    scale_fill_manual("",
                      values = c("Male" = "orange", 
                                 "Female" = "darkgreen"))  +
    ggtitle("Competition Experience (in Years) of Lifters at Raw Natiionals in 2017") +
    facet_grid(Division_group ~ Sex) +
    theme(legend.position = "none")


# Regressions

Points_form <- as.formula(paste("Points ~", paste(ind_vars, collapse = "+"), sep = ""))

Points_lm0 <- lm(Points ~ 1,
                data = Raw2017only,
                subset = Raw2017only$Points > 0)


Points_lm1 <- lm(Points_form,
                 data = Raw2017only,
                 subset = Raw2017only$Points > 0)

Points_lm2 <- step(Points_lm0, scope=list(lower=Points_lm0, upper=Points_lm1), direction="both")

str(Points_lm2)
summary(Points_lm2)

Points_lm2$terms

Points_lm3 <- lm(Points ~ 
                Division_group + 
                    Sex + 
                    FirstCompAge + 
                    CompCount + 
                    UnderWeightPct + 
                    UnderWeight,
                data = Raw2017only,
                subset = Raw2017only$Points > 0)

summary(Points_lm3)