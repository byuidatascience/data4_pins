library(tidyverse)
library(pins)
library(arrow)
library(connectapi)
client <- connect()
my_app <- content_item(client, "8eb49f02-9b48-4a2e-b9e4-07101b2e6fd2")
set_vanity_url(my_app, "/cole/test")
get_vanity_url(my_app)

meta <- pin_meta(board2, "hathawayj/height_coef")

url_test <- "https://posit.byui.edu/data/childhealth_summary/"
board_url <- board_connect_url(c("test" = url_test))
board_url |> pin_read("test")


connectapi::get_content(client)
