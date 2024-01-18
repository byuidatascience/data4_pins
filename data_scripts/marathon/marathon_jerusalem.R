# Data is from master_marathon  

# Dataset details
dpr_document(marathon_jerusalem, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_jerusalem", 
             title = "The full set of runners for the Jerusalem marathon.",
             description = "This data set has ~2.5k observations.  Marathon website - https://jerusalem-marathon.com/en/home-page/",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details )

# Filter for the Jerusalem Marathon only
marathon_jerusalem <- dat %>%
  filter(marathon == "Jerusalem Marathon")