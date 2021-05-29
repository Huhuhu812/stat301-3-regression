
# load packages -----------------------------------------------------------

library(tidymodels)

# load objects ------------------------------------------------------------

load("intermediates/res_bt_titless.rds")
load("intermediates/workflow_bt_titleless.rds")
loan_train <- readRDS("data/processed/loan_train.rds")
loan_test <- readRDS("data/processed/loan_test.rds")

# evaluate ----------------------------------------------------------------

show_best(res_bt_titless, metric = "rmse")
autoplot(res_bt_titless)

lowest_rmse <- select_best(res_bt_titless, metric = "rmse")

# final fit & eval --------------------------------------------------------

final_wf_bt <- finalize_workflow(workflow_bt_titleless, lowest_rmse)

set.seed(11037)
final_wf_fit <- fit(final_wf_bt, data = loan_train)

predictions <- 
  final_wf_fit %>% 
  predict(new_data = loan_test) %>% 
  bind_cols(loan_test %>% select(id)) %>%
  select(id, .pred) %>%
  rename(Id = id, Predicted = .pred)

write_csv(predictions, file = "submission/bt_pred.csv")
