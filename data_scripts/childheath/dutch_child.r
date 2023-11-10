pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins)

tdat <- tempfile()
download("https://github.com/stefvanbuuren/brokenstick/raw/71dc99e62ce57b58d5c1d2a1074fbd4bf394e559/data/smocc_hgtwgt.rda",tdat, mode = "wb")

load(tdat)

childhealth_dutch <- smocc_hgtwgt |>
  select(subjid, sex, agedays, gagebrth, htcm, wtkg, haz, waz)

board <- board_connect()

pin_write(board, childhealth_dutch, "childhealth_dutch", type = "parquet", access_type = "all")



