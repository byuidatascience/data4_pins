library(tidyverse)

# US population data
dat_94_03 <- read_csv("https://github.com/fivethirtyeight/data/raw/master/births/US_births_1994-2003_CDC_NCHS.csv")
dat_00_14 <- read_csv("https://github.com/fivethirtyeight/data/raw/master/births/US_births_2000-2014_SSA.csv")


counts_us <- dat_94_03 %>%
  filter(year < 2000) %>%
  bind_rows(dat_00_14) %>% 
  group_by(month, date_of_month) %>%
  summarise(births = sum(births)) %>%
  ungroup() %>%
  mutate(day_of_year = 1:n()) %>%
  left_join(tibble(month = 1:12, month_name = month.name)) %>%
  select(month_number = month, month_name, day_of_month = date_of_month, day_of_year, births)


# Data details
dpr_document(counts_us, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "counts_us", title = "The count of births in the United States from 1994-2014",
             description = "Data obtained from the CDC and Census parsed by FiveThirtyEight ",
             source = "https://github.com/fivethirtyeight/data/tree/master/births",
             var_details = counts_description)