pacman::p_load(tidyverse, pins)

# Grabs data from Lahman database, which is available in R.
baseball_births <- Lahman::People %>%
  select(nameGiven, playerID, birthMonth, birthDay, birthCountry, birthDate, debut, finalGame) %>%
  rename_all("str_to_lower") %>%
  rename_all(.funs = funs(str_remove_all(.,"birth"))) %>%
  mutate(from = year(ymd(debut)), to = year(ymd(finalgame)), yrs = to - from) %>%
  select(player = namegiven, birthday = date, yrs, from, to, everything(), -playerid, -debut, -finalgame) %>%
  filter(!is.na(birthday))

# Data details
dpr_document(baseball_births, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "baseball_births", 
             title = "The birth dates of MLB players",
             description = "Data obtained from Lahman http://www.seanlahman.com/baseball-archive/statistics/",
             source = "https://github.com/cdalzell/Lahman",
             var_details = baseball_description)


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, baseball_births, type = "parquet")

pin_name <- "baseball_births"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))