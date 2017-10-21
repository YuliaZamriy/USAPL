library(ggplot2)

wilks_coef <- function(sex, bw) {
    if (sex == 'f') {
        a <- 594.31747775582
        b <- -27.23842536447
        c <- 0.82112226871
        d <- -0.00930733913
        e <- 4.731582E-05
        f <- -9.054E-08
    } else {
        a <- -216.0475144
        b <- 16.2606339
        c <- -0.002388645
        d <- -0.00113732
        e <- 7.01863E-06
        f <- -1.291E-08
    }
    
    wilks_coef <- 500 / (a + b*bw + c*bw**2 + d*bw**3 + e*bw**4 + f*bw**5)
    return(wilks_coef)
}


wilks_coef_der2 <- function(sex, bw) {
    if (sex == 'f') {
        a <- 594.31747775582
        b <- -27.23842536447
        c <- 0.82112226871
        d <- -0.00930733913
        e <- 4.731582E-05
        f <- -9.054E-08
    } else {
        a <- -216.0475144
        b <- 16.2606339
        c <- -0.002388645
        d <- -0.00113732
        e <- 7.01863E-06
        f <- -1.291E-08
    }
    
    wilks_coef_d2 <- 2*c + 6*d*bw + 12*e*bw**2 + 20*f*bw**3
    return(wilks_coef_d2)
}

wilks_calc <- function(sex, bw, total) {
    if (sex == 'f') {
        a <- 594.31747775582
        b <- -27.23842536447
        c <- 0.82112226871
        d <- -0.00930733913
        e <- 4.731582E-05
        f <- -9.054E-08
    } else {
        a <- -216.0475144
        b <- 16.2606339
        c <- -0.002388645
        d <- -0.00113732
        e <- 7.01863E-06
        f <- -1.291E-08
    }
    
    wilks_coef <- 500 / (a + b*bw + c*bw**2 + d*bw**3 + e*bw**4 + f*bw**5)
    wilks <- total * wilks_coef
    return(wilks)
}

wilks_calc('f', 81.53, 407.5)
wilks_calc('m', 52.72, 340.5)

total <- seq(from = 375, to = 450, by = 2.5)
plot(total, wilks_calc('f', 78.5, total), type = 'l')
lines(total, wilks_calc('f', 81.5, total))
abline(h = 400)
abline(v = 400 / wilks_coef('f', 78.5))
abline(v = 400 / wilks_coef('f', 81.5))

dev.off()

bodyweight <- seq(from = 40, to = 200, by = 1)

gg <- ggplot(mapping = aes(x = bodyweight))
gg + geom_line(aes(y = wilks_coef('f', bodyweight), color = "Female"), 
               lwd = 2) +
     geom_line(aes(x = bodyweight, y = wilks_coef('m', bodyweight), color = "Male"), 
               lwd = 2) +
    geom_line(aes(y = wilks_coef('f', bodyweight) - wilks_coef('m', bodyweight), color = "Difference"),
              lwd = 2) +
    xlab("Bodyweight (kg)") +
    ylab("Wilks Coefficient") +
    scale_color_manual("", 
                       values = c("Male" = "orange", 
                                  "Female" = "lightgreen", 
                                  "Difference" = "grey",
                                  "f" = "darkgreen",
                                  "m" = "salmon")) +
    scale_y_continuous(breaks = seq(0, 2, 0.1), 
                       sec.axis = sec_axis(~.*500, name = "Wilks", breaks = seq(0,600,50))) +
    scale_x_continuous(breaks = seq(40, 200, 10)) +
    geom_vline(xintercept = fem_bw_max_der2, color = "orange", linetype = 3, lwd = 2) +
    geom_vline(xintercept = mal_bw_max_der2, color = "green", linetype = 3, lwd = 2) +
    # geom_jitter(data = Raw2017, aes(x = Weight, y = Wilks_coef, color = Sex),
    #             alpha = 0.2,
    #             size = 3) +
    geom_point(data = Raw2017, aes(x = Weight, y = Points/500, color = Sex),
               alpha = 0.4,
               size = 2)



fem <- data.frame(bodyweight, "wilks_coef_der2" = wilks_coef_der2('f', bodyweight))
fem <- subset(fem, bodyweight < 150)
fem_max_der2 <- min(fem$wilks_coef_der2)
fem_bw_max_der2 <- fem$bodyweight[fem$wilks_coef_der2 == fem_max_der2]

gg <- ggplot(mapping = aes(x = fem$bodyweight))
gg + geom_line(aes(y = wilks_coef_der2('f', fem$bodyweight)),
               color = "orange",
               lwd = 1) +
    xlab("Bodyweight (kg)") +
    ylab("Second derivative for Wilks Coefficient") +
    scale_x_continuous(breaks = seq(40, 150, 10)) 

mal <- data.frame(bodyweight, "wilks_coef_der2" = wilks_coef_der2('m', bodyweight))
mal_max_der2 <- min(mal$wilks_coef_der2)
mal_bw_max_der2 <- mal$bodyweight[mal$wilks_coef_der2 == mal_max_der2]


plot(mal$bodyweight,mal$wilks_coef_der2, type = 'l')

mybodyweight <- seq(from = 72, to = 84, by = 0.1)

gg <- ggplot(mapping = aes(x = mybodyweight))
gg + geom_line(aes(y = 432.5*wilks_coef('f', mybodyweight)), 
               color = "green",
               lwd = 1) +
    xlab("Bodyweight (kg)") +
    ylab("Wilks Coefficient") +
    scale_x_continuous(breaks = seq(72, 84, 1)) +
    scale_y_continuous(breaks = seq(380, 430, 4)) +
    geom_line(aes(x = c(72, 84)), y = c(432.5*wilks_coef('f', 72), 432.5*wilks_coef('f', 84)),
              color = "orange",
              lwd = 1, 
              linetype=5)

yz <- data.frame(mybodyweight, "wilks_coef_der2" = wilks_coef_der2('f', mybodyweight))
max_der2 <- max(abs(yz$wilks_coef_der2))
bw_max_der2 <- yz$mybodyweight[yz$wilks_coef_der2 == max_der2*-1]

gg + geom_line(aes(y = wilks_coef_der2('f', mybodyweight)),
               color = "orange",
               lwd = 1) +
    xlab("Bodyweight (kg)") +
    ylab("Second derivative for Wilks Coefficient") +
    scale_x_continuous(breaks = seq(72, 84, 1)) 
    
   
