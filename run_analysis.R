library(dplyr)

fileN <- "getdata%2Fprojectfiles%2FUCI HAR Dataset.zip" 

# if the file does not exist, download it
if(!file.exists(fileN)){
    datasetURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(datasetURL, file, method="curl")
}

# if theres is not a directory with this name, it means that the file was not decompressed 

if(!file.exists("UCI HAR Dataset")){
    unzip(file)
}

# training data

yTraining <- read.table(file.path("UCI HAR Dataset", "train", "y_train.txt"))
subjectsTraining <- read.table(file.path("UCI HAR Dataset", "train", "subject_train.txt"))
xTraining <- read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"))

# test data

yTest <- read.table(file.path("UCI HAR Dataset", "test", "y_test.txt"))
subjectsTest <- read.table(file.path("UCI HAR Dataset", "test", "subject_test.txt"))
xTest <- read.table(file.path("UCI HAR Dataset", "test", "X_test.txt"))


# activity data set
x <- rbind(xTraining, xTest)

# values data set
y <- rbind(yTraining, yTest)

# 'subject' data set
subject <- rbind(subjectsTraining, subjectsTest)


# extracts only the measurements on the mean and standard deviation for each measurement

features <- read.table("UCI HAR Dataset/features.txt")


# get all columns with mean() or std() in their names
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])


x <- x[, mean_std_features]

names(x) <- features[mean_std_features, 2]


activities <- read.table("UCI HAR Dataset/activity_labels.txt")

values[, 1] <- activities[values[, 1], 2]

# correcting names

names(y) <- "activity"
names(subject) <- "subject"


# bind the full dataset
fullDataSet <- cbind(x, y, subject)

# creating tidy dataset
averages <- ddply(fullDataSet, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages, "tidy_data.txt", row.name=FALSE)
