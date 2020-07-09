# This file does the following things:

# > Merges the training and the test sets to create one data set.
# > Extracts only the measurements on the mean and standard deviation for each
# measurement. 
# > Uses descriptive activity names to name the activities in the data set
# > Appropriately labels the data set with descriptive variable names.
# > From the data set in the past step, creates a second, independent tidy data
# set with the average of each variable for each activity and each subject.

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


