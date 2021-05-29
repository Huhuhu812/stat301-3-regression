

# load packages -----------------------------------------------------------

library(tidymodels)
library(tidyverse)
library(stacks)
tidymodels_prefer()

# load objects ------------------------------------------------------------

load("saved/loan_folds.rds")
load("saved/rec_cats.rds")

# prep(rec_cats, retain = T) %>% bake(new_data = NULL)

# model -------------------------------------------------------------------

rf_model <- rand_forest(mtry = tune(), trees = tune()) %>%
  set_engine("ranger", importance = "impurity") %>% 
  set_mode("regression")

rf_params <- rf_model %>%
  parameters() %>%
  update(mtry = mtry(c(2, 27)))

rf_grid <- grid_regular(rf_params, levels = c(mtry = 10, trees = 5))

workflow_rf <- workflow() %>%
  add_model(rf_model) %>%
  add_recipe(rec_cats)

ctrl_grid <- control_stack_grid()

# tune/fit ----------------------------------------------------------------

res_rf_titless <-
  tune_grid(
    workflow_rf,
    resamples = loan_folds,
    grid = rf_grid,
    control = ctrl_grid
  )

# save(res_bt, file = "intermediates/res_bt.rds")
write_rds(res_rf_titless, file = "intermediates/res_rf_titless.rds")
write_rds(workflow_rf, file = "intermediates/workflow_rf.rds")
