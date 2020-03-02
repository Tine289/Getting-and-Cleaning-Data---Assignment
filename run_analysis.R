## Getting and Cleaning Data - Assignment

#Download the data set

files <- "DataSet.zip"

# Checking if archieve already exists.
  if (!file.exists(files)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, files, method="curl")
  }  

# Checking if folder exists
  if (!file.exists("UCI HAR Dataset")) { 
    unzip(files) 
  }


#Assign data frames
  
  features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
  activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
  subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
  x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
  y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
  subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
  x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
  y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


#1. Merge the training and the test sets to create one data set.

  X <- rbind(x_train, x_test)
  Y <- rbind(y_train, y_test)
  Subject <- rbind(subject_train, subject_test)
  Merged_Data <- cbind(Subject, Y, X)

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

library(dplyr)
  Tidy_Data <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set
  Tidy_Data$code <- activities[Tidy_Data$code, 2]

# 4. Appropriately labels the data set with descriptive variable names.

  names(Tidy_Data)[2] = "activity"
  names(Tidy_Data)<-gsub("Acc", "Accelerometer", names(Tidy_Data))
  names(Tidy_Data)<-gsub("Gyro", "Gyroscope", names(Tidy_Data))
  names(Tidy_Data)<-gsub("BodyBody", "Body", names(Tidy_Data))
  names(Tidy_Data)<-gsub("Mag", "Magnitude", names(Tidy_Data))
  names(Tidy_Data)<-gsub("^t", "Time", names(Tidy_Data))
  names(Tidy_Data)<-gsub("^f", "Frequency", names(Tidy_Data))
  names(Tidy_Data)<-gsub("tBody", "TimeBody", names(Tidy_Data))
  names(Tidy_Data)<-gsub("-mean()", "Mean", names(Tidy_Data), ignore.case = TRUE)
  names(Tidy_Data)<-gsub("-std()", "STD", names(Tidy_Data), ignore.case = TRUE)
  names(Tidy_Data)<-gsub("-freq()", "Frequency", names(Tidy_Data), ignore.case = TRUE)
  names(Tidy_Data)<-gsub("angle", "Angle", names(Tidy_Data))
  names(Tidy_Data)<-gsub("gravity", "Gravity", names(Tidy_Data))

#. 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
#     for each activity and each subject.

  Tidy_Data_2 <- Tidy_Data      %>%
    group_by(subject, activity) %>%
    summarise_all(list(mean))

  write.table(Tidy_Data_2, "Tidy_Data.txt", row.name=FALSE)