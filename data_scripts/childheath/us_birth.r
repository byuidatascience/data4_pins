pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, , pins, connectapi)

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

pin_name <- "birth_us"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
