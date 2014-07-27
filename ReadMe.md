Human Activity Recognition Using Smartphones Dataset - Read Me
========================================================

This readme file describes the various aspects and components of the course project (Human Activity Recognition Using Smartphones).  The ultimate objective of this project is to process the set of input files and create a tiny data set representing the average of each mean and std column for each activity and participant

--------------------------------------------------------

### What's Included?
This package includes 4 main files used to understand and process the raw data:

1.ReadMe.md - this file contains an overview of all components submitted as part of the course project
2.CodeBook.md - this file describes the various aspects of the "tidy" data set created as an output of the R script
3.run_analysis.R - this file is an R script which takes utilizes the various input files in order to create the tidy dataset output.
4.tidy_data.txt - this file contains the output tidy data set generated from the run_analysis.R file 

Additionally, there are a handful of raw data files which are processed to create the tidy dataset

5. X_test.txt - raw data for 561 different measurements for the various subjects 
6. Y_test.txt - raw data for the activities associated to each of the measurements
7. subject_test.txt - contains the data describing the subjects associated to the measurments
8. X_train.txt - raw data for 561 different measurements for the various subjects
9. Y_train.txt - raw data for the activities associated to each of the measurements
10. subject_train.txt - contains the data describing the subjects associated to the measurments
11. activity_labels.txt - contains the description for the numeric codes in the Y_test and Y_train files


### Overview of Raw Data
The raw data describes experiments that have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data (X_train , Y_train, subject_train) and 30% the test data (X_test , Y_test, subject_test). 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details.

### Overview of run_analysis.R

The run_analysis.R file is the main script that's executed in order to process the raw data files.  The script ultimately takes the raw data files, joins and cleans the files, and creates a tidy data set where each row represents the average of the various Mean and Standard Deviation measurements for each particpant for each activity

#### What does the script do?

The run_analysis.R file begins by importing the 6 txt files mentioned above (x_test, y_text, subject_test, x_train, y_train, subject_train).

Once these files are imported, a 7th file which contains the 561 column headers is imported and transposed into a dataframe which is written out to a temporary CSV file.  This list of column headers is then read back into the script and each header is applied to the X_train.txt and X_test.txt data files.

The script then takes the train and test data sets, the two activity files and two participant files and binds appropriately.  At this point, there are three main dataframes: 

1. Contains the merged measurement data (561 measurements)
2. Contains the merged participant data
3. Contains the merged activity data

Since the activity details in the raw data are numeric codes, the script utilizes the activity_labels.txt file and replaces the codes with the proper descriptions.

The next main task of the script is to start creating a smaller data frame that only has mean and standard deviation measurements.  The script takes the activity data and binds to the participant data.  The script then loops through the measurement data and identifies the rows that have either "-mean()" or "-std()" in the column names.  

*If a column has an alternate naming convention of mean or std deviation and does not contain the exact text "-mean()" or "-std()", the column is not included in the final data set.*

The next step in the script take the full data set (activity + participant + mean / std dev measurements) and computes the average of each measurement column (66 columns).  The calculation is the grouped by particpant and activity (i.e. each particpant has 66 measurements for each activity).

At this point, a tidy data set is created and is output to a txt file.

#### Why is the data file tidy?
Based on the definition of "tidy data" conveyed in Jeff Leek's lecture, the ouput conforms to the defintion:
1. Each variable measured should be in one column (this holds true in the tidy_data.txt output)
2. Each differnet observation should be in a different row (this holds true in the tidy_data.txt output)
3. There should be one table for each kind of variable (this holds true in the tidy_data.txt output - there is only one table)
4. If you have multiple tables, they should be linked through a column (this holds true in the tidy_data.txt output - there is only one table)

In addition to the 4 rules, there were also 3 suggested tips from Jeff Leeks lecture which were also adhered to:
1. include a row at the top of each file with variable names
2. make variable names human readable 
3. save data in one file

The naming convention used in the table used the following rules:
1. use camecase
2. write out frequency or time where appropriate
3. refer to mean as Mean and standar deviation as StdDev
4. Spell out magnitude and accelerator




