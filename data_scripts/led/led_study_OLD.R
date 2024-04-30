pacman::p_load(tidyverse)


load("../data_led_private/data/LumenData.Rdata") # Need to track down this data.Possibly lprize.
# dat object from the .Rdata file


led_study <- dat %>%
  select(ID, Hours, Intensity, NI) %>%
  rename_all("str_to_lower") %>%
  rename(percent_intensity = ni) %>%
  mutate(hours = floor(hours)) %>%
  group_by(id) %>%
  mutate(intensity = intensity + rnorm(n(), mean = 0, sd = .25),
         normalized_intensity = intensity / intensity[1],
         percent_intensity = normalized_intensity*100,
         hours = ifelse(hours < 10, 0, hours)) %>%
  ungroup() %>%
  filter(hours > 25 | hours < 10) %>%
  as_tibble() %>%
  mutate(hours = ifelse(hours == 191, 192, hours)) %>%
  select(id, hours, intensity, normalized_intensity, percent_intensity)

# Data details
# dpr_document(led_study, extension = ".md.R", export_folder = usethis::proj_get(),
#              object_name = "led_study", title = "LED example bulbs of lumen output",
#              description = "An example data set of LED bulbs based on actual data.",
#              source = "data_led_private",
#              var_details = led_study_details)