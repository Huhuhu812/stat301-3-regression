
# load packages -----------------------------------------------------------

library(tidymodels)
library(tidyverse)

# load objects ------------------------------------------------------------

res_rf <- read_rds("intermediates/res_rf_titless.rds")
workflow_rf <- read_rds("intermediates/workflow_rf.rds")
loan_train <- ("data/processed/loan_train.rds")
loan_test <- load("data/processed/loan_test.rds")

# evaluate ----------------------------------------------------------------

show_best(res_rf, metric = "rmse")
autoplot(res_rf)


lowest_rmse <- select_best(res_rf, metric = "rmse")

# final fit & eval --------------------------------------------------------

final_wf_rf <- finalize_workflow(workflow_rf, lowest_rmse)

set.seed(11037)
final_wf_fit <- fit(final_wf_rf, data = loan_train)

predictions <-  
  final_wf_fit %>% 
  predict(new_data = loan_test) %>% 
  bind_cols(loan_test %>% select(id)) %>%
  select(id, .pred) %>%
  rename(Id = id, Predicted = .pred)

write_csv(predictions, file = "submission/rf_pred.csv")
