pacman::p_load(tidyverse, pins, connectapi, googledrive, owidR)

# pwid() doesn't work for this dataset right now because the source site is down 5/8/2024

# # owid() function downloads current data directly from Our World in Data.
# # Use owid_search() to search for other OWID datasets.
# # For more information, see the package documentation here: https://github.com/piersyork/owidR/blob/main/README.md
# climate_change_ocean <- owid('climate-change-ocean')

# Until that issue is resolved, the data can be found in the google drive
# Download the file from google drive
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive) |>
  filter(stringr::str_detect(name, "climate-change-ocean"))
tempf <- tempfile()
drive_download(google_file, tempf)
climate_change_ocean <- read_csv(tempf)

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, climate_change_ocean, type = "parquet", access_type = "all")

pin_name <- "climate_change_ocean"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
