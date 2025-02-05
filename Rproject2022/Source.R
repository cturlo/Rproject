#contacted by US CDC to evaluate EID outbreak
#Goal 1: import data
#Set working directory, generate lists of file-paths to operate on
setwd("/Users/chris_turlo/Desktop/Rproject/Rproject2022")
filenamesX <- list.files(path = "/Users/chris_turlo/Desktop/Rproject/Rproject2022/countryX", pattern = "screen_[0-9]{3}.csv")
filenamesY <- list.files(path = "/Users/chris_turlo/Desktop/Rproject/Rproject2022/countryY", pattern = "screen_[0-9]{3}.txt")

#FUNCTIONAL DESIGN DO NOT EDIT
#CSV Conversion Function
#Write a function that converts all files in a directory with space/tab delimited data (.txt) into a .csv file
#Usage: dir = directory path, separator = how original file is delimited, specify " " for space, "\t" for tab
CSVConverter<-function(dir, separator){
  setwd(dir)
  filenames <- list.files(path = dir, pattern = ".txt")
  for(i in 1:length(filenames)){
    input<-filenames[i]
    output<-paste0(gsub("\\.txt$", "", input), ".csv")
    data = read.table(input, header=TRUE, sep=separator)
    write.table(data, file=output, sep=',', col.names=TRUE, row.names=FALSE)
  }
}

CSVConverter("/Users/chris_turlo/Desktop/Rproject/Rproject2022/CountryY"," ")


#During compilation, for whatever reason, my CSV files for CountryX were not compiling. 
#I generated this alternative to CSVConverter called TXT Converter
#Then I converted countryX to .txt files and then BACK to .csv files and the problems were resolved

TXTConverter<-function(dir, separator){
  setwd(dir)
  filenames <- list.files(path = dir, pattern = ".csv")
  for(i in 1:length(filenames)){
    input<-filenames[i]
    output<-paste0(gsub("\\.csv$", "", input), ".txt")
    data = read.table(input, header=TRUE, sep=separator)
    write.table(data, file=output, sep=' ', col.names=TRUE, row.names=FALSE)
  }
}

TXTConverter("/Users/chris_turlo/Desktop/Rproject/Rproject2022/CountryX", ',')
CSVConverter("/Users/chris_turlo/Desktop/Rproject/Rproject2022/CountryX", ' ')

##MORE ELEGANT COMPILE FUNCTION
#This function takes a directory, and a Country (in quotes) and outputs a compiled file of all .csv files within the directory
#This function adds a column to the file called "country" specifying where it comes from.

Compile <- function(dir, Country){
  setwd(dir)
  filelist<-list.files(path=dir, pattern=".csv")
  #Prompts to remove incomplete data from the set (for if working with datasets with incomplete testing information)
  manual_input_1 <- readline(prompt = "Would you like to remove incomplete data? (Y/N)")
  #if yes, then compile data, and then remove incomplete data (NA)
  if (manual_input_1 == "Y"){
    for (i in 1:length(filelist)){
      if(i==1){
        alldata<-read.csv(filelist[i], header=TRUE)
      }else if (i>1){
        alldata<-rbind(alldata, read.table(filelist[i], header=TRUE, sep=','))
      }
    }
    are_there_na<-any(is.na(alldata))
    if (are_there_na==TRUE){
      alldata<-alldata[complete.cases(alldata),]
      readline(prompt="Incomplete data has been removed successfully.")
    }else{
      readline(prompt="No incomplete data detected")
    }
    alldata$country<-c(Country)
    write.csv(alldata, file='allDATA.csv')
  }else{
    #this else statement is if you choose not to remove NA data
    #the following readline sets up the ask of whether or not you want to be warned that data is incomplete
    manual_input_2<-readline(prompt = "Do you wish to be warned of missing data? (Y/N)")
    if (manual_input_2 == "Y"){
      for (i in 1:length(filelist)){
        if(i==1){
          alldata<-read.csv(filelist[i], header=TRUE)
        }else if (i>1){
          alldata<-rbind(alldata,read.table(filelist[i], header=TRUE, sep=','))
        }
      }
      are_there_na<-any(is.na(alldata))
      if(are_there_na==TRUE){
        readline(prompt="WARNING: Incomplete data has been detected, but not removed.")
      }else{
        readline(prompt="No incomplete data has been detected.")
      }
      alldata$country<-c(Country)
      write.csv(alldata,file="allDATA.csv")
    }else if (manual_input_2=="N"){
      #If you say no to both questions, the following produces a compiled file with NA values present
      for (i in 1:length(filelist)){
        if(i==1){
          alldata<-read.csv(filelist[i], header=TRUE)
        }else if (i>1){
          alldata<-rbind(alldata,read.table(filelist[i], header=TRUE, sep=','))
        }
      }
      alldata$country<-c(Country)
      write.csv(alldata,file="allDATA.csv")
    }
  }
}

Compile("/Users/chris_turlo/Desktop/Rproject/Rproject2022/countryX", "X")
Compile("/Users/chris_turlo/Desktop/Rproject/Rproject2022/countryY", "Y")

alldataX<-read.csv("/Users/chris_turlo/Desktop/Rproject/Rproject2022/countryX/allDATA.csv")
alldataY<-read.csv("/Users/chris_turlo/Desktop/RProject/Rproject2022/countryY/allDATA.csv")
alldata<-rbind(alldataX,alldataY)
write.csv(alldata, "/Users/chris_turlo/Desktop/Rproject/Rproject2022/ALLDATA.csv")


### BELOW IS WORKSPACE ###

#As of right now, country X and country Y have been transformed to csvs
#These csvs are now compiled and contain gender, age, markers 1-10, and country data

#NEED dayofYear column


#Goal 2: summarize individual country data
  #To determine if patient is positive: sum markers 1-10
    #if sum >=1; patient is infected
  #Determine earliest date in which individuals are infected in each country

#Which country (X/Y) did the disease outbreak likely begin
  #Determine which country has a case earlier than the other (can determine from compiled file)

#If country Y develops a vaccine for the disease, is it likely to work for Country X
  #compare microsatellite values across individual countries, look at Y, compare to X

#microsatellite analysis (10 markers) - airborne bacteria
  #if 1+ markers present, patient was infected
#each country is screening a large number of patients with symptoms
  #screening_NNN.txt > day, gender, microsatellite markers

#provide answers and supporting info for the two questions > provide code for future analyses

#converts data files into csv
#compile all data > all original 12 columns, plus country column and "dayofYear" column
#write function to summarize compiled data; #screens run, %patients infected, male v. female stats, age distribution)



#sum(x$age%in%(10:20)) >> i assume this goes somewhere down the line in analysis

#to work with all data:
provided_alldata<-read.csv("/Users/chris_turlo/Desktop/RProject/RProject2022/allData.csv", header=TRUE, sep=',')
  

##From rubric: (6 points)
#Converts .txt to .csv, and changes file extension - done
#Compiles the files - idea cleaner, need dayofYear column, but otherwise done
#Generate a summary graph

##Question 1 (answer question with reasonable rationale, graphical support) (4 points)
##Question 2 (answers question with reasonable rationale, graphical support) (4 points)
#uses all support functions created (2 points)
#well commented and efficient (4 points)

#files requested:
  #supportingFunctions.R > contain the assorted scripts to process data
    #convert all files to .csv
    #compile data, including country and dayofYear columns
    #user can choose to remove NAs in any columns, include but be warned of presence, or include and do not warn
    #write summary file: allData.csv
        #Number of screens run
        #Percent of patients screened that were infected
        #Male v. Female
        #Age Distribution

  #analysis.R > use source() to utilize the functions within supportingFunctions.R
    #compile data into a single .csv
    #process the data
    #provide graphical insight
    #have commented answers to these questions