library(tidyverse)

# Grabs data from Lahman database, which is available in R.
baseball_births <- Lahman::People %>%
  select(nameGiven, playerID, birthMonth, birthDay, birthCountry, birthDate, debut, finalGame) %>%
  rename_all("str_to_lower") %>%
  rename_all(.funs = funs(str_remove_all(.,"birth"))) %>%
  mutate(from = year(ymd(debut)), to = year(ymd(finalgame)), yrs = to - from) %>%
  select(player = namegiven, birthday = date, yrs, from, to, everything(), -playerid, -debut, -finalgame) %>%
  filter(!is.na(birthday))

# Data details
dpr_document(baseball_births, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "baseball_births", 
             title = "The birth dates of MLB players",
             description = "Data obtained from Lahman http://www.seanlahman.com/baseball-archive/statistics/",
             source = "https://github.com/cdalzell/Lahman",
             var_details = baseball_description)