library(tidyverse)
library(pins)
library(connectapi)
library(owidR)

# owid() function downloads current data directly from Our World in Data.
# Use owid_search() to search for other OWID datasets.
# For more information, see the package documentation here: https://github.com/piersyork/owidR/blob/main/README.md
share_of_adults_who_smoke <- owid('share-of-adults-who-smoke')

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, share_of_adults_who_smoke, type = "parquet", access_type = "all")

pin_name <- "share_of_adults_who_smoke"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
