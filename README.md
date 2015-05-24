---
title: "README"
author: "Chris Lankford"
date: "May 24, 2015"
output: html_document
---
<b>Script Explaination</b>
<br/>
Step 1: the script retrieves the feature and label data and cleans it up for use in later steps.
```{r}
rawFeatures <- read.table("UCI HAR Dataset/features.txt")
rawActivityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
##Removing factor levels and treat data as characters
rawActivityLabels$V2 <- as.character(rawActivityLabels$V2)
names(rawActivityLabels)[1] <- "activity"
```
Step 2: the script retrieves all of the test data first, combines it with the subject data and activity data. Then it cleans up some column names and merges the data set with the activity labels to have descriptive activity details for each observation.
```{r}
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
```
Step 3: the script retrieves all of the training data, combines it with the subject data and activity data. Then it cleans up some column names and merges the data set with the activity labels to have descriptive activity details for each observation.
```{r}
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
```
Step 4: merges the training data and the test data together into a single larger data set.
```{r}
##Merge rawTest & rawTrain
mergedComplete <- rbind.data.frame(mergedTest, mergedTrain)
```
Step 5: creates a vector with all the feature names and then identifies and removes any features that are not a mean or standard deviation value, then this is applied to the actual data set.
```{r}
##Creates a vector with all the variable names.
vFeatures <- rawFeatures[['V2']]
vFeatures <- as.character(vFeatures)
vFeatures <- c("activityKey", "activityLabel", "subject", vFeatures)
##Leave only mean and standard deviation columns behind
colsToKeep <- grepl("mean|std", vFeatures)
colsToKeep[1:3] <- TRUE
reducedComplete <- data.frame(mergedComplete[, colsToKeep])
vFeatures <- vFeatures[colsToKeep]
```
Step 6: cleans up feature names to be more descriptive and clear, then renames the variables of the data set to be the feature names.
```{r}
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
```
Step 7: removes some unwanted variables and outputs the summarized data set by subject and activity.
```{r}
tidyData <- reducedComplete[2:nrow(reducedComplete),]
##Removes the row.names column added from the above line.
rownames(tidyData) <- NULL
##Script outputs the summarized tidy data
tidyData %>% group_by(subject,activityLabel) %>% summarise_each(funs(mean))
```
</br>
</br>
<b>Variable descriptions</b>
</br>
subject: identifies the participant who had observations taken for them with the device.
activityLabel: describes the activity that the observation was taken for
activityKey: the ID value of the activity being observed
</br>
</br>
The next 79 variables are all measurements taken by the device, each observation of these variables is the mean of all observations for a given activity for the particular subject identified in the first column of the observation.