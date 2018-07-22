---
title: "Getting and Cleaning Data Assignment"
author: "Satish Venkataraman"
date: July 21, 2018
output: html_document
---
This README explains how i did this assignment, including the logic and the datasets that were used.  At a high level, this code has several data sets which have a primary key/foreign key relationship that needs to be understood, and joined together based on those keys, and further merged to create a single tidy data set that includes only those columns that we need, before performing further analysis on it.

> Data Sets that I used

***

* Activity Labels (contains an activity ID and Activity Name)
* Features (contain all of the features that correspond to the columns in the X data set, essentially forming the header to the X data set)
For each of the test and train, there are:
* Subjects - like a person ID on whom it was tested.  This corresponds to each row and show which subjectID did that test.
* X - This contains the various statistics that were recorded during testing
* Y - This contains the activity ID corresponding to each row in X.  A meaningful value of this activity ID is gotten by tying it with the Activity Labels.

> Merges the training and the test sets to create one data set & Uses descriptive activity names to name the activities in the data set

***

* Read the activity labels from activity_labels.txt file and gave them column IDs of ActivityID and ActivityLabel.
* Read the subjects from the training and the test and gave them column ID of subject ID.
* Read the Y values for train and test and joined them with activity labels since it has a common key of activityID in it.  This way the values within Y will be recognized for the activity that it corresponds to.
* Combined(added a column) for the subject with the above result.  Now the Y values have a combination of the subject and what activity they performed.  This results in the two data frames comb_Activ_Subj_Test & comb_Activ_Subj_Train.
* Now, I read all of the x values for the train and the test and merged the rows to form one big x data set called combined_X.
Similarly I merge the rows with the cbind function for the Comb_activ_subj for test and train.

> Appropriately labels the data set with descriptive variable names.

***

* I read the features from features.txt file, which has 561 columns which correspond to the columns in X.  This is just to set the header names for the X, and i associate the header of X with the features that i just read and cleaned up.

> Extracts only the measurements on the mean and standard deviation for each measurement.

***

* I now extract only the columns I needed from combinedX using grep for mean() or std().  
* At this point, I combine all of the X and Y values using the cbind.  I have stored this in a variable called allCombined.

> From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

***

* I use the the group by activityLabel and Subject to summarize based on mean of each of the stats in allCombined.