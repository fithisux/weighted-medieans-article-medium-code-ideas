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



