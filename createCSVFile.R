x <- c(1,2)
y <- c("ja", "nee")

df <- data.frame(x,y)

   x<- Sys.time()
   x <- as.numeric(as.POSIXct(x))
   
  name <- paste0("file_", x)
  
  
  setwd("~/linuxtest/csv_files")
  write.csv(df, name)
