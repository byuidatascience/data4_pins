pacman::p_load(tidyverse, googledrive, connectapi)

sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "led_study.csv"))
tempf <- tempfile()
drive_download(google_file, tempf)
led_study <- read_csv(tempf)

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, led_study, type = "parquet")

pin_name <- "led_study"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))