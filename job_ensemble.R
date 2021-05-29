
# load packages -----------------------------------------------------------

library(tidyverse)
library(tidymodels)
library(stacks)

# load objects ------------------------------------------------------------

load("intermediates/res_bt_titless.rds")
res_rf_titless <- read_rds("intermediates/res_rf_titless.rds")

# make stack --------------------------------------------------------------

loan_data_st <- 
  stacks() %>%
  add_candidates(res_bt_titless) %>%
  add_candidates(res_rf_titless)

# blend stack -------------------------------------------------------------

loan_model_st <-
  loan_data_st %>%
  blend_predictions()

loan_model_st <-
  loan_model_st %>%
  fit_members()

save(loan_model_st, file = "intermediates/loan_model_st.rds")