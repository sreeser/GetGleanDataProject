# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#

library(data.table)

# go into test directory

xtest<-read.table("UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("UCI HAR Dataset/test/y_test.txt")
subjecttest<-read.table("UCI HAR Dataset/test/subject_test.txt")

# gets the names for the x test/train measurements
xnames<-fread("UCI HAR Dataset/features.txt")
activity_labels<-fread("UCI HAR Dataset/activity_labels.txt")

#loop through the colums in xtest and replace their proper field name
for(i in 1:dim(xtest)[2]) { names(xtest)[i]=xnames[i,V2] }

#combine test datat
testdata<-cbind(subjecttest,ytest,xtest)

# rename the first second columns accurate result
 names(testdata)[1]="Subject"
 names(testdata)[2]="Activity"
# 
# # load train data
xtrain<-read.table("UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("UCI HAR Dataset/train/y_train.txt")
subjecttrain<-read.table("UCI HAR Dataset/train/subject_train.txt")

for(i in 1:dim(xtrain)[2]) { names(xtrain)[i]=xnames[i,V2] }

traindata<-cbind(subjecttrain,ytrain,xtrain)
# rename the first second columns accurate result
names(traindata)[1]="Subject"
names(traindata)[2]="Activity"

tidydata<-rbind(testdata,traindata)