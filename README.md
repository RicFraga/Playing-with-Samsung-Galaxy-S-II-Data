# Playing-with-Samsung-Galaxy-S-II-Data
R Project to play around with data from the Samsung Galaxy S II

The original data set was obtained from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
There are 5 tasks that this project does:
> Merges the training and the test sets to create one data set.
> Extracts only the measurements on the mean and standard deviation for each measurement.
> Uses descriptive activity names to name the activities in the data set
> Appropriately labels the data set with descriptive variable names.
> From the data set in the past step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Merging
For this task I created a function called merge_data_sets which receives two paths, the path to the training data and the path to the test data (as that is the way they are split in the original data set).

I first joined the training data into one single data set, and then did the same with the test data to finally merge them into a single data set. It is worth noticing that the train_x and train_y data are merged using the cbind function, as they have the same number of rows. When we do the same with the test data all that is left to do is use the column rbind to get a single complete data set.

# Extract mean and standard deviation
This task is super easy, the only thing you have to do is to call the function sapply as follows:
sapply(data_set, function, na.rm= TRUE)
Of course, changing the function parameter with the function you want to apply (mean / sd). I decided to separate the mean and standard deviation into two separate functions to get the results in a prettier way.

# Name activities
There is a file in the .zip called 'activity labels' which tells you how are the numbers and the activities linked. All you have to do is go trough each number and change it to the activity it has linked, then you take out the column which has the activity as a number and put in it's place the one you just created (the one with the names)

# Name variables
This is way easier than naming activities, as you only have to read the variables names from the 'features.txt' file and assign it to the column names of the data set

# Creting a second tidy data set
This task is a little tricky, but I went with a totally human - readable solution in order to make it as clear as I could for other people to understand it.
First of all, the resultant data set should look as follows
#          -----------------------------------------------------------
#          |    subject     |       activity    |      variable1     | ...
#---------------------------------------------------------------------
#          |        S1      |         A1        |        x11         | ...
#---------------------------------------------------------------------
#          |        S4      |         A2        |        x21         | ...
#---------------------------------------------------------------------

#   ...            ...                ...

First we need to get the info from the test subjects. Since we just joined the train and test data sets (in that order) we don't have to worry about the order.

Once we have the  subjects (both train and test) joined, we append the column to the dataset.

Here is where the tricky part starts, we have to get the rows of a specific subject, let's call that subject s1. Then we have to get the rows of each activity for s1, compute the mean (by column) and add that to a new data frame. (Now that I hear it, it doesn't sound tricky at all)

So that's exactly what you have to do, create vectors with the means for each of the 561 variables, the subject number and the activity. So you are going to have x rows of 563 columns each in the resultant data set.









