#### Info: #####
## For questions, or problems, email me or create a github branch with the proposed changes at 
## email: jonathan.s.phillips@dartmouth.edu
## github: https://github.com/phillipsjs/testable


#### start script #####

# This is a script to take the individual participant files from a testable study and merge them into a single file 
## with the demographic information available in the long form data
# make sure there are NO files other than the testable data files in the folder!!

## clear out the environment
rm(list=ls()) 

## set the working directory to the folder where the testable data has been downloaded and unzipped
setwd("/Users/name/exampleFolder")

files <- list.files()
for(i in 1:length(files)) assign(files[i], read.csv(files[i],header=F,stringsAsFactors=F,na.strings=c("", "NA")))

## this function should take all of the files from testable and rewrite them so that the demographic data become written to every row

for(i in 1:length(files)){
  r <- get(files[i]) # retrieve each file separately
  descriptN <- as.character(r[1,][!is.na(r[1,])]) # get the names of the participant decriptors for this file
  descript <- data.frame(r[2,]) # get the names of the values for each of the descriptors
  colnames(descript) <- descriptN # write the descriptor names as column names
  variablesN <- as.character(r[3,]) # get the names of the data fields for this file
  w <- length(c(variablesN,descriptN)) # get the total number of columns needed (width of the data)
  l <- length(r[-c(1:3),1]) # get the number of trials completed (length of the data)
  d <- data.frame(matrix(ncol=w,nrow=l)) # build a new dataframe with these widths and lengths
  colnames(d) <- c(variablesN,descriptN) # set the column names to so that data fields come first and then the descriptors
  d[,variablesN] <- r[-c(1:3),] # write the trial-level data to the dataframe
  d[,descriptN] <- descript[1,descriptN] # write the descriptor-level data to each trial
  d <- d[,unique(colnames(d))] # remove any redundant columns
  assign(files[i],d) # rewrite the file with the data in long format with descriptor info on each trial
}

allNames <- c() # create vector to store all names used
allLengths <- c() # create vector to store all lengths observed

for(i in 1:length(files)){ # do this for each file separately
  n <- colnames(get(files[i])) # get the column names for that file
  allNames <- unique(c(n,allNames)) # append any unique column names to the vector of names
  l <- length(get(files[i])[,1]) # get the length (number of trials) for that file
  allLengths <- c(allLengths,l) # append the length of that file to the vector of lengths
}

totalRows <- sum(allLengths) # calculate the total number of trials across all data

# create vector of rows where each participants' data ends
stops <- allLengths 
for(n in 1:length(allLengths)){ 
  stops[n] <- sum(allLengths[0:n])
}

# create vector of rows where each participants' data starts
starts <- allLengths
for(n in 1:length(allLengths)){ 
  starts[n] <- sum(allLengths[0:(n-1)])+1
}

# build the dataframe to contain all of the data from individual files
d <- data.frame(matrix(ncol=length(allNames),nrow=totalRows))
colnames(d) <- allNames

# write each individual participants' data to the relevant subset of that dataframe
for(i in 1:length(files)){
  r <- get(files[i])
  names <- colnames(r)
  start <- starts[i]
  stop <- stops[i]
  
  d[c(start:stop),names] <- r  
}

## this is a warning that your participants answered uneven numbers of trials
if(length(unique(allLengths))>1){
  print("Warning: You have subjects with uneven numbers of responses!")}

setwd("../") ## move yourself one level above the folder where testable data files are stored
write.csv(d,file="CombinedData.csv", row.names=F) #write data file ## You'll likely want to rename this
