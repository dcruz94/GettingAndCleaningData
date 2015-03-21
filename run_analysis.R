  # You should create one R script called run_analysis.R that does the following. 


setwd("/home/dcruz/Coursera/GettingCleaning/Project/")

# 1 Merges the training and the test sets to create one data set.
filepath <- "./Data/UCI HAR Dataset/test/X_test.txt"
X_test <- read.table(filepath)


filepath <- "./Data/UCI HAR Dataset/train/X_train.txt"
X_train <- read.table(filepath)

X <- rbind(X_test, X_train)
remove(X_test, X_train)

# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3 Uses descriptive activity names to name the activities in the data set
filepath <- "./Data/UCI HAR Dataset/features.txt"
features <- read.table(filepath)
colnames(X) <- features$V2

theMean <- sapply(names(X), function(x) grepl("mean()", x, fixed = TRUE))
XMean <- X[theMean]

theSD <- sapply(names(X), function(x) grepl("std()", x, fixed = TRUE))
XSD <- X[theSD]

almostTidy <- cbind(XMean, XSD)
remove(XMean, XSD)

# 4 Appropriately labels the data set with descriptive variable names. 
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

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

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
write.table(tidyData, file="TidyData.txt", sep="\t", col.names = TRUE, row.names=FALSE)
