# Author: Cruz-Dávalos Diana Ivette
# Version: 2.0
# Date: March 18, 2015

# This was my working directory, please set yours here, e. g. "~/Downloads/GettingAndCleaningData-master/"
setwd("/home/dcruz/Coursera/GettingCleaning/Project/")


# You should create one R script called run_analysis.R that does the following:


# 1 Merges the training and the test sets to create one data set.
# I use the easiest way to load a file, this automatically ignores one or more blank 
# spaces and interpret them as one delimiter, so I get a total of 561 variables.
# After loading the test and the train data sets, I merged them, and the rows
# from the test set are above those of train set. The original order of the rows is mantained,
# this is important for the last step where I associate each row with each subject.

filepath <- "./Data/UCI HAR Dataset/test/X_test.txt"
X_test <- read.table(filepath)


filepath <- "./Data/UCI HAR Dataset/train/X_train.txt"
X_train <- read.table(filepath)

X <- rbind(X_test, X_train)
remove(X_test, X_train)

# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3 Uses descriptive activity names to name the activities in the data set
# As discussed in the forums, there is no problem if I invert these two steps, and 
# 'descriptive activity names' can be the names found in the features.txt file.
# Now I give names to my data set in order to find the columns which suffered the 
# mean() and the std() function application.
# The 'fixed = TRUE' is used in the strict sense that I want to get the column names
# that contain 'mean()' and do not contain an approximation like 'Mean' or just 'mean',
# the same for 'std()'.
# As I obtained a logical vector, it is useful to extract only the columns that include
# the mean or the standard deviation, and joi these subsets to produce my new
# 'almostTidy' table.
filepath <- "./Data/UCI HAR Dataset/features.txt"
features <- read.table(filepath)
colnames(X) <- features$V2

theMean <- sapply(names(X), function(x) grepl("mean()", x, fixed = TRUE))
XMean <- X[theMean]

theSD <- sapply(names(X), function(x) grepl("std()", x, fixed = TRUE))
XSD <- X[theSD]

almostTidy <- cbind(XMean, XSD)
remove(XMean, XSD) # I won't use them anymore, goodbye!

# 4 Appropriately labels the data set with descriptive variable names. 
# Well, this is arbitrary, you can find my explanations in the CodeBook.pdf
DescriptiveNames <- c("MeanTimeBodyAcceleration-X", "MeanTimeBodyAcceleration-Y", "MeanTimeBoddyAcceleration-Z",
                      "MeanTimeGravityAcceleration-X", "MeanTimeGravityAcceleration-Y", "MeanTimeGravityAcceleration-Z",
                      "MeanTimeBodyJerkAcceleration-X", "MeanTimeBodyJerkAcceleration-Y", "MeanTimeBodyJerkAcceleration-Z",
                      "MeanTimeBodyAngularVelocity-X", "MeanTimeBodyAngularVelocity-Y", "MeanTimeBodyAngularVelocity-Z",
                      "MeanTimeBodyJerkAngularVelocity-X", "MeanTimeBodyJerkAngularVelocity-Y", "MeanTimeBodyJerkAngularVelocity-Z",
                      "MeanMagnitudeBodyAcceleration", "MeanMagnitudeGravityAcceleration", "MeanMagnitudeBodyJerkAcceleration",
                      "MeanMagnitudeBodyAngularVelocity", "MeanMagnitudeBodyJerkAngularVelocity", "MeanFourierBodyAcceleration-X",
                      "MeanFourierBodyAcceleration-Y", "MeanFourierBodyAcceleration-Z", "MeanFourierBodyJerkAcceleration-X",
                      "MeanFourierBodyJerkAcceleration-Y", "MeanFourierBodyJerkAcceleration-Z", "MeanFourierBodyAngularVelocity-X",
                      "MeanFourierBodyAngularVelocity-Y", "MeanFourierBodyAngularVelocity-Z", "MeanFourierMagnitudeBodyAcceleration",
                      "MeanFourierMagnitudeBodyBodyAccelerationJerk", "MeanFourierMagnitudeBodyBodyAngularVelocity", "MeanFourierMagnitudeBodyBodyAngularVelocityJerk",
                      
                      "SDTimeBodyAcceleration-X", "SDTimeBodyAcceleration-Y", "SDTimeBoddyAcceleration-Z",
                      "SDTimeGravityAcceleration-X", "SDTimeGravityAcceleration-Y", "SDTimeGravityAcceleration-Z",
                      "SDTimeBodyJerkAcceleration-X", "SDTimeBodyJerkAcceleration-Y", "SDTimeBodyJerkAcceleration-Z",
                      "SDTimeBodyAngularVelocity-X", "SDTimeBodyAngularVelocity-Y", "SDTimeBodyAngularVelocity-Z",
                      "SDTimeBodyJerkAngularVelocity-X", "SDTimeBodyJerkAngularVelocity-Y", "SDTimeBodyJerkAngularVelocity-Z",
                      "SDMagnitudeBodyAcceleration", "SDMagnitudeGravityAcceleration", "SDMagnitudeBodyJerkAcceleration",
                      "SDMagnitudeBodyAngularVelocity", "SDMagnitudeBodyJerkAngularVelocity", "SDFourierBodyAcceleration-X",
                      "SDFourierBodyAcceleration-Y", "SDFourierBodyAcceleration-Z", "SDFourierBodyJerkAcceleration-X",
                      "SDFourierBodyJerkAcceleration-Y", "SDFourierBodyJerkAcceleration-Z", "SDFourierBodyAngularVelocity-X",
                      "SDFourierBodyAngularVelocity-Y", "SDFourierBodyAngularVelocity-Z", "SDFourierMagnitudeBodyAcceleration",
                      "SDFourierMagnitudeBodyBodyAccelerationJerk", "SDFourierMagnitudeBodyBodyAngularVelocity", "SDFourierMagnitudeBodyBodyAngularVelocityJerk")

names(almostTidy) <- DescriptiveNames

# 5 From the data set in step 4, creates a second, independent tidy data set with the averag
e of each variable for each activity and each subject.
# As you can see, I merge the subjects in the same order that I merged the sets (first test, after train) 
# so they can match perfectly and I can join that column to the almostTidy table.
# After that, I add the "Subject" name to the names for my data frame.
# Finally, I use this magic library, 'reshape2' to melt my data frame, indicating the id = 'Subject'
# and after that, with the dcast() function I can apply the mean() function to each variable
# in the melted set, but in ranges defined by the id (the Subject).

filepath <- "./Data/UCI HAR Dataset/test/subject_test.txt"
subject_test <- read.table(filepath)

filepath <- "./Data/UCI HAR Dataset/train/subject_train.txt"
subject_train <- read.table(filepath)

subject <- rbind(subject_test, subject_train)

almostTidy <- cbind(subject, almostTidy)

names(almostTidy) <- c("Subject", DescriptiveNames)

library(reshape2)

meltData <- melt(almostTidy, id="Subject")
tidyData <- dcast(meltData, Subject ~ variable, mean)

# Tan-tan! My TidyData.txt is ready
write.table(tidyData, file="TidyData.txt", sep="\t", col.names = TRUE, row.names=FALSE)
