#Getting and Cleaning Data Course Projectless 

#The purpose of this project is to demonstrate your ability to collect, work with, and 
#clean a data set. The goal is to prepare tidy data that can be used for later analysis. 
#You will be graded by your peers on a series of yes/no questions related to the project. 
#You will be required to submit: 
#1) a tidy data set as described below, 
#2) a link to a Github repository with your script for performing the analysis, and 
#3) a code book that describes the variables, the data, and any transformations or work 
#   that you performed to clean up the data called CodeBook.md. You should also include a 
#   README.md in the repo with your scripts. This repo explains how all of the scripts 
#   work and how they are connected.

#One of the most exciting areas in all of data science right now is wearable computing - see 
#for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop
#the most advanced algorithms to attract new users. The data linked to from the course 
#website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
#A full description is available at the site where the data was obtained:
  
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#Here are the data for the project:
  
#  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#You should create one R script called run_analysis.R that does the following steps:

#1) Merges the training and the test sets to create one data set.
#2) Extracts only the measurements on the mean and standard deviation for each measurement.
#3) Uses descriptive activity names to name the activities in the data set
#4) Appropriately labels the data set with descriptive variable names.
#5) From the data set in step 4, creates a second, independent tidy data set with the average
#   of each variable for each activity and each subject.



#SOLUTION

library(data.table)
library(dplyr)

features_Names <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)


# Read training data:
subject_Train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activity_Train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
features_Train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)

# Read test data:
subject_Test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activity_Test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
features_Test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)

#----------------------------------------------------------------------------------------------
## STEP 1:
## Merge the training and the test sets to create one data set.
#----------------------------------------------------------------------------------------------

subject <- rbind(subject_Train, subject_Test)
activity <- rbind(activity_Train, activity_Test)
features <- rbind(features_Train, features_Test)

colnames(features) <- t(features_Names[2])
colnames(activity) <- "Activity"
colnames(subject) <- "Subject"
merged_Data <- cbind(features,activity,subject)

#----------------------------------------------------------------------------------------------
## STEP 2:
## Extracts only the measurements on the mean and standard deviation for each measurement
#----------------------------------------------------------------------------------------------

columns_Mean_STD <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
desired_Columns <- c(columns_Mean_STD, 562, 563)
dim(merged_Data)

extracted_Data <- merged_Data[,desired_Columns]
dim(extracted_Data)

#----------------------------------------------------------------------------------------------
## STEP 3:
## Uses descriptive activity names to name the activities in the data set
#----------------------------------------------------------------------------------------------

extracted_Data$Activity <- as.character(extracted_Data$Activity)
for (i in 1:6){
  extracted_Data$Activity[extracted_Data$Activity == i] <- as.character(activity_labels[i,2])
}

extracted_Data$Activity <- as.factor(extracted_Data$Activity)

#----------------------------------------------------------------------------------------------
## STEP 4:
## Appropriately labels the data set with descriptive variable names
#----------------------------------------------------------------------------------------------

names(extracted_Data)

names(extracted_Data)<-gsub("Acc", "Accelerometer", names(extracted_Data))
names(extracted_Data)<-gsub("Gyro", "Gyroscope", names(extracted_Data))
names(extracted_Data)<-gsub("BodyBody", "Body", names(extracted_Data))
names(extracted_Data)<-gsub("Mag", "Magnitude", names(extracted_Data))
names(extracted_Data)<-gsub("^t", "Time", names(extracted_Data))
names(extracted_Data)<-gsub("^f", "Frequency", names(extracted_Data))
names(extracted_Data)<-gsub("tBody", "TimeBody", names(extracted_Data))
names(extracted_Data)<-gsub("-mean()", "Mean", names(extracted_Data), ignore.case = TRUE)
names(extracted_Data)<-gsub("-std()", "STD", names(extracted_Data), ignore.case = TRUE)
names(extracted_Data)<-gsub("-freq()", "Frequency", names(extracted_Data), ignore.case = TRUE)
names(extracted_Data)<-gsub("angle", "Angle", names(extracted_Data))
names(extracted_Data)<-gsub("gravity", "Gravity", names(extracted_Data))

names(extracted_Data)

#----------------------------------------------------------------------------------------------
## STEP 5:
## From the data set in step 4, creates a second, independent tidy data set with the average 
## of each variable for each activity and each subject
#----------------------------------------------------------------------------------------------

extracted_Data$Subject <- as.factor(extracted_Data$Subject)
extracted_Data <- data.table(extracted_Data)

tidyData <- aggregate(. ~Subject + Activity, extracted_Data, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)
