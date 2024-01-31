


# Post as a json
board <- board_connect()
pin_write(board, race_location, type = "json")

pin_name <- "mtcars_missing_json"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
