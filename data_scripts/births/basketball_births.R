pacman::p_load(tidyverse, glue, rvest)

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
# currently gives an error - HTTP error 429. Means that too many requests were made too fast. 


basketball_births <- basketball_list %>%
  bind_rows() %>%
  as_tibble() %>%
  mutate(yrs = as.integer(yrs))
# write_csv(basketball_births, "basketball.csv")

# Data details
dpr_document(basketball_births, extension = ".md.R", export_folder = usethis::proj_get(),
             object_name = "basketball_births", 
             title = "The birth dates of NBA/ABA players",
             description = "Data obtained from https://www.basketball-reference.com",
             source = "https://www.basketball-reference.com/friv/birthdays.fcgi?month=1&day=1",
             var_details = basketball_description)


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, basketball_births, type = "parquet")

pin_name <- "basketball_births"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))