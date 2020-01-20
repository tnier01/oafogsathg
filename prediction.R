x <- c(2013, 2015, 2017)

y <- c(9800100, 7598700, 6440400)

plot(x, y, type="l")

model <- lm(y~x)

plot(model)

newdata <- data.frame("x"=c(2019, 2021,2023,2025))

prediction <- predict(model, newdata)

prediction

plot(c(x,2019, 2021,2023,2025), c(y,prediction), type="l")

