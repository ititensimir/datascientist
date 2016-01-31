# set the URL of the data repository into a variable and download the ZIP file
# using the aforementioned URL 
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
myZIPFile <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"
download.file(fileURL, destfile = myZIPFile, method = "curl")
# unzip the ZIP file
unzip(myZIPFile)

# load the data from the files and merge them in a dataset (one for x, one for y, one for subject)
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
x_dataset <- rbind(x_train, x_test)

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
y_dataset <- rbind(y_train, y_test)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subject_dataset <- rbind(subject_train, subject_test)

# extract the measurements of the mean and standard deviation from features and  
# friendly rename columns
features <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- c('features_id', 'features_name')
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
x_train <- x_train[, index_features]
names(x_train) <- gsub("\\(|\\)", "", (features[index_features, 2]))

# set descriptive names and labels for the activities data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c('act_id', 'act_name')
y_train[, 1] = activities[y_train[, 1], 2]

#add column names
names(y_train) <- "activity"
names(subject_train) <- "subject"

#merge the previous datasets to a clean one
myCleanData <- cbind(subject_train, y_train, x_train)

p <- myCleanData[, 3:dim(myCleanData)[2]]
myCleanDataMean <- aggregate(partial,list(myCleanData$subject, myCleanData$activity), mean)
#add column names as previously done with partial datasets
names(myCleanDataMean)[1] <- "Subject"
names(myCleanDataMean)[2] <- "Activity"

# file and directories for the clean output
cleanDataFile <- "./tidy-UCI-HAR-dataset.txt"
write.table(myCleanData, cleanDataFile)

cleanDataFileMean <- "./tidy-UCI-HAR-dataset-AVG.txt"
write.table(myCleanDataMean, cleanDataFileMean)
