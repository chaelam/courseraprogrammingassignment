#install and read necessary packages
install.packages("dplyr")
library(dplyr)

#install files
if(!file.exists("UCIdata")){dir.create("UCIdata")}
setwd("./UCIdata")
fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="./UCI.zip")
unzip("UCI.zip")

#read all data from training set and cbind them together
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt") 
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt",
                    col.names = c("activity_number"))
sub_train<-read.table("./UCI HAR Dataset/train/subject_train.txt", 
                      col.names = c("subject"))
train_data<-cbind(x_train,y_train,sub_train)

#read all data from test set and cbind them together
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt",
                   col.names = c("activity_number"))
sub_test<-read.table("./UCI HAR Dataset/test/subject_test.txt",
                     col.names = c("subject"))
test_data<-cbind(x_test,y_test,sub_test)

#read activity and features list
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",
                            col.names = c("activity_number","activity"))
features<-read.table("./UCI HAR Dataset./features.txt")

#merge the train and test data sets
data_set<-data.frame(bind_rows(train_data,test_data))

#name activities of data_set based on the activity_number
final_data_set<-inner_join(data_set,activity_labels,by="activity_number")

#name x data set columns with features list
final_data_set<-inner_join(data_set,activity_labels,by="activity_number")
names(final_data_set) <- c(as.character(features[,2]),"activity_number","subject",
                           "activity")

#selects only the mean and standard deviation measurements
mean_std_only<-c(grep("*.[Mm]ean.*|*.[Ss]td.*",features[,2],value = TRUE),
                 "activity_number","subject")
col_index<-match(mean_std_only,names(final_data_set))
final_data_set_mean_std<-final_data_set[,col_index]

#create a data set tidy data set with the average of each variable for each activity 
#and each subject
second_df<-aggregate(final_data_set_mean_std[,1:86],
                     list(final_data_set_mean_std$activity,
                          final_data_set_mean_std$subject),mean)
colnames(second_df)[1:2]<-c("activity","subject")
View(second_df)

#export tidy data set to txt file
write.table(second_df,file="./UCI HAR Dataset/tidy_dataset.txt",row.name=FALSE) 
View(read.table("./UCI HAR Dataset/tidy_dataset.txt",header = TRUE))
