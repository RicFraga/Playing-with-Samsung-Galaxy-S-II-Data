source('Source/run_analysis.R')

training_path = 'Data/UCI HAR Dataset/train/'
test_path = 'Data/UCI HAR Dataset/test/'

merged <- merge_data_sets(training_path, test_path)
print('Dimensions of the merged data set:')
print(dim(merged))

means <- measurement_means(merged)
print('Length of the merged means: ')
print(length(means))

sds <- measurement_sd(merged)
print('Length of the merged sd: ')
print(length(sds))

named_variables <- name_variables(merged)
View(named_variables)

named_activities <- name_activities(named_variables)
View(named_activities)

average <- average_dataset(named_activities)
View(average)
