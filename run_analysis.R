#
#  - read in the data for single set (train)
#   - (#4) set the column names for subject_test, y_test, X_test
#       as "subject", "activity", and names(2nd column) from features.txt
#  - (#3)Use descriptive activity names
#  - will merge the X_test, y_test, and subject_test into train_data
#
#  - repeat above steps into dataset test_data
#  - merge train_data and test_data datasets into single dataset
#  - Extract any column with "mean" or "std" in name.
#  - find mean of each variable for each activity for each subject

# Assumption is that we run this script while in "UCI HAR Dataset"

print("REQUIRES Plyr package for final output.")
print("Install with: install.packages('plyr')")
print("Load package with: library('plyr'') ")
require(plyr)

features <-read.table(file="features.txt")
activity_labels <- read.table(file='activity_labels.txt')

#test data load
print("Loading test file info...")
X_test <-read.table(file="test/X_test.txt")
y_test <-read.table(file="test/y_test.txt")
subject_test <-read.table(file="test/subject_test.txt")
print("Loading test file info. Done")

print("Updating subject, activity and test data frames")
#update the y_test with descriptive activity and store into
activity_column_test <- apply(y_test,1, function(x)return(activity_labels[x,2]))


#update the column names
names(subject_test) <- c("subject_id")
names(activity_column_test) <- c("activity")

features.transpose <- t(features[,2]) # pulling the variable descriptions
names(X_test) <- features.transpose

print("Updating subject, activity and test data frames.  Done")

#combine the dataset
print("Combining subject, activity and test data frames...")
test_set <- cbind(subject_test, activity_column_test, X_test)
names(test_set)[2]<-"activity" # not sure why 2nd column loses name
print("Combining subject, activity and test data frames.  Done")

# -------------- Train data
#train data load
print("Loading train file info...")
X_train <-read.table(file="train/X_train.txt")
y_train <-read.table(file="train/y_train.txt")
subject_train <-read.table(file="train/subject_train.txt")
print("Loading train file info. Done")

print("Updating subject, activity and train data frames...")
#update the y_train with descriptive activity and store into
activity_column_train <- apply(y_train,1, function(x)return(activity_labels[x,2]))


#update the column names
names(subject_train) <- c("subject_id")
names(activity_column_train) <- c("activity")

features.transpose <- t(features[,2]) # pulling the variable descriptions
names(X_train) <- features.transpose

print("Updating subject, activity and train data frames.  Done")

#combine the dataset
print("Combining subject, activity and train data frames...")
train_set <- cbind(subject_train, activity_column_train, X_train)
names(train_set)[2]<-"activity" # not sure why 2nd column loses name
print("Combining subject, activity and train data frames.  Done")

#-- combining 2 data sets.
print("Combining the train and test datasets...")
single_set<-rbind(test_set,train_set)

print("Extracting columns with 'mean' and standard deviations 'std'")
final_set<-single_set[,c(1, 2, grep("mean|std", names(single_set)))]

# we use the ddply to group-by subject_id and then group-by activity, 
#   using colMeans as the aggregate function of the grouping.
tidy_data <- ddply(final_set,c("subject_id","activity"), function(df)colMeans(df[,3:ncol(df)] ) )

# renaming the data columns since the resulting dataframe represent the mean of each column now.
names(tidy_data) <- lapply(names(tidy_data), function(s)sprintf("MEAN_of_%s", s))
names(tidy_data)[1]<- "subject_id"
names(tidy_data)[2]<- "activity"
print(tidy_data)