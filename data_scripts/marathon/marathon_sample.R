# Data is from master_marathon

# Data details
dpr_document(marathon_sample, extension = ".R.md", export_folder = usethis::proj_get(),
             object_name = "marathon_sample", title = "A resampled set of runners from all marathons with more 50 runners.",
             description = "Each marathon will have 100 runners (50 male, 50 female) per year. So any marathon with less than 50 runners in the group will have multiple resampled runners. This data set has over 500k runners. The original data had close to 10 million runners and a few more columns. The NYT had a good article - https://www.nytimes.com/2014/04/23/upshot/what-good-marathons-and-bad-investments-have-in-common.html?rref=upshot&_r=1",
             source = "http://faculty.chicagobooth.edu/george.wu/research/marathon/data.htm",
             var_details = runner_details)

# Wrangle
marathon_sample <- dat %>%
  filter(finishers > 50) %>%
  group_by(marathon, year, gender) %>%
  sample_n(50, replace = TRUE) %>%
  ungroup() %>%
  mutate(finishers = as.integer(finishers), year = as.integer(year))