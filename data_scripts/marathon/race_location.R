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





# 
# 
# # MARATHON SPATIAL
# 
# 
# pacman::p_load(tidyverse, sf, rvest, lubridate, stringdist, elevatr, googledrive)
# pacman::p_load_current_gh("rCarto/photon")
# 
# # IMPORT DATA
# # https://simplemaps.com/data/us-cities.
# sdrive <- shared_drive_find("byuids_data") # This will ask for authentication.
# google_file <- drive_ls(sdrive)  |>
#   filter(stringr::str_detect(name, "uscities"))
# tempf <- tempfile()
# drive_download(google_file, tempf)
# dat <- read_csv(tempf)
# 
# 
# 
# dat <- read_csv("https://github.com/byuidatascience/data4marathons/raw/master/data-raw/race_info/race_info.csv") %>%
#   filter(year >= 2010, country == "US") %>%
#   group_by(marathon) %>%
#   summarize(years = n(), finishers = sum(finishers), 
#             max_mean = max(mean_time, na.rm = TRUE)) %>%
#   ungroup() %>%
#   mutate(marathon_clean = str_remove_all(marathon, "\n"))
# 
# urls <- c("http://www.marathonguide.com/races/races.cfm?Sort=RaceDate&Place=USA&StartDate=01/01/20",
#           "http://www.marathonguide.com/races/races.cfm?Sort=RaceDate&Place=USA&StartDate=3/5/20",
#           "http://www.marathonguide.com/races/races.cfm?Sort=RaceDate&Place=USA&StartDate=5/7/20",
#           "http://www.marathonguide.com/races/races.cfm?Sort=RaceDate&Place=USA&StartDate=7/9/20",
#           "http://www.marathonguide.com/races/races.cfm?Sort=RaceDate&Place=USA&StartDate=9/10/20",
#           "http://www.marathonguide.com/races/races.cfm?Sort=RaceDate&Place=USA&StartDate=11/12/20",
#           "http://www.marathonguide.com/races/races.cfm?Sort=RaceDate&Place=USA&StartDate=1/14/21")
# 
# rip_race_location <- function(x){
#   print(x)
#   dhtml <- read_html(x)
#   dhtml %>%
#     html_nodes("table") %>% 
#     .[[8]] %>%
#     html_table(fill = TRUE)
# }
# 
# list_dat_locs <- urls %>% map(~rip_race_location(.x))
# 
# 
# list_clean <- function(dat_locs) {
#   
#   cnames <- dat_locs[2,] %>% str_to_lower() %>% str_replace_all("/", "_")
#   colnames(dat_locs) <- cnames
#   
#   str_remove_all(dat_locs$name, "- Day [:digit:]{1,2}| Day [:digit:]{1,2}")
#   
#   rows_remove <- which(str_count(dat_locs$state_province) != 2)
#   
#   dat_locs %>%
#     slice(-rows_remove) %>%
#     mutate(date = mdy(date), city_state = str_c(city, ", ", state_province),
#            name = str_remove_all(name, "- Day [:digit:]{1,2}| Day [:digit:]{1,2}"),
#            full_detail = str_c(name, ", ", city_state)) %>%
#     fill(date, .direction = "down") %>%
#     group_by(name) %>%
#     slice(1) %>%
#     ungroup()
#   
#   
# }
# 
# # sometimes it doesn't rip clean.  Just rerun the rip.
# 
# dat_locs <- map(list_dat_locs, list_clean) %>%
#   bind_rows() %>%
#   group_by(full_detail) %>%
#   slice(1) %>%
#   ungroup()
# 
# 
# rows_to_match <- dat_locs$city %>% map(~amatch(.x,cities$city_ascii)) %>% unlist()
# 
# dat_locs <- bind_cols(dat_locs, cities[rows_to_match, ] %>%
#                         select(lat, lng, city_ascii, state_id)) %>%
#   filter(!is.na(lng))
# 
# rows_name_match <- dat$marathon_clean %>% map(~amatch(.x,dat_locs$name, method = "jw")) %>% unlist()
# 
# 
# 
# dat_locs <- bind_cols(dat, 
#                       dat_locs[rows_name_match, c("date", "name", "lat", "lng", "state_id", "city_ascii")]) %>%
#   filter(!is.na(lat), !is.na(lng)) %>%
#   mutate(month = month(date), day = mday(date)) %>%
#   select(-date)
# 
# 
# elev_function <- function(x,y) {
#   print(str_c(x,"",y))
#   data.frame(x = x, y = y) %>%
#     get_elev_point(prj = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs", units = "meters", src = "aws", z =1)
# }
# 
# 
# 
# elevations_df <- map2(dat_locs$lng, dat_locs$lat, ~elev_function(.x, .y)) 
# 
# dat_locs <-dat_locs %>%
#   mutate(elevation_m = map(elevations_df, as_tibble) %>% map("elevation") %>% unlist())
# 
# write_csv(dat_locs, "data/marathon_locations.csv")