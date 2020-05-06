#title: "Kurs 3 Week 4 Project"
#author: "TEU"
#date: "6 5 2020"

# Load dplyr library
library(dplyr)

# Load the data
testdata <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
testactivitylabel <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
testsubjects <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")

traindata <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
trainactivitylabel <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
trainsubjects <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")

# Merge the files
mergedtestdata <- cbind(testactivitylabel, testsubjects, testdata)
mergedtraindata <- cbind(trainactivitylabel, trainsubjects, traindata)

mergeddata <- rbind(mergedtestdata, mergedtraindata)

#Read feature labels data
labels <- read.table(".\\UCI HAR Dataset\\features.txt")

# Rename columns in merged data
names(mergeddata) <- c("Activity Label", "Subject", levels(labels$V2)[labels$V2])

#Find indices of data with 'mean()' and 'std()'
indices <- grepl("Activity Label|Subject|mean()|std()", labels$V2)
cleandata <- mergeddata[,indices]

# Add Acitivity label names
activitylabels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")
cleandata <- activitylabels%>%
    inner_join(cleandata, by = c("V1"= "Activity Label"))
names(cleandata)[1:2] <- c("Activity Label", "Activity Name")

# Generate Tidy dataframe
names <- names(cleandata)[-(1:3)]

tidydata <- cleandata %>%
    group_by(Subject, `Activity Name`) %>%
    summarize_at(names, mean, na.rm=TRUE)
write.table(tidydata, file = ".\\tidydataset.txt", sep="\t", row.names = FALSE)