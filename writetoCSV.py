# -*- coding: utf-8 -*-
"""
Created on Wed Sep 20 11:50:59 2017

@author: yzamriy

Goal:    Funtion to write out nested dictionaries to csv files 

Input:   Nested dicitonary, column names for the csv file, filename
    
Output:  CSV files in ./CSV directory

Retruns: Nothing

"""
from Roster import Roster
from Competition import Competition
from RankingList import RankingList
import os, csv

def writetoCSV_lev3(data_dict, col_names, filename):
    ''' 
    Goal: Writes 3-level nested dictionary into a csv file
    Input: 3-level nested dictionary, column names, output file name
    Ouput: csv file with results in the output directory
    Returns: Nothing
    '''
    home_dir = os.getcwd()
    # subdirectory for csv output
    db_dir = "./CSV"
    os.chdir(db_dir)
    
    with open(filename, "w", newline = '', encoding = 'utf-8') as toWrite:
        writer = csv.writer(toWrite, delimiter=",")
        writer.writerow(col_names)
        for level1 in data_dict:
            row = []
            for level2 in data_dict[level1]:
                row = [level1]
                row.append(level2)
                for level3 in data_dict[level1][level2]:
                    row.append(data_dict[level1][level2][level3])
                writer.writerow(row)
    os.chdir(home_dir)

def writetoCSV_lev2(data_dict, col_names, filename):
    ''' 
    Goal: Writes 2-level nested dictionary into a csv file
    Input: 2-level nested dictionary, column names, output file name
    Ouput: csv file with results in the output directory
    Returns: Nothing
    '''
    home_dir = os.getcwd()
    # subdirectory for csv output
    db_dir = "./CSV"
    os.chdir(db_dir)

    with open(filename, "w", newline = '', encoding = 'utf-8') as toWrite:
        writer = csv.writer(toWrite, delimiter=",")
        writer.writerow(col_names)
        for ref in data_dict:
            row = [ref]
            for col in data_dict[ref]:
                row.append(data_dict[ref][col])
            writer.writerow(row)

    os.chdir(home_dir)

# Enter desired parameters
# All possible values are stored in the file called "usapl_parameters.txt"
#sex = 'Female' # Possible Values: 'Male' and 'Female'
#div = 'Raw Open' # Possible Values: 'All', 'Raw Open', etc.
#fed = 'IPF - Female' # Possible Values: 'IPF - Female' and 'IPF - Male'
#wclass = '-84' # Possible Values: '-84', '84+', etc.
#exercise = 'Total' # Possible Values: 'Total', 'Squat', 'Bench press', 'Deadlift'
#state = 'All' # Possible Values: 'All', 'Nationals', 'Regionals', 'New York'
#year = 'All' # Possible Values: 'All', '2017', etc.
#order = 'Weight' # Possible Values: 'Points' and 'Weight'
#
#par_list = [sex,div,fed,wclass,exercise,state,year,order]

# Name of the roster file
#rawinputfile = '2017 Raw Nationals Roster.csv'
# Weightclass and division of interest (based on values in the row roster file)
#weightclass = 'F-84'
#division = 'FR-O'

# create Roster object
#roster = Roster(par_list, rawinputfile, weightclass, division)
#writetoCSV_lev3(roster.return_dict(),roster.get_col_names(), roster.build_filename())

# create RankingList object
#rank = RankingList(par_list)
#writetoCSV_lev2(rank.return_dict(),rank.get_col_names(), rank.build_filename())

#lifter = Lifter('lifters-view?id=1768')
#writetoCSV_lev2(lifter.return_dict(),lifter.get_col_names(), lifter.build_filename())

# create Competition object based on competition URL reference
#print(CompetitionList(substring = "Raw Nationals").get_comp_names())
#raw14 = Competition('competitions-view?id=860')
#raw15 = Competition('competitions-view?id=992')
#raw16 = Competition('competitions-view?id=1354')
#writetoCSV_lev2(raw14.return_dict(),raw14.get_col_names(), raw14.build_filename())
#writetoCSV_lev2(raw15.return_dict(),raw15.get_col_names(), raw15.build_filename())
#writetoCSV_lev2(raw16.return_dict(),raw16.get_col_names(), raw16.build_filename())
#writetoCSV_lev3(raw14.return_hist_dict(),raw14.get_hist_col_names(), raw14.build_hist_filename())
#writetoCSV_lev3(raw15.return_hist_dict(),raw15.get_hist_col_names(), raw15.build_hist_filename())
#writetoCSV_lev3(raw16.return_hist_dict(),raw16.get_hist_col_names(), raw16.build_hist_filename())

#raw17 = Competition('competitions-view?id=1776')
#writetoCSV_lev2(raw17.return_dict(),raw17.get_col_names(), raw17.build_filename())
#writetoCSV_lev3(raw17.return_hist_dict(), raw17.get_hist_col_names(), raw17.build_hist_filename())

#test_comp = Competition('competitions-view?id=1774')
#writetoCSV_lev3(test_comp.return_hist_dict(), test_comp.get_hist_col_names(), test_comp.build_hist_filename())
