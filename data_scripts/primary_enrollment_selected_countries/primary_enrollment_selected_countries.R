pacman::p_load(tidyverse, pins, connectapi, owidR)

# owid() doesn't work for this dataset right now because of Error in `*tmp*`[[1]] : subscript out of bounds 5/8/2024

# # owid() function downloads current data directly from Our World in Data.
# # Use owid_search() to search for other OWID datasets.
# # For more information, see the package documentation here: https://github.com/piersyork/owidR/blob/main/README.md
# primary_enrollment_selected_countries <- owid('primary-enrollment-selected-countries')

# Until that issue is resolved, the data can be found in the google drive
# Download the file from google drive
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive) |>
  filter(stringr::str_detect(name, "primary-enrollment-selected-countries"))
tempf <- tempfile()
drive_download(google_file, tempf)
primary_enrollment_selected_countries <- read_csv(tempf)

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, primary_enrollment_selected_countries, type = "parquet", access_type = "all")

pin_name <- "primary_enrollment_selected_countries"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
