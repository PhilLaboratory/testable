#### Info: #####
## For questions, or problems, email me or create a github branch with the proposed changes at 
## email: phillips01@g.harvard.edu
## github: https://github.com/phillipsjs/testable


#### start script #####

# This is a script to take the individual participant files from a testable study and merge them into a single file 
## with the demographic information available in the long form data
# make sure there are NO files other than the testable data files in the folder!!

## clear out the environment
rm(list=ls()) 

## set the working directory to the folder where the testable data has been downloaded and unzipped
setwd("C:/Users/Jphil/Desktop/results_files")

files <- list.files()
for(i in 1:length(files)) assign(files[i], read.csv(files[i],header=F,stringsAsFactors=F,na.strings=c("", "NA")))

descript <- get(files[1])[1,][!is.na(get(files[1])[1,])]
variables <- get(files[1])[3,][!is.na(get(files[1])[3,])]
colNum <- length(variables)+length(descript)

## initialize dataframe
d <- get(files[1])
d <- d[-c(1:3),]
colnames(d) <- variables

jd <- data.frame(get(files[1])[2,])
colnames(jd) <- descript

d[,descript] <- jd[1,descript]

## combine all 
for(i in 2:length(files)){
  
  j <- get(files[i])
  j <- j[-c(1:3),]
  colnames(j) <- variables
  
  jd <- data.frame(get(files[i])[2,])
  colnames(jd) <- descript
  
  j[,descript] <- jd[1,descript]
  
  d <- rbind(d,j)
}

setwd("../")
write.csv(d,file="TestData.csv", row.names=F)