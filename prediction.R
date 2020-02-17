##### prediction on linear model 
# x and y values for prediction on classification model of 2016
x16 <- c(2013, 2015, 2016, 2017, 2019) # years 
y16 <- c(980.0100, 759.8700, 703.8900, 644.0400, 723.4200) # area in hectare 

# x and y values for prediction on classification model of 2019
x19 <- c(13, 16, 19) # years 
y19 <- c(828.4500, 799.0200, 723.4200) # area in hectare 

# timestamp for prediction 
newdata <- data.frame("x19"=c(19, 21, 65))

# linear model 
linearModel <- lm(y19~x19)

# prediction 
prediction <- predict(linearModel, newdata)

# plot of past course + prediction 
plot(c(x19,19, 21,65), c(y19,prediction), type="l",xlab="years in [2000-2100]",ylab="area of Hintertux glacier in hectare", main="past development and prediction of the Hintertux glacier (2013-2065) - linear model")
points(x19,y19,col="red")
abline(h=0, col="red")
points(60.766, 0, col="blue")
text(x=63, y=35, labels="2061", col="blue", cex= 1)

# plot of past course 
plot(x19, y19, type="l",xlab="years in [2000-2100]",ylab="area of Hintertux glacier in hectare", main="past development of the Hintertux glacier (2013-2019)" )
points(x19,y19,col="red")

# plot of prediction 
plot(c(2019, 2021, 2023, 2025, 2060, 2065), prediction, type="l",xlab="years",ylab="area of Hintertux glacier in hectare", main="prediction of Hintertux glacier development (2019-2065) - linear model" )
abline(h=0, col="red")
points(2060.766, 0, col="blue")
text(x=2063, y=35, labels="2061", col="blue", cex= 1.0)


##### prediction on logarithmic model 
# values we have calculated on classification model of 2019
x <- c(13, 16, 19) # years 
y <- c(828.4500, 799.0200, 723.4200) # area in hectare 

xt <- -log(x)
logarithmicModel <- lm(y~x+xt)

logarithmicFunction <- function(x){logarithmicModel$coefficients[1]+logarithmicModel$coefficients[2]*x+logarithmicModel$coefficients[3]*-log(x)}

# years which are considered 
newx <- c(13:35)

# calculation of the x-axial-section
uniroot(logarithmicFunction, c(20,100))

plot(newx, logarithmicFunction(newx), type="l", ylab="area of Hintertux glacier in hectare", xlab="years in [2000-2100]", main="prediction Hintertux glacier development (2013-2035) - logarithmic model")
points(x,y,col="red")
abline(h=0, col="red")
points(33.79766, 0, col="blue")
text(x=34.7, y=50, labels="2034", col="blue", cex= 1)
 


