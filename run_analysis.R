## You should create one R script called run_analysis.R that does the following. 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for 
## each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data 
## set with the average of each variable for each activity and each subject.
require(plyr)
labels <- read.table("sourceData/activity_labels.txt")
features <- read.table("sourceData/features.txt")

if(file.exists("allData.csv")) {
  print("allData.csv already exists. Reading dataframe")
  allData <- read.csv("allData.csv")
} else { ## 1. Data are combined columnwise then rowwise
  print("allData.csv not found. Combining source data.")
  allData <- rbind(cbind(read.table("sourceData/test/subject_test.txt"),
                         read.table("sourceData/test/y_test.txt"),
                         read.table("sourceData/test/X_test.txt")), 
                   cbind(read.table("sourceData/train/subject_train.txt"),
                         read.table("sourceData/train/y_train.txt"),
                         read.table("sourceData/train/X_train.txt")))
  ## 4. Renames the columns
  colnames(allData) <- c("subject", "label", as.vector(features[,2]))
  allData$label <- factor(allData$label)
  write.csv(allData, "allData.csv", row.names = FALSE)
}

## 2. subsets only the mean/std measurements 
subset.mean.std <- allData[,1:2]
for (i in 3:563) { 
  stringCheck <- colnames(allData)[i]
  if(grepl("mean", stringCheck) | grepl("std", stringCheck)) {
    subset.mean.std <- cbind(subset.mean.std, allData[,i])
    colnames(subset.mean.std)[ncol(subset.mean.std)] <-stringCheck
  } 
}
## 3. Label activities
subset.mean.std$label <- factor(mapvalues(subset.mean.std$label,
                                          from = 1:6, to = as.character(labels[,2])))
## first tidy dataset now stored as subset.mean.std

## 5.
avg.subj <- data.frame() # average of each activity by subject
for(i in 1:30) {
  a <- subset(subset.mean.std, subject==i)
  b <- i
  for(j in 3:81) {b <- c(b, mean(a[,j]))}
  avg.subj <- rbind(avg.subj, b)
}


avg.actv <- data.frame() # average of each activity by 
for(i in labels[,2]) {
  a <- subset(subset.mean.std, label==i)
  b <- vector()
  for(j in 3:81) {b <- c(b, mean(a[,j]))}
  avg.actv <- rbind(avg.actv, b)
}
avg.actv <- cbind(labels[,2], avg.actv)
colnames(avg.subj) <- c("category", colnames(subset.mean.std)[3:81])
colnames(avg.actv) <- colnames(avg.subj)

all.avgs <- rbind(avg.subj, avg.actv)
write.table(all.avgs, "all.avgs.txt", row.name=FALSE)
