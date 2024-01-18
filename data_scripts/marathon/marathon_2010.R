# Data is from master marathon
dat <- read_csv("/Users/hathawayj/odrive/Dropbox/data/master_marathon.csv")


# Data details
dpr_document(marathon_2010, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_2010", title = "The full set of runners for all races during 2010.",
             description = "This data set has 800k runners. The NYT had a good article - https://www.nytimes.com/2014/04/23/upshot/what-good-marathons-and-bad-investments-have-in-common.html?rref=upshot&_r=1.",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details )

# Wrangle (filter to 2010)
marathon_2010 <- dat %>%
  filter(year == 2010)