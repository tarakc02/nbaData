setwd("~/basketball statistics/nba/nbaData/PbP")
source("functions/get_and_clean.R")



#tests:
## to do: add quarter to PbP, join PbP and shotData
ESPNShot <- "http://sports.espn.go.com/nba/gamepackage/data/shot?gameId="
ESPNPbP <- "http://sports.espn.go.com/nba/playbyplay?gameId=__GAMEID__&period=0"
gameId <- "400489244"

PbP <- getPbPData(ESPNPbP, gameId)
PbPOlder <- getPbPData(ESPNPbP, "260214015")
PbP_clean <- cleanPbP(PbP)
PbPOlder_clean <- cleanPbP(PbPOlder)
shotRaw <- getShotData(ESPNShot, gameId)
shotDF <- cleanShotData(shotRaw)






play_anon <- gsub("<.+> ", "", PbP_clean[is.na(PbP_clean$play),"play_desc"])
play_anon <- gsub("\\s{1,}", " ", play_anon)
play_anon <- gsub("(\\s*\\b([A-Z][a-zA-z0-9]+)\\b)+", "__NAME__", play_anon)
play_anon <- gsub("[0-9]{1,2}-foot", "__DISTANCE__", play_anon)
unique(play_anon)
table(play_anon)
## end tests