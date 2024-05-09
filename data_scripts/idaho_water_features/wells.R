pacman::p_load(tidyverse, pins, connectapi, sf, fs)

# Download the file from google drive
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive) |>
  filter(stringr::str_detect(name, "Wells"))
tempf <- tempfile()
drive_download(google_file, tempf)


# UNZIP
# Make a temp file for the extraction directory (files are zipped)
exdir <- tempfile()

# Unzip the file and export it to the tempfile directory
unzip(tempf, exdir = exdir)

# Convert data into an sf object
wells <- read_sf(exdir)

# Delete chonky tempfile (for saving space)
file_delete(exdir)


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, climate_change_antarctica, type = "parquet", access_type = "all")

pin_name <- "climate_change_antarctica"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))