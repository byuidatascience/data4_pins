pacman::p_load(tidyverse, pins, connectapi, googledrive, readxl, stringi, patchwork, rio, ggrepel)

scriptures <- import("http://scriptures.nephi.org/downloads/lds-scriptures.csv.zip")


bmnames <- rio::import("https://byuistats.github.io/M335/data/BoM_SaviorNames.rds")
#' need to loop through largest to smallest savior names
bmnames <- bmnames %>% arrange(desc(nchar)) %>%
  mutate(order = 1:n())


#' Create data for each book
bm <- scriptures %>% filter(volume_short_title == "BoM")


#### To get top verses in BOM with savior names
bm <- scriptures %>% filter(volume_short_title == "BoM") %>%
  mutate(scripture_sub = scripture_text) # I am going to alter text in this column.  I want to keep the original text in a seperate column

for (i in seq_along(bmnames$name)){
  
  sname <- str_c("\\b",bmnames$name[i], "\\b")
  replace_name <- paste0("xfound_",i) # using an identifier in the text as the replacement
  
  # This creates a vector that has the count of the ith name in each verse.
  bm_locs <- bm$scripture_sub %>% 
    str_count(sname) %>%
    unlist()
  
  # now create a new column in the bm tibble that shows the count for the name_i
  bm[,paste0("name_", i)] <- bm_locs
  
  # This line replaces the substitute text column with the name id name_i
  bm$scripture_sub <- bm$scripture_sub %>% str_replace_all(sname, replace_name)
  #  print(i)
} 

# Now create two columns. 
#   count_name = number of names in that verse. 
#   cum_name is the cummulative number of names by the end of that verse.
bm <- bm %>%
  mutate(count_name = rowSums(.[colnames(bm) %in% paste0("name_", 1:112)]),
         cum_name = cumsum(count_name))


# Publish the data to the server with Bro. Hathaway as the owner.
board <- board_connect()
pin_write(board, bom_savior_names, type = "parquet", access_type = "all")

pin_name <- "bom_savior_names"
meta <- pin_meta(board, paste0("hathawayj/", pin_name))
client <- connect()
my_app <- content_item(client, meta$local$content_id)
set_vanity_url(my_app, paste0("data/", pin_name))