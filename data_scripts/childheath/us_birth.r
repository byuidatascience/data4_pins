pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins)

hbgd_temp <- tempfile()

download('https://github.com/HBGDki/hbgd/raw/master/data/cpp.rda', hbgd_temp, mode = 'wb')

load(hbgd_temp)

birth_us <- cpp %>%
  group_by(subjid) %>%
  summarise(sex = sex[1], birthwt = birthwt[1], birthlen = birthlen[1], 
            apgar1 = apgar1[1], apgar5 = apgar5[1], mrace = mrace[1], 
            mage = mage[1], smoked = smoked[1], meducyrs = meducyrs[1], ses = ses[1]) %>%
  ungroup()


board <- board_connect()

pin_write(board, birth_us, type = "parquet", access_type = "all")
