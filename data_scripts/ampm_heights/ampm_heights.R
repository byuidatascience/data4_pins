library(tidyverse)

ampm_heights <- read_csv('https://github.com/byuistats/data/raw/master/AMPM-Heights/AMPM-Heights.csv')

# Heights seem to be in mm. When converted to feet from mm the numbers are in expected ranges for human heights. 

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, ampm_heights, type = "parquet")

pin_name <- "ampm_heights"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))