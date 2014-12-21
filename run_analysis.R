# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#

library(data.table)
library(plyr)

#if(!file.exists("./data")){dir.create("./data")}
#fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileurl,destfile="./data/data.zip",method="curl")
#unzip("./data/data.zip")

# go into test directory

xtest<-read.table("data/UCI HAR Dataset/test/X_test.txt")
ytest<-read.table("data/UCI HAR Dataset/test/y_test.txt")
subjecttest<-read.table("data/UCI HAR Dataset/test/subject_test.txt")

# gets the names for the x test/train measurements
xnames<-fread("data/UCI HAR Dataset/features.txt")
activity_labels<-fread("data/UCI HAR Dataset/activity_labels.txt")

#loop through the colums in xtest and replace their proper field name
for(i in 1:dim(xtest)[2]) { names(xtest)[i]=xnames[i,V2] }

#combine test datat
testdata<-cbind(subjecttest,ytest,xtest)

#more cleanup
remove(subjecttest,ytest,xtest)

# rename the first second columns accurate result
 names(testdata)[1]="SubjectID"
 names(testdata)[2]="ActivityID"
# 
# # load train data
xtrain<-read.table("data/UCI HAR Dataset/train/X_train.txt")
ytrain<-read.table("data/UCI HAR Dataset/train/y_train.txt")
subjecttrain<-read.table("data/UCI HAR Dataset/train/subject_train.txt")

for(i in 1:dim(xtrain)[2]) { names(xtrain)[i]=xnames[i,V2] }

traindata<-cbind(subjecttrain,ytrain,xtrain)

#more cleanup
remove(subjecttrain,ytrain,xtrain)

# rename the first second columns accurate result
names(traindata)[1]="SubjectID"
names(traindata)[2]="ActivityID"

#combine the test and train data
data<-rbind(testdata,traindata)

#more cleanup
remove(testdata,traindata)

#subset data to get only subject/activity/mean/std values
data2<-data[,grep("SubjectID|ActivityID|mean()|std()",names(data))]

#replace the activity types
activitydata<-merge(data2,activity_labels,by.x="ActivityID",by.y="V1",all=TRUE)

names(activitydata)[82]="Activity"

#rearrange the columns 
activitydata<-activitydata[,c(2,82,3:81)]

#final cleanup
remove(xnames,data,data2,activity_labels,i)

#now that everythings cleaned up and reorganized, now we can get our tidy dataset
tidydata<-summarise_each(group_by(activitydata, SubjectID, Activity), funs(mean))

#write out the new tidier data set
write.table(tidydata,"tidydata.txt",row.names=TRUE)