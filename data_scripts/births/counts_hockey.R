pacman::p_load(tidyverse, glue, rvest, pins)



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

hockey_date_rip <- function(m,d) {
  
  urlpath <- glue("https://www.hockey-reference.com/friv/birthdays.cgi?month={month}&day={day}", 
                  month = m, day = d)
  
  out <-  read_html(urlpath) %>%
    html_nodes("table") %>% 
    html_table() %>%
    .[[1]]
  
  col_names <- str_remove_all(out[1, 2:6], "\\(s\\)") %>% str_to_lower()
  
  out <- out %>% 
    .[-1, 2:6]
  
  colnames(out) <- col_names   
  
  print(str_c(m,"/", d))
  
  out %>%
    mutate(birthday = ymd(str_c(born,"-", m,"-", d))) %>%
    select(player, birthday, everything(),-born)
  
  
}

hockey_list <- map2(month_days$month, month_days$days, ~hockey_date_rip(.x, .y))

hockey_births <- hockey_list %>%
  bind_rows() %>%
  as_tibble() %>%
  mutate(from = as.integer(from), to = as.integer(to), yrs = to - from) %>%
  select(player, birthday, yrs, from, to, team)

# Wrangle hockey_births into counts_hockey
counts_hockey <- hockey_births %>%
  mutate(month = month(birthday), day = mday(birthday)) %>%
  count(month, day, name = "births") %>%
  mutate(day_of_year = 1:n()) %>%
  left_join(tibble(month = 1:12, month_name = month.name)) %>%
  select(month_number = month, month_name, day_of_month = day, day_of_year, births)

# Data details
dpr_document(counts_hockey, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "counts_hockey", 
             title = "The count of births of NHL players",
             description = "Data obtained from https://www.hockey-reference.com",
             source = "https://www.hockey-reference.com/friv/birthdays.cgi?month=1&day=1",
             var_details = counts_description)



# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, counts_hockey, type = "parquet")

pin_name <- "counts_hockey"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))