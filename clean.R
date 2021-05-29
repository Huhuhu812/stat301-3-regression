
# load packages -----------------------------------------------------------

library(tidyverse)
# library(tidymodels)
library(conflicted)
library(ggplot2)
library(lubridate)

# tidymodels_prefer()

# load data ---------------------------------------------------------------

conflict_prefer("col_factor", "readr")
loan_train <- read_csv(
  "data/unprocessed/train.csv",
  col_types = cols(
    id = col_character(),
    addr_state = col_factor(),
    application_type = col_factor(),
    earliest_cr_line = col_date(format = "%b-%Y"),
    emp_length = col_factor(
      levels = c(
        "< 1 year",
        "1 year",
        "2 years",
        "3 years",
        "4 years",
        "5 years",
        "6 years",
        "7 years",
        "8 years",
        "9 years",
        "10+ years"
      ),
      ordered = T,
      include_na = T
    ),
    emp_title = col_character(),
    grade = col_factor(),
    home_ownership = col_factor(),
    initial_list_status = col_factor(),
    last_credit_pull_d = col_date(format = "%b-%Y"),
    purpose = col_factor(),
    sub_grade = col_factor(),
    term = col_factor(),
    verification_status = col_factor()
  )
) %>% mutate(
  secs_since_earliest_cr_line =
    interval(start = earliest_cr_line, end = now()) %>%
    as.duration() %>%
    time_length(unit = "day")
) %>%
  mutate(
    secs_since_lst_pull =
      interval(start = last_credit_pull_d, end = now()) %>%
      as.duration() %>%
      time_length(unit = "day")
  ) %>%
  select(-c("last_credit_pull_d", "earliest_cr_line"))

grade_lvl <- levels(loan_train$grade) %>% sort(decreasing = T)

loan_train <-
  loan_train %>% mutate(grade = fct_relevel(grade, grade_lvl))
skimr::skim_without_charts(loan_train)
loan_train$grade
n
saveRDS(loan_train, file = "data/processed/loan_train.rds")
