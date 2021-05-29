
# load packages -----------------------------------------------------------

library(tidymodels)

# load objects ------------------------------------------------------------

load("intermediates/loan_model_st.rds")
loan_train <- ("data/processed/loan_train.rds")
loan_test <- load("data/processed/loan_test.rds")

loan_model_st

predictions <-  
  loan_model_st %>% 
  predict(new_data = loan_test) %>% 
  bind_cols(loan_test %>% select(id)) %>%
  select(id, .pred) %>%
  rename(Id = id, Predicted = .pred)

write_csv(predictions, file = "submission/ensemble_pred.csv")
