# both need to be installed
# remotes::install_github("bokeh/rbokeh")
# remotes::install_github("ki-tools/growthstandards")

pacman::p_load(tidyverse, fs, sf, arrow, googledrive, downloader, fs, glue, rvest, pins, growthstandards)


height_coef <- growthstandards::who_coefs$htcm_agedays$Female$data %>%
  as_tibble() %>%
  filter(x < 900) %>%
  select(agedays = x, mean = m, cv = s, l = l) %>%
  mutate(sex = "Female") %>%
  bind_rows(
    growthstandards::who_coefs$htcm_agedays$Male$data %>%
      as_tibble() %>%
      filter(x < 900) %>%
      select(agedays = x, mean = m, cv = s, l = l) %>%
      mutate(sex = "Male")
  ) %>%
  mutate(sd = mean * cv) %>%
  select(agedays, sex, mean, sd, cv, l)


board <- board_connect()
pin_write(board, height_coef, type = "parquet", access_type = "all")

pin_name <- "height_coef"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))