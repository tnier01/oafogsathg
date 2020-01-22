# x and y values for prediction on classification model of 2016
x16 <- c(2013, 2015, 2016, 2017, 2019)
y16 <- c(9800100, 7598700, 7038900, 6440400, 7234200)

# x and y values for prediction on classification model of 2019
x19 <- c(2013, 2016, 2019)
y19 <- c(8284500, 7990200, 7234200)

# linear model 
model <- lm(y19~x19)

# timestamp for prediction 
newdata <- data.frame("x19"=c(2019, 2021,2023,2025,2060, 2061))

# prediction 
prediction <- predict(model, newdata)

# plot of past course + prediction 
plot(c(x19,2019, 2021,2023,2025,2060, 2061), c(y19,prediction), type="l",xlab="years",ylab="area of Hintertux glacier in square meters", main="past course and prediction of Hintertux glacier shrinkage (2013-2061)")
points(x19,y19,col="red")

# plot of past course 
plot(x19, y19, type="l",xlab="years",ylab="area of Hintertux glacier in square meters", main="past course Hintertux glacier shrinkage (2013-2019)" )
points(x19,y19,col="red")

# plot of prediction 
plot(c(2019, 2021, 2023, 2025, 2060, 2061), prediction, type="l",xlab="years",ylab="area of Hintertux glacier in square meters", main="prediction of Hintertux glacier shrinkage (2019-2061)" )



