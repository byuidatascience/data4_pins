# Data is from master_marathon

# Info about the Berlin dataset that needs to be put into the qmd eventually
dpr_document(marathon_berlin, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_berlin", 
             title = "The 50% sample of male/female runners for all years of the Berlin marathon that recorded gender.",
             description = "This data set has ~200k observations.  Marathon website - https://www.bmw-berlin-marathon.com/en/",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details )

# Wrangling for Berlin marathon data
marathon_berlin <- dat %>%
  filter(marathon == "Berlin Marathon", !is.na(gender)) %>%
  group_by(year, gender) %>%
  sample_frac(size = .5) %>%
  ungroup()