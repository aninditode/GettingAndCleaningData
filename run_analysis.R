library(reshape2)

# Read the subject list, activity labels and dataset for training data
train_subjects <- read.table("train\\subject_train.txt")
train_y <- read.table("train\\Y_train.txt")
train_x <- read.table("train\\X_train.txt")

# Combine the three training datasets by columns into a single dataset
combined_train <- cbind(train_subjects,train_y,train_x)

# Read the subject list, activity labels and dataset for test data
test_subjects <- read.table("test\\subject_test.txt")
test_y <- read.table("test\\Y_test.txt")
test_x <- read.table("test\\X_test.txt")

# Combine the three test datasets by columns into a single dataset
combined_test <- cbind(test_subjects, test_y,test_x)

# Combine the training and test datasets by rows into a single dataset 
data_set <- rbind(combined_train, combined_test)

# Read the feature names, create column headers for combined dataset
# by adding headers for Subject and Activity columns
features <- read.table("features.txt")
colnames(data_set)  <- c("Subject", "Activity", as.character(features[,2]))

# Pick only features that are means or standard deviations
# Create subset with only these features and Subject, Activity columns
col_headers_mean_std <- grep ("mean|std", as.character(features[,2]))
col_headers <- c("Subject", "Activity", as.character(features[col_headers_mean_std,2]))
data_set <- data_set[,col_headers]

# Read activity label list, add headers
activity <- read.table("activity_labels.txt")
colnames(activity) <- c("ActivityLabel", "ActivityDescription")

# Merge activity labels into previous dataset
# Retain the activity descriptions and remove the actiity labels from the dataset
data_set <- merge(data_set, activity, by.x = "Activity", by.y = "ActivityLabel",all = TRUE )
col_headers <- c("Subject", "ActivityDescription", as.character(features[col_headers_mean_std,2]))
data_set <- data_set[,col_headers]

# Clean variable names, remove (, ) and - chars
# Change mean and std to Mean and Std
col_headers <- gsub('std','Std',gsub('mean','Mean',gsub('-','',gsub('[()]','', col_headers))))
colnames(data_set) <- col_headers

# Reshape the dataset with Subject and ActivityDescription as id
# Calculate means by this id
data_set <- melt(data_set, id = c("Subject","ActivityDescription"))
data_set <- dcast (data_set, Subject + ActivityDescription ~ variable, mean)

# Write tidy dataset into file
write.table(data_set, file = "tidy.txt", quote = FALSE, row.names = FALSE)