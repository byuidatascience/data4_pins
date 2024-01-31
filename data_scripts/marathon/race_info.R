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





# Data details
# dpr_document(race_info, extension = ".R.md", export_folder = usethis::proj_get(),
#              object_name = "race_info", title = "Table of Information about Marathons",
#              description = "An interesting data set to see the effects of goals on what should be a unimodal distrubtion of finish times. The NYT had a good article - https://www.nytimes.com/2014/04/23/upshot/what-good-marathons-and-bad-investments-have-in-common.html?rref=upshot&_r=1",
#              source = "https://faculty.chicagobooth.edu/george.wu/research/marathon/marathon_names.htm",
#              var_details = list(year = "The year of the marathon", 
#                                 marathon = "The name of the marathon",
#                                 country = "The country where the marathon was held",
#                                 finishers = "The number of finishers at the marathon",
#                                 mean_time = "The average finish time in minutes."))
# 
