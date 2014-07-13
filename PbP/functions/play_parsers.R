parse_shots <- function(play_desc) {
    if (!require(stringr)) {
        stop("please install stringr")
    }
    parse <- str_match(play_desc, "^(.*) (makes|misses)( ([0-9]+)\\-foot)?([^(]*)(\\((.*) assists\\))?")
    data.frame(player    = str_trim(parse[,2]), 
               made      = str_trim(parse[,3])=="makes", 
               distance  = as.integer(parse[,5]), 
               type      = str_trim(parse[,6]), 
               assist    = str_trim(parse[,8]),
               block     = "",
               stringsAsFactors = FALSE)                   
}

parse_rebounds <- function(play_desc) {
    if (!require(stringr)) {
        stop("please install stringr")
    }
    parse <- str_match(play_desc, "(.*) (offensive|defensive) (team )?rebound")
    data.frame(player    = parse[,2],
               type      = parse[,3],
               team_ind  = ifelse(parse[,4] == "", "individual", "team"),
               stringsAsFactors = FALSE)
}

parse_freethrows <- function(play_desc) {
    if (!require(stringr)) {
        stop("please install stringr")
    }
    parse <- str_match(play_desc, "(.*) (makes|misses) (technical )?free throw( ([0-9]) of ([0-9]))?")
    data.frame(player    = parse[,2],
               made      = parse[,3] == "makes",
               tech      = str_trim(parse[,4]) == "technical",
               shot      = ifelse(parse[,6] == "", 1, parse[,6]),
               out_of    = ifelse(parse[,7] == "", 1, parse[,7]),
               stringsAsFactors = FALSE)
}


parse_badpass <- function(play_desc) {
    if (!require(stringr)) {
        stop("please install stringr")
    }
    parse <- str_match(play_desc, "(.*) bad pass( \\((.*) steals\\))?")
    data.frame(player    = parse[,2],
               type      = "bad pass",
               steal     = parse[,4],
               stringsAsFactors = FALSE)
}

parse_turnovers <- function(play_desc) {
    if (!require(stringr)) {
        stop("please install stringr")
    }
    parse <- str_match(play_desc, "((^|\\s)[^A-Z]+)?turnover( \\((.*) steals\\))?")
    names <- unlist(str_split(play_desc, "((^|\\s)[^A-Z]+)?turnover( \\((.*) steals\\))?"))
    data.frame(player    = names,
               type      = parse[,2],
               steal     = parse[,5],
               stringsAsFactors = FALSE)
}

parse_blockedshots <- function(play_desc) {
    if (!require(stringr)) {
        stop("please install stringr")
    }
    parse <- str_match(play_desc, "(.*) blocks (.*)\\'s ([0-9]+-foot )?([a-z ]+)$")

    data.frame(player    = str_trim(parse[,3]),
               made      = FALSE,
               distance  = str_trim(parse[,4]),
               type      = str_trim(parse[,5]),
               assist    = "",
               block     = str_trim(parse[,2]),
               stringsAsFactors = FALSE)
}
