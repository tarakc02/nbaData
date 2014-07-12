source("functions/get_and_clean.R")

#tests:
shot <- "http://sports.espn.go.com/nba/gamepackage/data/shot?gameId="
pbp <- "http://sports.espn.go.com/nba/playbyplay?gameId=__GAMEID__&period=0"
game_id <- "400489244"

pbp_raw <- get_pbp(pbp, game_id)
pbp_clean <- clean_pbp(pbp_raw)
shots <- get_shots(shot, game_id)
shots_clean <- clean_shots(shots)

pbp2_raw <- get_pbp(pbp, "260214015")
pbp2_clean <- clean_pbp(pbp2_raw)
pbp3_raw <- get_pbp(pbp, "400489678")
pbp3_clean <- clean_pbp(pbp3_raw)

