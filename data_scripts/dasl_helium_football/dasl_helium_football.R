library(tidyverse)

dasl_helium_football <- read_csv('')


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, dasl_helium_football, type = "parquet")

pin_name <- "dasl_helium_football"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))