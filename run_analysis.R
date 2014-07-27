#load the x test

load_x_data <- function() {
  
  library(dplyr)
  library(plyr)
  
  #load the data files
  x_test_data <- read.table("./UCI HAR Dataset/test/x_test.txt")
  y_test_key <- read.table("./UCI HAR Dataset/test/y_test.txt")
  subjects_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  
  x_train_data <- read.table("./UCI HAR Dataset/train/x_train.txt")
  y_train_key <- read.table("./UCI HAR Dataset/train/y_train.txt")
  subjects_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

  #transpose the column header data and place into variable
  columns <- t(data.frame((read.table("./UCI HAR Dataset/features.txt",sep="\t"))))
 
  #create a csv file and read into a dataframe.  Loop through the dataframe and set the names
  #of each variable in both data sets
  write.table(columns,file="./temp.csv",col.names=FALSE,row.names=FALSE)
  myHeader <- read.table("./temp.csv")
  colNamesDF <- colnames(myHeader)
  
  i <- 1
    while (i <= length(colNamesDF)){
    names(x_test_data)[names(x_test_data) == colNamesDF[i]] <- toString(myHeader[,i])
    names(x_train_data)[names(x_train_data) == colNamesDF[i]] <- toString(myHeader[,i])
    i <- i+1
  }
 
 #bind the participants, activities, and measurements together
 fullDF <- rbind(x_test_data,x_train_data)
 fullDFKey <- rbind(y_test_key,y_train_key)
 fullParticipants <- rbind(subjects_test,subjects_train)
 
#set the activity name based on code
 i <- 1
 while (i <= nrow(fullDFKey)){
   if(fullDFKey[i,1] == 1){
     fullDFKey[i,1] <- "walking"
   }
   else if(fullDFKey[i,1] == 2){
     fullDFKey[i,1] <- "walking_upstairs"
   }
   else if(fullDFKey[i,1] == 3){
     fullDFKey[i,1] <- "walking_downstairs"
   }
   else if(fullDFKey[i,1] == 4){
     fullDFKey[i,1] <- "sitting"
   }
   else if(fullDFKey[i,1] == 5){
     fullDFKey[i,1] <- "standing"
   }
   else if(fullDFKey[i,1] == 6){
     fullDFKey[i,1] <- "laying"
   } 
     
     i <- i + 1
 }
 
#give the activity column a proper name and bind the measurment data to the activity data
colnames(fullDFKey)[1] <- "activity"
 
 finalDF <- cbind(fullDFKey,fullDF)
 
 #column 1 is activity, so start with the first measurement (column 2)
 i = 2
 colCount <- ncol(columns)
  
 columnID <- data.frame()
 columnName <- data.frame(StringsAsFactors=FALSE)
 indicator = 0

 #create first two columns of small frame
 smallFrame <- finalDF[,1]
 smallFrame <- cbind(smallFrame,fullParticipants[,1])

 k <- ncol(finalDF)

 dataColumns = colnames(finalDF)[1:k]

 columns <- cbind("activity",columns)

 m <- 3

  while(i <= colCount){
    
    
    if(grepl("-mean\\(\\)",columns[,i]) | grepl("-std\\(\\)",columns[,i]) ){
      
      #print(columns[,i])
      #print(names(finalDF[i]))
      
      columnID <- rbind(columnID,i)
      smallFrame <- cbind(smallFrame,finalDF[,i,drop=FALSE])    
    }
    i = i+1
    m = m +1
  }

#rename the first two columns of DF
colnames(smallFrame)[1] <- "activity"
colnames(smallFrame)[2] <- "subject"

#compute the average of each measurement column and group by activity and subject
k <- ncol(smallFrame)
groupColumns = colnames(smallFrame)[1:2]
dataColumns = colnames(smallFrame)[3:k]
res = ddply(smallFrame,groupColumns,function(x) colMeans(x[dataColumns]))


i <- 3
while(i <= k){
  
  #remove number from name
  colnames(res)[i] <- gsub(" ","!",colnames(res)[i])
  indicator <- gregexpr("!",colnames(res)[i],fixed=TRUE)[[1]]
  colnames(res)[i] <- substr(colnames(res)[i],indicator[[1]]+1,nchar(names(res)[i]))
  
  #standardize mean and std dev names
  colnames(res)[i] <- gsub("-mean\\(\\)-","Mean",colnames(res)[i])
  colnames(res)[i] <- gsub("-mean\\(\\)","Mean",colnames(res)[i])
  colnames(res)[i] <- gsub("-std\\(\\)-","StdDev",colnames(res)[i])
  colnames(res)[i] <- gsub("-std\\(\\)","StdDev",colnames(res)[i])
  
  #expand time and freq abbreviations
  firstChar <- substr(colnames(res)[i],1,1)
  if(firstChar == "t"){
    colnames(res)[i] <- paste("time",substr(colnames(res)[i],2,nchar(names(res)[i])),collapse='')
    colnames(res)[i] <- gsub(" ","",colnames(res)[i])
  } 
  if(firstChar == "f"){
    colnames(res)[i] <- paste("freq",substr(colnames(res)[i],2,nchar(names(res)[i])),collapse='')
    colnames(res)[i] <- gsub(" ","",colnames(res)[i])
  } 
  
  #expand on body, magnitude, and accelerator abbreviations
  colnames(res)[i] <- gsub("BodyBody","Body",colnames(res)[i])
  #print(colnames(res)[i])
  
  colnames(res)[i] <- gsub("Mag","Magnitude",colnames(res)[i])
  #print(colnames(res)[i])
  
  colnames(res)[i] <- gsub("Acc","Accelerator",colnames(res)[i])
 # print(colnames(res)[i])
 
 #print(names(res[i]))
 #print(class(res[,1]))
  
  i <- i+1 
}

write.table(res,file="./tidy_data.txt",col.names=TRUE,row.names=FALSE, sep=",")
    
}