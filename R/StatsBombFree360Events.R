StatsBombFree360Events <- function(MatchesDF = "ALL", Parallel = T){
  print("Whilst we are keen to share data and facilitate research, we also urge you to be responsible with the data. Please credit StatsBomb as your data source when using the data and visit https://statsbomb.com/media-pack/ to obtain our logos for public use.")
  events.df <- tibble()
  
  if(Parallel == T){
    if(MatchesDF == "ALL"){
      Matches2 <- FreeMatches(FreeCompetitions())
      
      cl <- makeCluster(detectCores())
      registerDoParallel(cl)
      
      
      events.df <- foreach(i = 1:dim(Matches2)[1], .combine=bind_rows, .multicombine = TRUE,
                           .errorhandling = 'remove', .export = c("get.360matchFree"),
                           .packages = c("httr", "jsonlite", "dplyr")) %dopar%
        {get.matchFree(Matches2[i,])}
      
      stopCluster(cl)
      
      
    } else { ##Begin else Parallel == T All = F
      
      cl <- makeCluster(detectCores())
      registerDoParallel(cl)
      
      events.df <- foreach(i = 1:dim(MatchesDF)[1], .combine=bind_rows, .multicombine = TRUE,
                           .errorhandling = 'remove', .export = c("get.360matchFree"),
                           .packages = c("httr", "jsonlite", "dplyr")) %dopar%
        {get.360matchFree(MatchesDF[i,])}
      
      stopCluster(cl)
      
    }
  }  else { #Begin Else, parallel == F
    if(MatchesDF == "ALL"){
      Matches2 <- FreeMatches(FreeCompetitions())
      for(i in 1:length(Matches2$match_id)){
        events <- get.360matchFree(Matches2[i,])
        events.df <- bind_rows(events.df, events)
      }
      
    } else {
      for(i in 1:length(MatchesDF$match_id)){
        events <- get.360matchFree(MatchesDF[i,])
        events.df <- bind_rows(events.df, events)
      }
      
    }
  } #End else parallel
  return(events.df)
} ##End function
