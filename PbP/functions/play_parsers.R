require(stringr)
parseShots <- function(playDesc) {
    plays <- playDesc
    parse <- str_match(plays, "^(.*) (makes|misses)( ([0-9]+)\\-foot)?([^(]*)(\\((.*) assists\\))?")
    data.frame(player=str_trim(parse[,2]), 
               made=str_trim(parse[,3])=="makes", 
               distance=as.integer(parse[,5]), 
               shotType=str_trim(parse[,6]), 
               assist=str_trim(parse[,8]))                   
}