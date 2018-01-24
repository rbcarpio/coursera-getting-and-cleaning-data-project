This repository contains the R code and other files required for the Data Science's track course "Getting and Cleaning data", available in coursera.

An R code was implemented to create a tidy data using the Human Activity Recognition Using Smartphones Data Set, available from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The R script, `run_analysis.R`, does the following:
1. Download the dataset if it does not already exist in the working directory
2. Load the activity and feature information
3. Loads both the training and test datasets, with columns that has a mean or standard deviation
4. Loads the activity and subject data for each dataset, and merges those columns with the dataset
5. Merges the two datasets
6. Converts the `activity` and `subject` columns into factors
7. Creates a tidy dataset that consists of the average (mean) value of each variable for each pair of subject and activity.

 The output created  the file `tidy.txt`.
