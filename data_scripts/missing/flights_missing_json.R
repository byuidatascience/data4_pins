
# Data is from google drive.
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "airlines_missing"))
tempf <- tempfile()
drive_download(google_file, tempf)

# Read it as a JSON.
flights_missing <- fromJSON(tempf) %>%
  flatten() %>%
  as_tibble() %>%
  rename_with(str_to_lower) %>%
  rename_with(~str_replace_all(., " ", "_"))


# Post as a json
board <- board_connect()
pin_write(board, flights_missing_json, type = "json")

pin_name <- "flights_missing_json"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))

