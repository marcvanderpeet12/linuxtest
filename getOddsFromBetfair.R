getOddsFromBetfair <- function(club1, club2, country){
  
  setwd("C:/Users/Marc/Dropbox/PROJECTEN/Lopend/clean_code_prediction/Updaten")
  source("connectBetFair.R")
  
  #load in libraries
  require("RCurl")
  require("jsonlite")
  require("abettor")
  
  var1 <- paste0("^",club1)
  var2 <- club2
  
  #login to betfair
  loginBF(username = "marcvanderpeet@gmail.com", password = "Kamphuys12", applicationKey = "LDSimh9VJcQXLKqw")
  
  listMatches <- listMarketCatalogue(eventTypeIds = "1", marketCountries = country, marketTypeCodes = "MATCH_ODDS")
  listMatches_spec <- listMatches[grep(var1, listMatches$event$name), ]
  
  #get marketID
  ourMarketId <- listMatches_spec$marketId
  
  #get selectionID
  runners <- listMatches_spec$runners[[1]][ , c("selectionId","runnerName")]
  
  homeTeam <- runners[grep(var1, runners$runnerName), ]
  ourSelectionId1 <- homeTeam$selectionId
  
  awayTeam <- runners[grep(var2, runners$runnerName), ]
  ourSelectionId2 <- awayTeam$selectionId
  
  tie <- runners[grep("Draw", runners$runnerName), ]
  ourSelectionId3 <- tie$selectionId
  
  ourMarketIdPrices <- listMarketBook(marketIds = ourMarketId, priceData = "EX_ALL_OFFERS")
  allPrices <- ourMarketIdPrices$runners
  
  ourSelectionIdPrices1 <- allPrices[[1]][which(allPrices[[1]]$selectionId == ourSelectionId1),]
  ourSelectionIdPricesDF1 <- data.frame(ourSelectionIdPrices1$ex[[1]])
  ourSelectionBestPrice1 <- ourSelectionIdPricesDF1[1,c("price")]
  
  ourSelectionIdPrices2 <- allPrices[[1]][which(allPrices[[1]]$selectionId == ourSelectionId2),]
  ourSelectionIdPricesDF2 <- data.frame(ourSelectionIdPrices2$ex[[1]])
  ourSelectionBestPrice2 <- ourSelectionIdPricesDF2[1,c("price")]
  
  ourSelectionIdPrices3 <- allPrices[[1]][which(allPrices[[1]]$selectionId == ourSelectionId3),]
  ourSelectionIdPricesDF3 <- data.frame(ourSelectionIdPrices3$ex[[1]])
  ourSelectionBestPrice3 <- ourSelectionIdPricesDF3[1,c("price")]
  
  print(ourSelectionBestPrice1)
  ourSelectionBestPrice2 <- 2
  print(ourSelectionBestPrice3)
  
  df_bets <- data.frame(ourSelectionBestPrice1, ourSelectionBestPrice2, ourSelectionBestPrice3)
  
  time <- Sys.time()
  time <- format(Sys.time(), "%M_%H_%d")
  var <- paste0("excel_", time, ".csv")
  write.csv(df_bets, var)
}
