# GCD_course_project
##My attempt at the course project for the class "Getting and Cleaning Data"

Raw data should be saved in "/sourceData/". Executing the script will create a file in the working directory called allData.csv, which contains all of the test and training data. The subset of mean/std values is taken from allData and stored as subset.mean.std. subset.mean.std is further subsetted by subject and activity to take the mean for each column. These are combined and written to all.avgs.csv in the working directory
