# STAT 301-3 Regression Competition

## Files

All submissions made to Kaggle are located in the `submission` folder. Results for model tuning are located the `intermediates` folder and both raw and processed data are located in the `data` folder.

Two scripts, `clean.R` and `clean_test.R`, handle data wrangling for the training and testing set, while `explore_and_recipe.R` contains code for all recipes.

Training scripts are named like `job_<modelType>.R`, while model selection, prediction and csv writing are handled in `evaluate_<modelType>.R`

## Reproducing

The .csv files can be reproduced directly by running the respective `evaluate_<model>.R` file. To run the full pipeline, scripts should be run in the following order.

-   `clean.R` and `clean_test.R`

-   `explore_and_recipe.R`

-   `job_bt.R`, `job_rf.R`

-   `evaluate_bt.R` and `evaluate_rf.R`

-   `job_ensemble.R` and `evaluate_ensemble.R`
