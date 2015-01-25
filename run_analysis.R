library(dplyr)
library(data.table)

x.test <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="",
                              header=FALSE)
y.test <- read.csv("UCI HAR Dataset/test/y_test.txt", sep="",
                              header=FALSE)
subject.test <- read.csv("UCI HAR Dataset/test/subject_test.txt",
                                    sep="", header=FALSE)
test <- data.frame(subject.test, y.test, x.test)

x.train <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="",
                               header=FALSE)
y.train <- read.csv("UCI HAR Dataset/train/y_train.txt", sep="",
                               header=FALSE)
subject.train <- read.csv("UCI HAR Dataset/train/subject_train.txt",
                                    sep="", header=FALSE)
train <- data.frame(subject.train, y.train, x.train)

run.data <- rbind(train, test)

remove(subject.test, x.test, y.test, subject.train,
       x.train, y.train, test, train)

features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
column.names <- as.vector(features[, 2])
colnames(run.data) <- c("subject_id", "activity_labels", column.names)

run.data <- select(run.data, contains("subject"), contains("label"),
                       contains("mean"), contains("std"), -contains("freq"),
                       -contains("angle"))

activity.labels <- read.csv("UCI HAR Dataset/activity_labels.txt", 
                            sep="", header=FALSE)

run.data$activity_labels <- as.character(activity.labels[
  match(run.data$activity_labels, activity.labels$V1), 'V2'])


#colnames(run.data) <- gsub("\\(\\)", "", colnames(run.data))
#colnames(run.data) <- gsub("-", "_", colnames(run.data))
#colnames(run.data) <- gsub("BodyBody", "Body", colnames(run.data))

setnames(run.data, colnames(run.data), gsub("\\(\\)", "", colnames(run.data)))
setnames(run.data, colnames(run.data), gsub("-", "_", colnames(run.data)))
setnames(run.data, colnames(run.data), gsub("BodyBody", "Body", colnames(run.data)))

run.data.summary <- run.data %>%
  group_by(subject_id, activity_labels) %>%
  summarise_each(funs(mean))
