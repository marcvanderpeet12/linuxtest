setwd("~/linuxtest/")
source("getOddsFromBetfair.R")

getDates <- function(startDate, endDate){
  
  setwd("C:/Users/Marc/Dropbox/PROJECTEN/Lopend/clean_code_prediction/datapreparatie/data/seasons")
  df <- read.csv("seasonData_8_2015-2016.csv")
  df$Date <- as.Date(df$Date, format = c("%d/%m/%y"))

  myfunc <- function(x,y){df[df$Date >= x & df$Date <= y,]}
  
  DATE1 <- as.Date("2015-08-08")
  DATE2 <- as.Date("2015-08-14")
  
  Test <- myfunc(DATE1,DATE2)   
  Test$Home.Team.ID <- as.numeric(Test$Home.Team.ID)
  Test$Away.Team.ID <- as.numeric(Test$Away.Team.ID)
  
  return(Test)
  
}

getMatchData <- function(){

  sql <- sprintf("SELECT * FROM club_specific")
  df <- dbGetQuery(con, sql)

  df$scoresway_id <- as.numeric(df$scoresway_id)
  
  return(df)
  
}
  

### This produces the betfair values
matchWithBetFairID <- function(df, Test){

   df_new <- data.frame(x = character(), y = character(), z = character())

   for (i in 1:nrow(Test)){
  
     #BetFair homename
     home_id <- Test$Home.Team.ID[i]
     df_temp1 <- df[df$scoresway_id == home_id, ]
  
      if(is.data.frame(df_temp1) && nrow(df_temp1)==0){
        x <- "NA"
      } else {
        x <- df_temp1$club_betfair[1]
      }
     
     #BetFair awayTeam
     away_id <- Test$Away.Team.ID[i]
     df_temp2 <- df[df$scoresway_id == away_id, ]
     
     if(is.data.frame(df_temp2) && nrow(df_temp2)==0){
       y <- "NA"
     } else {
       y <- df_temp2$club_betfair[1]
       z <- df_temp2$club_country_code[1]
     }

     df_add <- data.frame(x,y,z)
     df_new <- rbind(df_new, df_add)
   }
}

getOddsFromBetfair(df_new$x[1], df_new$y[1], df_new$z[1])
getOddsFromBetfair("Stoke", "Tottenham", "GB")
getOddsFromBetfair("Benfica", "Setubal", "PT")
getOddsFromBetfair("Braunschweig", "Freiburg", "DE")
