pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins)

t.dat <- tempfile()
download("https://github.com/stefvanbuuren/brokenstick/raw/71dc99e62ce57b58d5c1d2a1074fbd4bf394e559/data/smocc_hgtwgt.rda",t.dat, mode = "wb")

load(t.dat)

birth_dutch <- smocc_hgtwgt %>%
  group_by(subjid) %>%
  summarise(sex = sex[1], birthwt = birthwt[1]) %>%
  ungroup()


board <- board_connect()

pin_write(board, birth_dutch, type = "parquet", access_type = "all")
