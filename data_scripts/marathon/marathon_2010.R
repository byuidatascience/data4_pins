pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, googledrive, connectapis)


# Data is from master_marathon. 
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "master_marathon"))
tempf <- tempfile()
drive_download(google_file, tempf)
dat <- read_csv(tempf)


# Wrangle (filter to 2010)
marathon_2010 <- dat %>%
  filter(year == 2010)



board <- board_connect()
pin_write(board, marathon_2010, type = "parquet")

pin_name <- "marathon_2010"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))


