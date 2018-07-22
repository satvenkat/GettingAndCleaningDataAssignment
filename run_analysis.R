# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.

#Getting Activity Label Data
require(data.table)
require(plyr)

activityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE )
colNamesActLabels=c("ActivityLabelID","ActivityLabel")
colnames(activityLabels)<-colNamesActLabels

#Getting and storing Subject Data for Test and Train
subjectTest<-read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
colnames(subjectTest)<-c("subjectID")
subjectTrain<-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
colnames(subjectTrain)<-c("subjectID")

# Combining Y with Activity Labels for Test and Train
ytest<-read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
dim(ytest)
colnames(ytest)<-c("ActivityLabelID")
comb_ytest<-join(ytest,activityLabels)

ytrain<-read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
dim(ytrain)
colnames(ytrain)<-c("ActivityLabelID")
comb_ytrain<-join(ytrain,activityLabels)

# Adding subject level data to resultant from above for Test and Train
comb_Activ_Subj_Test<-cbind(subjectTest,comb_ytest)
comb_Activ_Subj_Train<-cbind(subjectTrain,comb_ytrain)

#Reading the stats X
xtest<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
dim(xtest)
xtrain<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
dim(xtrain)

#Merging the X and Y test and train set
combinedX<-rbind(xtest,xtrain)
combinedY<-rbind(comb_Activ_Subj_Test,comb_Activ_Subj_Train)

#Now get the features dataset to tie it in with the columns of X
features<-read.table("./UCI HAR Dataset/features.txt", header=FALSE )
features<-features[-c(1)] #(remove the first column from features)
colnames(features)<-c("featureName")
colnames(combinedX)<-features$featureName #Setting the column Names of X to be more descriptive

#Extract only the columns that have mean or std in them
filtColumns_combinedX<-combinedX[,grep("-mean()|-std()",names(combinedX))]
filtColumns_combinedX<-filtColumns_combinedX[-c(grep("-meanFreq",names(filtColumns_combinedX)))] #exluding the meanFreq which was also somehow included

#Finally combine X and Y
allCombined<-cbind(combinedY,filtColumns_combinedX)
allCombined<-allCombined[-c(which( colnames(allCombined)=="ActivityLabelID" ))]
#Removing the column related to the label ID since it is not required for the grouping
 #From now on, we can work off of allCombined which is a tidy data set.
#There is one measure for each row
        # one observation for each column

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

allCombined_meanByActSubject<-allCombined %>% group_by(ActivityLabel,subjectID) %>% summarise_all(funs(mean))
write.table(allCombined_meanByActSubject,file="analysis_results.txt", row.names=FALSE)