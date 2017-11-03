# USAPL Database Analysis

## USAPL Database overview

### What is USAPL? 

USA Powerlifting is one of the major powerlifting federations in the US. It is part of IPF (International Powerlifting Federation).
There are two main types of types of competitions within USAPL: raw and equipped.
USAPL maintains an online database with all the meet (competitions) [results](http://usapl.liftingdatabase.com) .
It is updated on the ongoing basis. However, some of the old competitions (before 2014) don't have complete records.

### USAPL Database structure

All possible parameters within the database are listed in "usapl_parameters.txt"
For this analysis, we are going to focus on the Raw Division.

### What is USAPL competition structure? 

Each lifter competes within their weight class. 
In the full meet, each lifter performs three attempts for each of the main lifts: **Squat**, **Bench** **Press**, **Deadlift**.
Best attempt is selected and summed into **Total**.
To compare lifters across weight classes, Wilks Score (**Points**) is calculated. 

### What is USAPL Raw National competition?

It is conducted once a year in October. Lifters need to qualify by competing in USAPL-sanctioned meet

## Extracting the data from USAPL Database

### Parameters.py

This file contains the code to pull USAPL parameters and put them in a nested dictionary [source](http://usapl.liftingdatabase.com/ranking)
First layer of the dictionary contains the following keys:
Sex, Division, Weightclass, Exercise, State, Year, Order by
Second layer exists only for Weightclass. The keys are
IPF - Female; IPF - Male; USAPL Nationals - Female; USAPL Nationals - Male
The last two are old weight classes
The output is also printed into a .txt file "usapl_parameters.txt"
The goal is to use this dictionary to pull specific data drom the database.

### Soup.py

This file contains the function code to create beautiful soup objects based on specified url references

### UsaplData.py

This file contains the code to initialize parent UsaplData object 

### RankingList.py

This file contains the code to initialize and create RankingList object (parent = UsaplData) that contains lifters within specified ranking criteria.

### CompetitionList.py

This file contains the code to initialize and create CompetitionList object (parent = UsaplData) that contains names for all the competitons in the database as of current date.
It requires "Soup.py" to be saved in the same directory.
The names are printed into a txt file "usapl_comps_date.txt"
If the user of the program wants only a specific set of competitions, they have options:
"level" is '' by default. If the user wants national competition, they should set level = 'NS'. For regional it is 'RG'
'sub' is '' by default. If the user wants all the competitions that contain 'Raw' or '2017' in the name, then they should set it so.
Competition names are not strictly regulated, hence, the user might need to spend some time figuring this out.

### Competition.py

This file contains the code to initalize and create Competition object that extracts the data for a specific competition.
It requires "CompetitionList.py" to be saved in the same directory.
The user also should create a sub-directory 'CSV' where all the output file would be saved
The output file is csv that can be read in for analysis.

### Lifter.py

This file contains the code to initalize and create Lifter object that extracts historic data for a specific lifter.

### writetoCSV.py

code to created instances of objects and write them out to csv files.

### FindLifter.py

code to find lifters in the database and output each lifter's history to a csv file
requires input file LifterSearch.csv (folder Input files)
the template for the input file is int LifterSearchTemplate (folder Input files)




