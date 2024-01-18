# Data origin
race_locations <- read_csv("data/marathon_locations.csv")

# Data origin
race_locations <- read_csv("data/marathon_locations.csv")

# Data details
dpr_document(race_location, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "race_location", 
             title = "",
             description = "This data set has ~2k observations.",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm and https://simplemaps.com/data/us-cities",
             var_details = list(marathon = "The name of the marathon that matches all other files",
                                marathon_name = "A cleaned name of the marathon",
                                state_id = "The two letter ID for each US state",
                                city = "The name of the city where the race is held",
                                finishers = "The number of finishers at the marathon",
                                mean_time = "The average finish time in minutes.",
                                lat = "The lattitude of the city as listed at https://simplemaps.com/data/us-cities",
                                lng = "The longitude of the city as listed at https://simplemaps.com/data/us-cities",
                                elevation_m = "The elevation in meters above sea level as estimated from the elevatr R package.",
                                date = "The approximate date of the marathon.  The year is correct but the month and day changes every year and we have marked it the same.",
                                month = "Approximate month of the marathon", 
                                day = "Approximate day of the month of the marathon.",
                                year = "The year of the marathon"))

# Wrangle
race_location <- select(race_locations,-finishers, -max_mean, -years) %>%
  left_join(race_info) %>%
  mutate(day = ifelse(month == 2 & day == 29, 28, day),
         date = mdy(str_c(month, "/", day, "/", year))) %>%
  select(marathon, marathon_name = name, state_id, city = city_ascii, finishers, mean_time, lat, lng, elevation_m, date, month, day, year, -marathon_clean )
