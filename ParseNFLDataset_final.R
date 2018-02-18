#install.packages("stringr")
#install.packages("DataCombine")
#install.packages('reshape2')
#install.packages('data.table')
#install.packages('dplyr')

rm(list=ls())
library(stringr)
library(DataCombine)
library(stringr)
library(reshape2)
library(dplyr)
setwd("C:/Users/lorri/OneDrive/Career/Lorrin/Learning/Learning For Tech Interviews/Data Science/RDataSource")

path <- getwd()
file_list <- list.files(path, pattern="^NFLDemographics_")
print(file_list)
fileName <- "ManuallyEditedNFLDemographics_Race2016_1990.txt"
outFileName <- "NFLByRace2016_1990.csv"
conn <- file(fileName,open="r")
 
data <- readLines(conn)
rwCnt <- length(data)
years <- as.character(c(1990:2016))
races <- c("White", "African-American", "Latino", "Asian", "Other", "International")

#setup data frame
df<-data.frame(race=as.character()
               , percentage=as.numeric()
               , number=as.integer()
               , year=as.integer()
               , stringsAsFactors = FALSE)

#iterate file
i=1
for(i in 1: rwCnt){
  # assign each row to txt
  txt <- data[i]
  #split each row by ", "
  txt_vector<-str_split(txt,", ")
  df_txt_vector<-as.data.frame(txt_vector)
  rwCntdataframe<-nrow(df_txt_vector)
  #get the year
  year <- df_txt_vector[1,]
  i<-1
  for(i in 1:rwCntdataframe){
    race<-c(str_split(df_txt_vector[i,]," "))
    #add year to each race, and unlist to collapse into a single value
    race<-unlist(c(race, as.character(year)))
    #bind each race to the NFLByrace data.frame
    # skip the first row it contains year data
    if(i!=1){
      df[nrow(df)+1
         , ] <- race
      }
    
  }
}

#reshape the data
df_summ <- dcast(df, year~race, value.var="percentage", fill=0)

#write to file 
connOut <-file(outFileName,open="w")
write.csv(df_summ, file=outFileName, append=FALSE,row.names = TRUE, col.names = TRUE)
setwd("C:/Users/lorri/Documents")
close(conn)
close(connOut)

