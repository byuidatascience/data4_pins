pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins)

tdat <- tempfile()
download("https://github.com/stefvanbuuren/brokenstick/raw/71dc99e62ce57b58d5c1d2a1074fbd4bf394e559/data/smocc_hgtwgt.rda",tdat, mode = "wb")

load(tdat)

childhealth_dutch <- smocc_hgtwgt |>
  select(subjid, sex, agedays, gagebrth, htcm, wtkg, haz, waz)

board <- board_connect()

pin_write(board, childhealth_dutch, "childhealth_dutch", type = "parquet", access_type = "all")

pin_name <- "childhealth_dutch"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
