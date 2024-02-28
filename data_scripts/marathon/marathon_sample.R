pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, googledrive, connectapi)


# Data is from master_marathon. 
sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "master_marathon"))
tempf <- tempfile()
drive_download(google_file, tempf)
dat <- read_csv(tempf)



# Wrangle
marathon_sample <- dat %>%
  filter(finishers > 50) %>%
  group_by(marathon, year, gender) %>%
  sample_n(50, replace = TRUE) %>%
  ungroup() %>%
  mutate(finishers = as.integer(finishers), year = as.integer(year))



board <- board_connect()
pin_write(board, marathon_sample, type = "parquet")

pin_name <- "marathon_sample"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
