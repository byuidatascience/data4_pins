pacman::p_load(tidyverse, pins, connectapi, owidR)

# owid() function downloads current data directly from Our World in Data.
# Use owid_search() to search for other OWID datasets.
# For more information, see the package documentation here: https://github.com/piersyork/owidR/blob/main/README.md
access_drinking_water_stacked <- owid('access-drinking-water-stacked')

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, access_drinking_water_stacked, type = "parquet", access_type = "all")

pin_name <- "access_drinking_water_stacked"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
