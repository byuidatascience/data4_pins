pacman::p_load(pins, tidyverse, downloader, fs, glue, rvest, connectapi)

# Load the data from Race Info.
url_data <- "https://posit.byui.edu/data/race_info/"
board_url <- board_connect_url(c("dat" = url_data))
dat <- pin_read(board_url, "dat")


# Wrangle
race_location <- select(race_locations,-finishers, -max_mean, -years) %>%
  left_join(race_info) %>%
  mutate(day = ifelse(month == 2 & day == 29, 28, day),
         date = mdy(str_c(month, "/", day, "/", year))) %>%
  select(marathon, marathon_name = name, state_id, city = city_ascii, finishers, mean_time, lat, lng, elevation_m, date, month, day, year, -marathon_clean )




board <- board_connect()
pin_write(board, race_location, type = "parquet")

pin_name <- "race_location"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))
