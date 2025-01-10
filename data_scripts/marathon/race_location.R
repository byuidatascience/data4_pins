pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, connectapi)

# Download the file from google drive
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive) |>
  filter(stringr::str_detect(name, "race_location.csv"))
tempf <- tempfile()
drive_download(google_file, tempf)
race_location <-  read_csv(tempf)


board <- board_connect()
pin_write(board, race_location, type = "parquet")

pin_name <- "race_location"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
