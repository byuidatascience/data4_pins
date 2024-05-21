pacman::p_load(tidyverse, pins, connectapi, googledrive)

# Download the file from google drive
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive) |>
  filter(stringr::str_detect(name, "carwash"))
tempf <- tempfile()
drive_download(google_file, tempf)
car_wash <-  read_csv(tempf)

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, car_wash, type = "parquet", access_type = "all")

pin_name <- "car_wash"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))