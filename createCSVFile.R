x <- c(1,2)
y <- c("ja", "nee")

df <- data.frame(x,y)
write.csv(df, "test1.csv")