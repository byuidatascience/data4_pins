pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, pins, connectapi)

# Data origin. This works.
race_info <- read_html("https://faculty.chicagobooth.edu/george.wu/research/marathon/marathon_names.htm") %>%
  html_nodes("table") %>%
  html_table() %>%
  .[[1]]

# Wrangle
colnames(race_info) <- race_info[1,]

race_info <- race_info[-1,] %>%
  as_tibble() %>%
  rename_all("str_to_lower") %>%
  mutate(year = as.integer(year), finishers = as.integer(finishers),
         `mean time` = as.numeric(`mean time`)) %>%
  rename(mean_time = `mean time`)

board <- board_connect()
pin_write(board, race_info, type = "parquet")

pin_name <- "race_info"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))

