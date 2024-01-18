# Data is from master_marathon

# Data details
dpr_document(marathon_location, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_location", 
             title = "All of the runners for marathons with lat and long locations",
             description = "This data set has ~150k observations.",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details)

# Wrangling 
marathon_location <- filter(dat, marathon %in% race_location$marathon) %>%
  group_by(marathon) %>%
  filter(year == max(year)) %>%
  ungroup() %>%
  select(age, gender, chiptime, year, marathon, country, finishers)