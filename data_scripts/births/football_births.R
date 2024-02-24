library(tidyverse)

# Load in football births.
years <- 1900:1999

player_data_rip <- function(x) {
  print(x)
  read_html(str_c("https://www.pro-football-reference.com/years/", x, "/births.htm")) %>%
    html_nodes("table") %>% 
    html_table() %>%
    .[[1]] %>%
    .[,1:6] %>%
    as_tibble() %>%
    rename_all(str_to_lower)
}

dat_20th <- map(years, ~player_data_rip(.x))
# HTTP error 429, too many requests


football_births <- dat_20th %>%
  bind_rows() %>%
  mutate(birthdate = mdy(birthdate)) %>%
  select(player, birthday = birthdate, yrs, from, to, pos)

# Data details
dpr_document(football_births, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "football_births", 
             title = "The birth dates of NFL players",
             description = "Data obtained from https://www.pro-football-reference.com",
             source = "https://www.pro-football-reference.com/years/1900/births.htm",
             var_details = football_description)