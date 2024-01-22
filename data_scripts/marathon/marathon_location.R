pacman::p_load(tidyverse, downloader, fs, glue, rvest)


# Data is from master_marathon. Path doesn't exist. 
dat <- read_csv("/Users/hathawayj/odrive/Dropbox/data/master_marathon.csv")


# Data details
dpr_document(marathon_location, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_location", 
             title = "All of the runners for marathons with lat and long locations",
             description = "This data set has ~150k observations.",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details)

# Wrangling - filter only for the maximum year.
marathon_location <- filter(dat, marathon %in% race_location$marathon) %>% # race_location comes from race_location dataset and is needed for the filter. 
  group_by(marathon) %>%
  filter(year == max(year)) %>%
  ungroup() %>%
  select(age, gender, chiptime, year, marathon, country, finishers)


# The parquet thing. Do not run.
# board <- board_connect()
# pin_write(board, marathon_location, type = "parquet") 
# 
# pin_name <- "marathon_location"
# meta <- pin_meta(board, paste0("hathawayj/", pin_name))
# client <- connect()
# my_app <- content_item(client, meta$local$content_id)
# set_vanity_url(my_app, paste0("data/", pin_name))