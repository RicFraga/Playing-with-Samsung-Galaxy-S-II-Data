# This file does the following things:

# > Merges the training and the test sets to create one data set.
# > Extracts only the measurements on the mean and standard deviation for each
# measurement. 
# > Uses descriptive activity names to name the activities in the data set
# > Appropriately labels the data set with descriptive variable names.
# > From the data set in the past step, creates a second, independent tidy data
# set with the average of each variable for each activity and each subject.

library(tidyr)

# This function merges data sets to create a single data set
merge_data_sets <- function(training_path, test_path) {
     
     # Getting the training and test data for X
     training_x <- read.table(paste0(training_path, 'X_train.txt'))
     test_x <- read.table(paste0(test_path, 'X_test.txt'))
     
     # Getting the training and test data for y
     training_y <- read.table(paste0(training_path, 'y_train.txt'))
     test_y <- read.table(paste0(test_path, 'y_test.txt'))
     
     # Generating the complete train data
     training_data <- cbind(training_x, training_y)
     
     # Generating the complete test data
     test_data <- cbind(test_x, test_y)
     
     # Generating the complete data
     complete_data <- rbind(training_data, test_data)
     
     return(as.data.frame(complete_data))
}

# This function returns the mean for each measurement
measurement_means <- function(data_set) {
     
     # Getting the mean for each measurement
     means <- sapply(data_set, mean, na.rm = TRUE)
     
     return(means)
}

# This function returns the standard deviation for each measurement
measurement_sd <- function(data_set) {
     
     # Getting the sd for each measurement
     sds <- sapply(data_set, sd, na.rm = TRUE)
     
     return(sds)
}

# This function names the activities in the data set:
# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING
name_activities <- function(data_set) {
     
     columns <- dim(data_set)[2]
     rows <- dim(data_set)[1]
     
     # The activities are in the last column of the data set
     activities_numbers <- data_set[, columns]
     
     # Vector to save the activities names
     activities_names <- c()
     
     # Going through each row to name the activities
     for(i in 1:rows) {
          
          if(activities_numbers[i] == 1) 
               activities_names <- c(activities_names, 'WALKING')
          
          else if(activities_numbers[i] == 2)
               activities_names <- c(activities_names, 'WALKING_UPSTAIRS')
          
          else if(activities_numbers[i] == 3)
               activities_names <- c(activities_names, 'WALKING_DOWNSTAIRS')
          
          else if(activities_numbers[i] == 4)
               activities_names <- c(activities_names, 'SITTING')
          
          else if(activities_numbers[i] == 5)
               activities_names <- c(activities_names, 'STANDING')
          
          else
               activities_names <- c(activities_names, 'LAYING')
     }
     
     return(cbind(data_set[, 1:columns - 1], activities_names))
}

# This function names the data set's features
name_variables <- function(data_set, fnames_path) {
     
     # Reading the feature names
     features_names <- read.table('Data/UCI HAR Dataset/features.txt')[, 2]
     
     # Copy of the data set
     ds <- data_set
     
     # Renaming the columns
     colnames(ds) <- features_names

     return(ds)
}

# This function generates a data set with the following info:
# Average of each variable for each activity for each subject

#          -----------------------------------------------------------
#          |    subject     |       activity    |      variable1     | ...
#---------------------------------------------------------------------
#          |        S1      |         A1        |        x11         | ...
#---------------------------------------------------------------------
#          |        S4      |         A2        |        x21         | ...
#---------------------------------------------------------------------

#   ...            ...                ...

average_dataset <- function(data_set) {
     # First we need to get the info from the test subjects
     # Since we just joined the train and test data sets (in that order)
     # we don't have to worry about the order
     
     # Reading the subjects info
     train_subjects <- read.table('Data/UCI HAR Dataset/train/subject_train.txt')
     test_subjects <- read.table('Data/UCI HAR Dataset/test/subject_test.txt')
     
     # Notice that dim(train_subjects)[1] + dim(test_subjects)[1] = 10299
     total_subjects <- rbind(train_subjects, test_subjects)
     data_set_wsubjects <- cbind(data_set, total_subjects)
     
     # Getting all the identifiers for the subjects
     subjects <- unique(data_set_wsubjects[, dim(data_set_wsubjects)[2]])
     activities <- unique(data_set_wsubjects[, dim(data_set_wsubjects)[2] - 1])
     
     # Matrix to save the values to then convert it into a data frame
     averages_matrix <- matrix(ncol = 563)
     
     for(subject in subjects) {
          
          # We get the index in which the subject appears
          index <- which(data_set_wsubjects[, 563] == subject)
          subject_info <- data_set_wsubjects[index, 1:562]
          
          for(activity in activities) {
               
               # We get the index in which the activity appears
               index <- which(subject_info[, 562] == activity)
               activity_info <- data_set_wsubjects[index, 1:561]
               
               # We compute the mean of the activity and subject
               mean <- colMeans(activity_info, na.rm = TRUE)
               
               # Constructing the row to append to the data set
               row <- c(subject)
               row <- c(row, activity)
               row <- c(row, mean)
               
               averages_matrix <- rbind(averages_matrix, row)
          }    
     }
     
     # Renaming the dimensions of the matrix
     colnames(averages_matrix) <- c('subject', 'activity', colnames(data_set[1:561]))
     rownames(averages_matrix) <- c()
     
     # The first row is filled with garbage, so we don't return it
     return(as.data.frame(averages_matrix[-1, ]))
}