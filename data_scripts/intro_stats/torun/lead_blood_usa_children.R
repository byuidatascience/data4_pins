pacman::p_load(tidyverse, pins, connectapi, owidR)

# owid() function downloads current data directly from Our World in Data.
# Use owid_search() to search for other OWID datasets.
# For more information, see the package documentation here: https://github.com/piersyork/owidR/blob/main/README.md
lead_blood_usa_children <- owid('lead-blood-usa-children')

# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, lead_blood_usa_children, type = "parquet", access_type = "all")

pin_name <- "lead_blood_usa_children"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
