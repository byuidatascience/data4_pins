pacman::p_load(tidyverse, readxl)

sheet_names <- excel_sheets("../data_led_private/data/DataUsedForAnalysis.xlsx") # Need to track down this data.

dat_list <- sheet_names[c(3,7)] %>% map(~read_xlsx("../data_led_private/data/DataUsedForAnalysis.xlsx", sheet = .x))

led_testing <- dat_list %>%
  map(~pivot_longer(.x, -Hours, names_to = "id", 
                    values_to = "percent_intensity")) %>%
  bind_rows() %>%
  mutate(company = ifelse(str_detect(id, "AAA"), "A", "B"),
         id = parse_number(id),
         normalized_intensity = percent_intensity,
         percent_intensity = 100*normalized_intensity) %>%
  select(id, hours = Hours, normalized_intensity, percent_intensity, company)