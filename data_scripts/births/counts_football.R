library(tidyverse)

# Load in football births.
years <- 1900:1999

player_data_rip <- function(x) {
  print(x)
  read_html(str_c("https://www.pro-football-reference.com/years/", x, "/births.htm")) %>%
    html_nodes("table") %>% 
    html_table() %>%
    .[[1]] %>%
    .[,1:6] %>%
    as_tibble() %>%
    rename_all(str_to_lower)
}

dat_20th <- map(years, ~player_data_rip(.x))
# HTTP error 429, too many requests


football_births <- dat_20th %>%
  bind_rows() %>%
  mutate(birthdate = mdy(birthdate)) %>%
  select(player, birthday = birthdate, yrs, from, to, pos)

# Turn football_births into counts_football.
counts_football <- football_births %>%
  mutate(month = month(birthday), day = mday(birthday)) %>%
  count(month, day, name = "births") %>%
  mutate(day_of_year = 1:n()) %>%
  left_join(tibble(month = 1:12, month_name = month.name)) %>%
  select(month_number = month, month_name, day_of_month = day, day_of_year, births)




# Data details
dpr_document(counts_football, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "counts_football", 
             title = "The count of births of NFL players",
             description = "Data obtained from https://www.pro-football-reference.com",
             source = "https://www.pro-football-reference.com/years/1900/births.htm",
             var_details = counts_description)



# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, counts_football, type = "parquet")

pin_name <- "counts_football"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))