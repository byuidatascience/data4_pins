# Data is from master_marathon  
dat <- read_csv("/Users/hathawayj/odrive/Dropbox/data/master_marathon.csv")


# Dataset details
dpr_document(marathon_big_sur, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_big_sur", 
             title = "The full set of runners for the Big Sur marathon.",
             description = "This data set has ~40k observations.  Marathon website - https://www.bigsurmarathon.org/",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details )

# Filter to only the Big Sur Marathon
marathon_big_sur <- dat %>%
  filter(marathon == "Big Sur Marathon")