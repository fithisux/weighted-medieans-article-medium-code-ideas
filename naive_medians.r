# We are given a series of 10 numbers with repetiions
library(tidyverse)
my_tibble <- tibble(a=sample(1:10, size=100, replace=TRUE))

# but for storage reduction, they are transferred to us as a grouped tibble
occ_tbl <- my_tibble %>% group_by(a) %>% summarize(occurences = n())

# the most naive way to find the media is to "explode it" and use
# a library function
naive_median <- occ_tbl %>% 
  mutate(list_occ = purrr::map(occurences, function(x)rep(1,x)))  %>% 
  unnest(cols=c(list_occ)) %>% 
  summarize(result = median(a))  %>%
  select(result)

# lets also write a test
original_median <- my_tibble %>% summarize(result=median(a))
assertthat::are_equal(naive_median, original_median)



data <- readr::read_csv("/Users/vassilisanagnostopoulos/work/notebooks/datasets/supermarket_sales - Sheet1.csv")
data %>% mutate(Date = )


fixup_date <- function(x) {
  days <- paste0("0", str_extract(x, "^\\d+"))
  days <- str_sub(days, -2, -1)
  rest <- str_extract(x, "/.+")
  paste0(days, rest)
}

readr::read_csv("/Users/vassilisanagnostopoulos/work/notebooks/datasets/supermarket_sales - Sheet1.csv",
                col_types = cols(
                    `Invoice ID` = col_character(),
                    Branch = col_character(),
                    City = col_character(),
                    `Customer type` = col_character(),
                    Gender = col_character(),
                    `Product line` = col_character(),
                    `Unit price` = col_double(),
                    Quantity = col_double(),
                    `Tax 5%` = col_double(),
                    Total = col_double(),
                    Date = col_date("%m/%d/%Y"),
                    Time = col_time(format = ""),
                    Payment = col_character(),
                    cogs = col_double(),
                    `gross margin percentage` = col_double(),
                    `gross income` = col_double(),
                    Rating = col_double()
                )
                
)