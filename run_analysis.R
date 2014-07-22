#Script to load Test and Training data for the Coursera Getting And Cleaning Data course project.

library(stringr)

#**Load reference data that is needed for both Test and Train DataSets.

#Load Attribute Name
AttributeName <- read.table("./features.txt")

#Name Attribute Columns
colnames(AttributeName)[1] <- 'FeatureID'
colnames(AttributeName)[2] <- 'FeatureName'


#Load activity_labels
ActivityLabel <- read.table("./activity_labels.txt")
colnames(ActivityLabel)[1] <- 'ActivityLabelID'
colnames(ActivityLabel)[2] <- 'ActivityLabelName'

colnames(TidyData)

#**Load and cleanse data for Test group

#Load Test Result Set
TestResult <- read.table("./test/X_test.txt")

#Transpose AttributeName values to columns of test data
colnames(TestResult) <-  AttributeName[,2] 


#Load Test Subject IDs. Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
TestSubject <- read.table("./test/subject_test.txt")

#Name Attribute Columns
colnames(TestSubject)[1] <- 'SubjectID'


#Load Test ActivityLabelIDS
TestActivity <- read.table("./test/y_test.txt")

#Name Columns
colnames(TestActivity)[1] <- 'ActivityLabelID'


#Merge Activity Labels to the Test Activity data set
TestActivityMerged<-merge(TestActivity,ActivityLabel,by="ActivityLabelID")


#Merge columns together from test data and attribute IDs and descriptions
CompletedTestData<-cbind(TestSubject,TestActivityMerged,TestResult )


#**Load and cleanse data for Training group

#Load Train Result Set
TrainResult <- read.table("./train/X_train.txt")

#Transpose AttributeName values to columns of test data
colnames(TrainResult) <-  AttributeName[,2] 


#Load Training Subject IDs. Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
TrainSubject <- read.table("./train/subject_train.txt")

#Name Attribute Columns
colnames(TrainSubject)[1] <- 'SubjectID'


#Load Train ActivityLabelIDS
TrainActivity <- read.table("./Train/y_Train.txt")

#Name Columns
colnames(TrainActivity)[1] <- 'ActivityLabelID'


#Merge Activity Labels to the Test Activity data set
TrainActivityMerged<-merge(TrainActivity,ActivityLabel,by="ActivityLabelID")


#Merge columns together from train data and attribute IDs and descriptions
CompletedTrainData<-cbind(TrainSubject,TrainActivityMerged,TrainResult )


#**Combine the Test and Training data set and export data.
Output<-rbind (CompletedTestData, CompletedTrainData)

#Keep colums related to the Subject, Activity, mean and standard deviation
TidyData<-Output[,
          (str_detect(colnames(Output),"mean")==TRUE |
          str_detect(colnames(Output),"std") == TRUE  |
          str_detect(colnames(Output),"Subject") == TRUE |
          str_detect(colnames(Output),"ActivityLabel") == TRUE ) &
          str_detect(colnames(Output),"Freq") == FALSE] 



#Export TidyData data to txt file
write.table(TidyData, "./TidyData.txt", sep="\t")


#**Generate data set with the average of each variable for each activity and each subject.

#Group By Subject and Activity within the TidaData data set.
aggdata <-aggregate(TidyData, by=list(TidyData$SubjectID, TidyData$ActivityLabelID, TidyData$ActivityLabelName),FUN=mean, na.rm=TRUE)
drops <- c("SubjectID","ActivityLabelID", "ActivityLabelName")
AggTidyData<-aggdata[,!(names(aggdata) %in% drops)]
colnames(AggTidyData)[1] <- 'SubjectID'
colnames(AggTidyData)[2] <- 'ActivityLabelID'
colnames(AggTidyData)[3] <- 'ActivityLabelName'

#Export AggTidyData data to txt file
write.table(AggTidyData, "./AggTidyData.txt", sep="\t")
