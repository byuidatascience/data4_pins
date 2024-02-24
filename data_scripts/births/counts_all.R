library(tidyverse)

# Put the code that brings in all these datasets when it's all working. 
counts_all <- bind_rows(
  mutate(counts_football, group = "football"),
  mutate(counts_baseball, group = "baseball"),
  mutate(counts_hockey, group = "hockey"),
  mutate(counts_basketball, group = "basketball"),
  mutate(counts_us, group = "us")
)

# Data details
dpr_document(counts_all, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "counts_all", 
             title = "The count of births of all players and US by month.",
             description = "Data combined from others sources in package.",
             source = "https://github.com/byuidatascience/data4births",
             var_details = counts_all_description)