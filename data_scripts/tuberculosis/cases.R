library(tidyverse)


tb_cases <- read_csv("https://extranet.who.int/tme/generateCSV.asp?ds=notifications")

# Wrangling
cases_clean <- tb_cases %>%
  select(-(new_sp:c_newinc), 
         -contains('_fu'), -contains('_mu'), -contains('_sexunk'), 
         -contains('gesex'), -contains('15plus'), -contains('014'),
         -(rdx_data_available:hiv_reg_new2)) %>%
  pivot_longer(
    cols = new_sp_m04:newrel_f65, 
    names_to = "key", 
    values_to = "cases", 
    values_drop_na = TRUE
  ) %>% 
  mutate(
    key = stringr::str_replace(key, "newrel", "new_rel")
  ) %>%
  separate(key, c("new", "var", "sexage")) %>% 
  select(-new, -iso2, -iso3, -iso_numeric) %>% 
  separate(sexage, c("sex", "age"), sep = 1) %>%
  mutate(
    age_middle = case_when(
      age == '04' ~ 2,
      age == '514' ~ 9,
      age == '1524' ~ 19,
      age == '2534' ~ 29,
      age == '3544' ~ 39,
      age == '4554' ~ 49,
      age == '5564' ~ 59,
      age == '65' ~ 75),
    var = case_when(
      var == 'sp' ~ 'smear positive',
      var == 'sn' ~ 'smear negative',
      var == 'rel' ~ 'relapse',
      var == 'ep' ~ 'extrapulmonary'
    )) %>%
  select(country, g_whoregion, year, sex, age, age_middle, var, cases)



