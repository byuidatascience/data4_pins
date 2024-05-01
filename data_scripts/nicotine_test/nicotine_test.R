library(tidyverse)
library(pins)
library(connectapi)

nicotine_test <- read_csv('https://github.com/byuistats/data/raw/master/Nicotine_Test/Nicotine_Test.csv') %>% 
  select(!Description) # Delete description column becuase that information goes into the qmd


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, nicotine_test, type = "parquet", access_type = "all")

pin_name <- "nicotine_test"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))