# Data is from some htm file online

# Data origin
race_info <- read_html("https://faculty.chicagobooth.edu/george.wu/research/marathon/marathon_names.htm") %>%
  html_nodes("table") %>% 
  html_table() %>%
  .[[1]] 

# Data details
dpr_document(race_info, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "race_info", title = "Table of Information about Marathons",
             description = "An interesting data set to see the effects of goals on what should be a unimodal distrubtion of finish times. The NYT had a good article - https://www.nytimes.com/2014/04/23/upshot/what-good-marathons-and-bad-investments-have-in-common.html?rref=upshot&_r=1",
             source = "https://faculty.chicagobooth.edu/george.wu/research/marathon/marathon_names.htm",
             var_details = list(year = "The year of the marathon", 
                                marathon = "The name of the marathon",
                                country = "The country where the marathon was held",
                                finishers = "The number of finishers at the marathon",
                                mean_time = "The average finish time in minutes."))



# Wrangle
colnames(race_info) <- race_info[1,]

race_info <- race_info[-1,] %>% 
  as_tibble() %>%
  rename_all("str_to_lower") %>%
  mutate(year = as.integer(year), finishers = as.integer(finishers), 
         `mean time` = as.numeric(`mean time`)) %>%
  rename(mean_time = `mean time`)

race_location <- select(race_locations,-finishers, -max_mean, -years) %>%
  left_join(race_info) %>%
  mutate(day = ifelse(month == 2 & day == 29, 28, day),
         date = mdy(str_c(month, "/", day, "/", year))) %>%
  select(marathon, marathon_name = name, state_id, city = city_ascii, finishers, mean_time, lat, lng, elevation_m, date, month, day, year, -marathon_clean )

