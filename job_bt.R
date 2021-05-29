

# load packages -----------------------------------------------------------

library(tidyverse)
library(tidymodels)
library(stacks)

# load objects ------------------------------------------------------------

load("saved/loan_folds.rds")
load("saved/rec_encoded.rds")

# model -------------------------------------------------------------------

bt_model <-
  boost_tree(
    "regression",
    mtry = tune(),
    min_n = tune()
  ) %>%
  set_engine("xgboost")
bt_model

bt_params <-
  parameters(bt_model) %>% update(mtry = mtry(c(2, 52)))

bt_grid <-
  grid_regular(bt_params, levels = 5)

# prep(rec_encoded, retain = T) %>% bake(new_data = NULL)

workflow_bt_titleless <- workflow() %>%
  add_model(bt_model) %>%
  add_recipe(rec_encoded)

# workflow_bt <- workflow() %>%
#   add_model(bt_model) %>%
#   add_recipe(rec_cats)
ctrl_grid <- control_stack_grid()

# tune grid -----------------------------------------------------------

res_bt_titless <-
  tune_grid(
    workflow_bt_titleless,
    resamples = loan_folds,
    grid  = bt_grid,
    control = ctrl_grid
  )


# write write write -------------------------------------------------------

save(res_bt_titless, file = "intermediates/res_bt_titless.rds")
save(workflow_bt_titleless, file = "intermediates/workflow_bt_titleless.rds")
