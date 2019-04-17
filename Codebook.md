Getting and Cleaning UCI Smartphone Data
========================================

In this programming assignment, the data from UCI obtained from measurements recorded on a smartphone was taken and cleaned through R.

The Raw Dataset
---------------

The raw dataset was taken from UCI's machine learning repository, specifically from this url: <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. It contains 561 attributes with a total of 10,299 observations from 30 volunteers within an age bracket of 19-48 years.

Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The Tidy Dataset Criteria
-------------------------

In order for the data set to be considered clean, the following criteria has to be met by the r programming code used to clean the data: 1. Merges the training and the test sets to create one data set. 2. Extracts only the measurements on the mean and standard deviation for each measurement. 3. Uses descriptive activity names to name the activities in the data set 4. Appropriately labels the data set with descriptive variable names. 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Prerequisites

In order to carry out the program, you must have installed R Studio and connected to the internet in order to download the packages and dataset needed.

Code Explanation
----------------

In this section, the lines of code used and the logic behind it will be explained in chronological order.

### Initial Preparation

#### Installing and Running the Packages

The only package needed for this program is dplyr, thus, this must be installed and loaded to the current environment.

install.packages("dplyr") library(dplyr)

#### Downloading the Dataset and Setting Up Working Directory

As previously stated, the dataset that will be used is from UCI's Machine Learning Repository. In order to ensure the code will run smoothly regardless of current working directory, a new path was created which will serve as the new workind directory.

if(!file.exists("UCIdata")){dir.create("UCIdata")} setwd("./UCIdata")

In that working directory, the zip file containing the required dataset for this program was downloaded through the URL below. The newly downloaded zip file is then unzipped to the current working directory.

fileURL&lt;-"<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>" download.file(fileURL,destfile="./UCI.zip") unzip("UCI.zip")

### Coding Proper

#### Reading All the Necessary Data and Binding it Accordingly

The UCI dataset has two main sub-datasets, named for its purposes in their study, which was training and testing. However, these data were further broken down into numerous files. The general procedure for the training and testing dataset was to read all data files with read.table since it's a txt file, then bind them together with column bind, or cbind. The codes for each dataset is shown below.

##### Codes for Reading a Binding Training Datasets

x\_train&lt;-read.table("./UCI HAR Dataset/train/X\_train.txt") y\_train&lt;-read.table("./UCI HAR Dataset/train/y\_train.txt", col.names = c("activity\_number")) sub\_train&lt;-read.table("./UCI HAR Dataset/train/subject\_train.txt", col.names = c("subject")) train\_data&lt;-cbind(x\_train,y\_train,sub\_train)

##### Codes for Reading a Binding Testing Datasets

x\_test&lt;-read.table("./UCI HAR Dataset/test/X\_test.txt") y\_test&lt;-read.table("./UCI HAR Dataset/test/y\_test.txt", col.names = c("activity\_number")) sub\_test&lt;-read.table("./UCI HAR Dataset/test/subject\_test.txt", col.names = c("subject")) test\_data&lt;-cbind(x\_test,y\_test,sub\_test)

Furthermore, the data files for the activity and features (measurement) names were provided. This will only simply be read for now. The read.table codes for these files are shown below activity\_labels&lt;-read.table("./UCI HAR Dataset/activity\_labels.txt", col.names = c("activity\_number","activity")) features&lt;-read.table("./UCI HAR Dataset./features.txt")

#### Merging Training and Testing Dataset

As part of the tidy dataset criteria, the training and testing dataset must be merged into a single data frame, which will allow for easier data manipulation and analysis. The code for merging the train\_data and test\_data, which are the results from the cbind carried out on the files, is shown below.

data\_set&lt;-data.frame(bind\_rows(train\_data,test\_data))

#### Naming the datasets

If you run the code so far, you'd notice the merged table has the default header of V + column number, which doesn't give any indicator as to what information the column contains. Furthermore, only the activity numbers are given, but it would be better if their description is included.

In order to match the activity number with their description, the current data\_set table will be joined with the activity\_labels data using the inner\_join, stored in the variable final\_data\_set. The column names of the resulting data set will be renamed through using the names() command as shown below.

final\_data\_set&lt;-inner\_join(data\_set,activity\_labels,by="activity\_number") names(final\_data\_set) &lt;- c(as.character(features\[,2\]),"activity\_number","subject", "activity")

#### Selecting Only the Mean and Standard Deviation Measurements

Out from the 561 variables, only those containing mean and standard deviation measurements will be included in the tidy dataset. In order proceed with this, the assumption is that any of column names containing the word 'mean' or 'std', whether the first letter is capitalized or not will be selected. This will be carried out with grep, where value = TRUE in order to return the column names selected. Using the match () command returns the index of the columns in the final\_data\_set which have the same column names as the one in mean\_std\_only. The final data set containing only the mean and std measurements will only contain columns defined in col\_index. The code for this is shown below.

mean\_std\_only&lt;-c(grep("*.\[Mm\]ean.*|*.\[Ss\]td.*",features\[,2\],value = TRUE), "activity\_number","subject") col\_index&lt;-match(mean\_std\_only,names(final\_data\_set)) final\_data\_set\_mean\_std&lt;-final\_data\_set\[,col\_index\]

#### Creating and Exporting the Tidy Data Set

The only criteria so far that hasn't been met is creating the tidy data set with only the average measurements of each variable per activity per subject. This will be done with the aggregate command, which allows for a function to be carried on the specified data. The code for this is shown below.

second\_df&lt;-aggregate(final\_data\_set\_mean\_std\[,1:86\], list(final\_data\_set\_mean\_std*a**c**t**i**v**i**t**y*, *f**i**n**a**l*<sub>*d*</sub>*a**t**a*<sub>*s*</sub>*e**t*<sub>*m*</sub>*e**a**n*<sub>*s*</sub>*t**d*subject),mean)

The resulting data set will then be exported into a specified path, which in this case is within the UCI HAR Dataset folder, as a .txt file.

write.table(second\_df,file="./UCI HAR Dataset/tidy\_dataset.txt",row.name=FALSE)

The Tidy Data Set
-----------------

The resulting tidy dataset from this code contains only 88 columns and 180 rows, wherein all columns are properly labeled, and all criteria previously defined was met. This tidy data set is in .txt file format, and can be read with the read.table() command, similar to the UCI dataset.
