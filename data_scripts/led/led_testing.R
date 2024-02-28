pacman::p_load(tidyverse, googledrive, connectapi)

sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
google_file <- drive_ls(sdrive)  |>
  filter(stringr::str_detect(name, "led_testing.csv"))
tempf <- tempfile()
drive_download(google_file, tempf)
led_testing <- read_csv(tempf)