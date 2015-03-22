# Getting And Cleaning Data
### by Diana Cruz

##Final Project
This repository contains:
* run_analysis.R : main script to perform analysis as stated by the course
* TidyData.txt : output from the run_analysis.R script
* CodeBook.md: Information about the transformations on the raw data set to obtain the TidyData.txt
* Data folder, which contains the
  * getdata_projectfiles_UCI HAR Dataset.zip, file downloaded from the Coursera webpage, and
  * UCI HAR Dataset, directory obtained by unzipping the last one, which is the raw data, input for run_analysis.R
  
## run_analysis.R
### How does it work?
After you downloaded and unzipped the repository, you only have to change the first line of the code in order to set the working directory.
E. g., on linux, you could set "~/Downloads/GettingAndCleaningData-master/".

Then, open a terminal and move to the GettingAndCleaningData-master folder. Run:

Rscript run_analysis.R


That's it! The script will automatically look for the raw data that must be inside the Data/UCI HAR Dataset/ directory and you'll get the TidyData.txt file as final output.
