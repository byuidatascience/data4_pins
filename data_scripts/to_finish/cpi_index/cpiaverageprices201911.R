pacman::p_load(tidyverse, pins, connectapi, googledrive, readxl)

# Download the file from google drive
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive) |>
  filter(stringr::str_detect(name, "cpiaverageprices201911"))
tempf <- tempfile()
drive_download(google_file, tempf) # Error: `file` does not identify at least one Drive file.
cpiaverageprices201911 <- read_excel(tempf)


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, cpiaverageprices201911, type = "parquet", access_type = "all")

pin_name <- "cpiaverageprices201911"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))