pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, googledrive, connectapi)


# Data is from master_marathon. 
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "master_marathon"))
tempf <- tempfile()
drive_download(google_file, tempf)
dat <- read_csv(tempf)



# Wrangling - filter only for the maximum year.
marathon_location <- filter(dat, marathon %in% race_location$marathon) %>% # race_location comes from race_location dataset and is needed for the filter. 
  group_by(marathon) %>%
  filter(year == max(year)) %>%
  ungroup() %>%
  select(age, gender, chiptime, year, marathon, country, finishers)


board <- board_connect()
pin_write(board, marathon_location, type = "parquet")

pin_name <- "marathon_location"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))

