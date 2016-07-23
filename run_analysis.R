url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,"database.zip")
unzip("database.zip",exdir="final_project")
#list.files("final_project")
#list.files("final_project/UCI HAR Dataset/test/Inertial Signals")

library(reshape2)

#Load various datasets
test.subject<-read.table("./final_project/UCI HAR Dataset/test/subject_test.txt")
test.x<-read.table("./final_project/UCI HAR Dataset/test/X_test.txt")
test.y<-read.table("./final_project/UCI HAR Dataset/test/y_test.txt")

train.subject<-read.table("./final_project/UCI HAR Dataset/train/subject_train.txt")
train.x<-read.table("./final_project/UCI HAR Dataset/train/X_train.txt")
train.y<-read.table("./final_project/UCI HAR Dataset/train/y_train.txt")

features<-read.table("./final_project/UCI HAR Dataset/features.txt")
activity.lables<-read.table("./final_project/UCI HAR Dataset/activity_labels.txt")


#Merge test and train subject datasets
subject<-rbind(test.subject,train.subject)
#View(subject)
colnames(subject)<-"subject"
#View(subject)

# Merge test and train labels,applying textual labels
###View(activity.lables)
###View(test.y)
label<-rbind(test.y,train.y)
label<-merge(label,activity.lables,by=1)[,2]
###View(label)

#Merge the test and train main dataset, applying the textual headings
###View(features)
data<-rbind(test.x,train.x)
####View(data)
colnames(data)<-features[,2]
####View(data)


# Merge all three datasets
data <- cbind(subject, label, data)
####View(data)

# Create a smaller dataset containing only the mean and std variables
search<-grep("-mean|-std",colnames(data))
data.std.mean<-data[,c(1,2,search)]
###View(data.std.mean)

# Compute the means, grouped by subject/label
melted=melt(data.std.mean,id.var=c("subject","label"))
###View(melted)
means=dcast(melted,subject+label ~ variable,mean)
###View(means)

# Save resulting dataset
write.table(means,file="./final_project/tidy_data.txt",row.names = FALSE)

#Output final dataset
means