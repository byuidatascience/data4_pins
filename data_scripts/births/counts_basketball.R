pacman::p_load(tidyverse, glue, rvest)

# Make basketball_births first

# Make month_days tibble for wrangling later
month_days <- bind_rows(
  tibble(month = 1, days = 1:31),
  tibble(month = 2, days = 1:29),
  tibble(month = 3, days = 1:31),
  tibble(month = 4, days = 1:30),
  tibble(month = 5, days = 1:31),
  tibble(month = 6, days = 1:30),
  tibble(month = 7, days = 1:31),
  tibble(month = 8, days = 1:31),
  tibble(month = 9, days = 1:30),
  tibble(month = 10, days = 1:31),
  tibble(month = 11, days = 1:30),
  tibble(month = 12, days = 1:31),
)


basketball_date_rip <- function(m,d) {
  
  urlpath <- glue("https://www.basketball-reference.com/friv/birthdays.fcgi?month={month}&day={day}", 
                  month = m, day = d)
  
  out <-  read_html(urlpath) %>%
    html_nodes("table") %>% 
    html_table() %>%
    .[[1]]
  
  col_names <- str_remove_all(out[1, 2:4], "\\(s\\)") %>% str_to_lower()
  
  out <- out %>% 
    .[-1, 2:4]
  
  colnames(out) <- col_names   
  
  print(str_c(m,"/", d))
  
  out %>%
    mutate(birthday = ymd(str_c(born,"-", m,"-", d))) %>%
    select(player, birthday, everything(),-born)
  
  
}


basketball_list <- map2(month_days$month, month_days$days, ~basketball_date_rip(.x, .y))

basketball_births <- basketball_list %>%
  bind_rows() %>%
  as_tibble() %>%
  mutate(yrs = as.integer(yrs))

# Convert basketball_births into counts_basketball
counts_basketball <- basketball_births %>%
  mutate(month = month(birthday), day = mday(birthday)) %>%
  count(month, day, name = "births") %>%
  mutate(day_of_year = 1:n()) %>%
  left_join(tibble(month = 1:12, month_name = month.name)) %>%
  select(month_number = month, month_name, day_of_month = day, day_of_year, births)

# Data details
dpr_document(counts_basketball, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "counts_basketball", 
             title = "The count of births of NBA/ABA players",
             description = "Data obtained from https://www.basketball-reference.com",
             source = "https://www.basketball-reference.com/friv/birthdays.fcgi?month=1&day=1",
             var_details = counts_description)