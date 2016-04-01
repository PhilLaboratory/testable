#### Info: #####
## For questions, or problems, email me or create a github branch with the proposed changes at 
## email: phillips01@g.harvard.edu
## github: https://github.com/phillipsjs/testable


#### start script #####

# This is a script to take the individual participant files from a testable study and merge them into a single file
# make sure there are NO files other than the testable data files in the folder!!

## clear out the environment
rm(list=ls()) 

## set the working directory to the folder where the testable data has been downloaded
setwd("C:/Users/Jphil/Desktop/results_files")

files <- list.files()
for(i in 1:length(files)) assign(files[i], read.csv(files[i],header=F,stringsAsFactors=F))

colNum <- length(get(files[1]))

d <- data.frame(matrix(nrow=0,ncol=colNum))
colnames(d) <- get(files[1])[3,]

for(i in 1:length(files)){
   j <- get(files[i])
   
   j$turkID <- j[2,1]         # get Mturk ID
   j$age <- j[2,2]            # get age
   j$sex <- j[2,3]            # get sex
   j$education <- j[2,4]      # get education
   j$handedness <- j[2,5]     # get handedness
   j$sexOrientation <- j[2,6] # get sexual orientation
   j$ethnicity <- j[2,7]      # get ethnicity
   j$ethnicity <- j[2,8]      # get nationality
   j$other1 <- j[2,9]         # get other 1
   j$other2 <- j[2,10]         # get other 2
   j$other3 <- j[2,11]         # get other 3
   j$other4 <- j[2,12]         # get other 4
   j$other5 <- j[2,13]        # get other 5
   j$browser <- j[2,14]       # get browser
   j$version <- j[2,15]       # get version
   j$screenWidth <- j[2,16]   # get screen width
   j$screenHeight <- j[2,17]  # get screen height
   j$OS <- j[2,18]            # get operating system
   j$OS_lang <- j[2,19]       # get operating system language
   j$calibration <- j[2,20]   # get calibration
   j$ip <- j[2,21]            # get IP address
   j$code <- j[2,22]          # get completion code

   j <- j[-c(1:3),]
   d <- rbind(d,j)
   }

colnames(d) <- c(get(files[1])[3,],colnames(d[,tail(colnames(d),n=21)]))

setwd("../")
write.csv(d,file="TestData.csv", row.names=F)
