pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins, connectapi)

hbgd_temp <- tempfile()

download('https://github.com/HBGDki/hbgd/raw/master/data/cpp.rda', hbgd_temp, mode = 'wb')

load(hbgd_temp)

childhealth_us <- cpp %>%
  select(subjid, sex, agedays, gagebrth, htcm, wtkg, haz, waz, mrace, mage, meducyrs, ses)

board <- board_connect()
pin_write(board, childhealth_us, type = "parquet", access_type = "all")

pin_name <- "childhealth_us"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
