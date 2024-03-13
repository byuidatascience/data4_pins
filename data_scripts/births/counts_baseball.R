library(tidyverse)

# Grabs data from Lahman database, which is available in R (from baseball_births)
baseball_births <- Lahman::People %>%
  select(nameGiven, playerID, birthMonth, birthDay, birthCountry, birthDate, debut, finalGame) %>%
  rename_all("str_to_lower") %>%
  rename_all(.funs = funs(str_remove_all(.,"birth"))) %>%
  mutate(from = year(ymd(debut)), to = year(ymd(finalgame)), yrs = to - from) %>%
  select(player = namegiven, birthday = date, yrs, from, to, everything(), -playerid, -debut, -finalgame) %>%
  filter(!is.na(birthday))

# Wrangling baseball_births into counts_baseball
counts_baseball <- baseball_births %>%
  filter(country == "USA", year(birthday) > 1925, year(birthday) < 2015) %>%
  count(month, day, name = "births") %>%
  mutate(day_of_year = 1:n()) %>%
  left_join(tibble(month = 1:12, month_name = month.name)) %>%
  select(month_number = month, month_name, day_of_month = day, day_of_year, births)

# Data details
dpr_document(counts_baseball, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "counts_baseball", 
             title = "The count of births of MLB players for US born players from 1925 to 2015",
             description = "Data obtained from Lahman http://www.seanlahman.com/baseball-archive/statistics/",
             source = "https://github.com/cdalzell/Lahman",
             var_details = counts_description)


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, counts_baseball, type = "parquet")

pin_name <- "counts_baseball"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))