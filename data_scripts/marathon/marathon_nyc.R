# Data is from master_marathon
dat <- read_csv("/Users/hathawayj/odrive/Dropbox/data/master_marathon.csv")


# Data details
dpr_document(marathon_nyc, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_nyc", title = "A random sample of 50% of males and females for each year of runners for all years of the New York City marathon where gender is recorded.",
             description = "This data set has just over 200k runners. The NYT had a good article - https://www.nytimes.com/2014/04/23/upshot/what-good-marathons-and-bad-investments-have-in-common.html?rref=upshot&_r=1. The NYC marathon website - https://www.nyrr.org/tcsnycmarathon",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details )

# Wrangle
marathon_nyc <- dat %>%
  filter(marathon == "New York City Marathon", !is.na(gender)) %>%
  group_by(year, gender) %>%
  sample_frac(size = .5) %>%
  ungroup()