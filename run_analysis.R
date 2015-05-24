##setwd("~/Dropbox/Data Science Specialization/Getting and Cleaning Data/data")
rawFeatures <- read.table("UCI HAR Dataset/features.txt")
rawActivityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
##Removing factor levels and treat data as characters
rawActivityLabels$V2 <- as.character(rawActivityLabels$V2)
names(rawActivityLabels)[1] <- "activity"

rawTestData <- read.table("UCI HAR Dataset/test/X_test.txt")
rawSubjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
rawActivityTest <- read.table("UCI HAR Dataset/test/y_test.txt")
##Merge subject data to raw data
mergedTest <- cbind(rawSubjectTest, rawTestData)
##Merge activity labels with activity data
mergedTest <- cbind(rawActivityTest, mergedTest)
##Rename columns for merging
names(mergedTest)[1] <- "activity"
names(mergedTest)[2] <- "subject"
##Merge activity labels in
mergedTest <- merge(rawActivityLabels, mergedTest, by="activity")

rawTrainData <- read.table("UCI HAR Dataset/train/X_train.txt")
rawSubjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
rawActivityTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
##Merge subject data to raw data
mergedTrain <- cbind(rawSubjectTrain, rawTrainData)
##Merge activity labels with activity data
mergedTrain <- cbind(rawActivityTrain, mergedTrain)
##Rename columns for merging
names(mergedTrain)[1] <- "activity"
names(mergedTrain)[2] <- "subject"
##Merge activity labels in
mergedTrain <- merge(rawActivityLabels, mergedTrain, by="activity")

##Merge rawTest & rawTrain
mergedComplete <- rbind.data.frame(mergedTest, mergedTrain)

##Creates a vector with all the variable names.
vFeatures <- rawFeatures[['V2']]
vFeatures <- as.character(vFeatures)
vFeatures <- c("activityKey", "activityLabel", "subject", vFeatures)
##Leave only mean and standard deviation columns behind
colsToKeep <- grepl("mean|std", vFeatures)
colsToKeep[1:3] <- TRUE
reducedComplete <- data.frame(mergedComplete[, colsToKeep])
vFeatures <- vFeatures[colsToKeep]

##Give descriptive variable names
Names <- as.character(vFeatures)
Names <- gsub("-std", "StandardDeviation", Names)
Names <- gsub("-mean", "Mean", Names)
Names <- gsub("\\(\\)", "", Names)
Names <- gsub("-", "", Names)
Names <- gsub("_", "", Names)
for (i in 1:length(Names)) {
    names(reducedComplete)[i] <- Names[i]
}

##Removes the row.names column added from the above line.
rownames(reducedComplete) <- NULL
##Script outputs the summarized tidy data
reducedComplete %>% group_by(subject,activityLabel) %>% summarise_each(funs(mean))
