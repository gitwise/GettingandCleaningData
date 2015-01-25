# GettingandCleaningData
 
  This script does the following:
   1 Merges the training and the test sets to create one data set.
   2 Extracts only the measurements on the mean and standard deviation for
	each measurement. 
   3 Uses descriptive activity names to name the activities in the data set
   4 Appropriately labels the data set with descriptive variable names. 
   5 From the data set in step 4, creates a second, independent tidy data set 
	with the average of each variable for each activity and each subject.

Script Description.
  There are 2 datasets, train and test. The features.txt contain the description
	of the variables in each dataset. The activity_labels.txt maps the 
	activity code integer to a descripitve string. Both files are 
	loaded immediately for use with each dataset. 
  
  1) read in the data for single set (train)
	Scripts updates y_test so that code integer in the data frame is 
	the descriptive activity string and store results in activity_column_test
	dataframe with heading "activity".
	Script sets the column names for subject_test and X_test as "subject_id", 
	and descriptive variable names from features.txt's 2nd column.
	With columns and headers setup for the subject_id, activity, and 
	dataset. Script uses a cbind() function to combine the columns into new
	dataframe named test_set.

	The script repeats the above operations for train dataset, and	
	stores the final dataset into dataframe named train_set.

	We merge the test_set and train_set using rbind() and store into
	dataframe single_set. dim(single_set) == (10299, 563)

  2) Scripts extracts, using grep, any column with "mean" or "std" in column 
	name while keeping the subject_id and activity columns. Resulting 
	dataframe is final_set. dim(final_set) == (10299, 81)
	
   3) Descriptive names for activities were handled earlier on in the script
	at Step #1.
	
   4) Script labeled the variables in Step #1.

   5) Script uses the ddply command to calculate the mean of each variable, 
	grouped by activity then grouped by subject_id. Result stored in 
	dataframe tidy_data. dim(tidy_data) == (180,81). Since there are 
	30 subjects with 6 different activities we have 30*6=180 combinations
	mapping 1-1 to each row in tidy_data.
