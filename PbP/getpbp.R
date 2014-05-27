setwd("~/basketball statistics/nba/scrape pbp")
library(XML)
library(RCurl)
library(ggplot2)


ESPNShot <- "http://sports.espn.go.com/nba/gamepackage/data/shot?gameId="
ESPNPbP <- "http://sports.espn.go.com/nba/playbyplay?gameId=__GAMEID__&period=0"
gameId <- "320223025"

getPbPData <- function(ESPNPbP, gameId) {
  if (require(XML) & require(RCurl)) {
    PbPURL <- sub("__GAMEID__", gameId, ESPNPbP)
    PbP <- readHTMLTable(PbPURL, stringsAsFactors=FALSE)
    
    # it's a bit of a hack to assume that this will always work
    PbP <- PbP[[length(PbP)]]
    return(PbP)
  }
}


getShotData <- function(ESPNShot, gameId) {
  if (require(XML) & require(RCurl)) {
    shotURL <- paste(ESPNShot, gameId, sep="")
    shots <- getURL(shotURL)
    
    parsed_shots <- xmlParse(shots)
    parsed_shots <- xmlToList(parsed_shots)
    names(parsed_shots) <- sapply(parsed_shots, function(x) x["id"])
    return(parsed_shots)
  }
}

parseShotDesc <- function(shotDesc) {
  sub("(Made|Miss) ([0-9]{1,2})ft (jumper|3-pointer) ([0-9]{1,2}):([0-9]{2})(.*)", "\\1;\\2;\\4;\\5", shotDesc)
}

cleanShotData <- function(shotData) {
  df <- (do.call(rbind, shotData))
  df <- data.frame(df, stringsAsFactors=FALSE)
  df$x <- as.integer(df$x)
  df$y <- as.integer(df$y)
  df$pid <- as.factor(df$pid)
  df$qtr <- as.integer(df$qtr)
  df$t <- as.factor(df$t)
  df$made <- as.logical(df$made)
  
  df$y_adj <- ifelse(df$t=="h", 94-df$y, df$y)
  df$x_adj <- ifelse(df$t=="h", 50-df$x, df$x)
  
  parsed_desc <- parseShotDesc(df$d)
  parsed_desc <- do.call(rbind, strsplit(parsed_desc, ";"))
  df$made_basket <- parsed_desc[,1] == "Made"
  df$dist <- as.integer(parsed_desc[,2])
  df$min <- as.integer(parsed_desc[,3])
  df$sec <- as.integer(parsed_desc[,4])
  df$time <- df$min*60 + df$sec
  
  return(df)
}

getQuarter <- function(PbP) {
  PbP[grep("(Start|End) of the ([0-9])(st|nd|rd|th) (Quarter|Overtime)", PbP[,2]),] <-
    sub()
}

cleanPbP <- function(PbP) {
  PbP <- PbP[grep(":", PbP$TIME),]
  rownames(PbP) <- seq(nrow(PbP))
  times <- do.call(rbind, strsplit(PbP$TIME, ":"))
  PbP$seconds_left <- (as.integer(times[,1]) *60) + as.integer(times[,2])  
  return(PbP)
}



#tests:
## to do: add quarter to PbP, join PbP and shotData

PbP <- getPbPData(ESPNPbP, gameId)
PbP_clean <- cleanPbP(PbP)
shotRaw <- getShotData(ESPNShot, gameId)
shotDF <- cleanShotData(shotRaw)

## end tests