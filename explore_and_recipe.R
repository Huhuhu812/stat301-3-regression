
# load packages -----------------------------------------------------------

library(tidyverse)
library(tidymodels)
library(embed)
library(ggplot2)
library(corrplot)


# correlation -------------------------------------------------------------

loan_train <- readRDS("data/processed/loan_train.rds")

skimr::skim_without_charts(loan_train)

loan_train %>% select(where(is.numeric)) %>%
  cor() %>% corrplot()

base <- ggplot(loan_train)

base + geom_histogram(aes(x = loan_amnt))

loan_train %>%
  keep(is.numeric) %>% 
  gather() %>% 
  ggplot(aes(value)) +
  facet_wrap(~ key, scales = "free") +
  geom_histogram()

# recipes!! ---------------------------------------------------------------

rec_encoded <- recipe(money_made_inv ~ .,data = loan_train) %>%
  step_rm(id, avg_cur_bal, emp_title, sub_grade, addr_state, acc_now_delinq,delinq_2yrs, purpose) %>%
  step_impute_knn(emp_length, impute_with = imp_vars(all_numeric_predictors())) %>%
  step_YeoJohnson(all_numeric_predictors()) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_dummy(all_nominal_predictors(), one_hot = T) %>%
  step_zv(all_predictors())

rec_cats <- recipe(money_made_inv ~ .,data = loan_train) %>%
  step_rm(id, avg_cur_bal, emp_title, sub_grade, addr_state, acc_now_delinq,delinq_2yrs, purpose) %>%
  step_impute_knn(emp_length, impute_with = imp_vars(all_numeric_predictors())) %>%
  step_YeoJohnson(all_numeric_predictors()) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_zv(all_predictors())

rec_cats %>% prep(retain = T) %>% bake(new_data = NULL)

# make folds --------------------------------------------------------------

set.seed(11037)
loan_folds <- vfold_cv(loan_train, v = 10, repeats = 3, strata = money_made_inv)

# save some stuff ---------------------------------------------------------

save(rec_encoded, file = "saved/rec_encoded.rds")
save(rec_cats, file = "saved/rec_cats.rds")
save(loan_folds, file = "saved/loan_folds.rds")

