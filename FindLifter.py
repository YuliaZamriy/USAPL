# -*- coding: utf-8 -*-
"""
Created on Wed Nov  1 19:28:44 2017

@author: yzamriy
Goal:    Funtion to find lifters in the database and pull their entire comp history 

Input:   csv file with lifter name, state, weightclass, sex
    
Output:  one CSV file per lifter in ./CSV directory

Retruns: Nothing
"""

from RankingList import RankingList
from Lifter import Lifter
import string
import regex
import csv
from writetoCSV import *

def normalize(s):
    """ input: any string
        function: converts input to lower case and remove white space
        returns: normalized string
    """
    for p in string.punctuation:
        s = s.replace(p, '')
    return s.lower().strip()

def build_rank_dict(sex, wclass, state):
    """ input: strings corresponding to sex, weight class, state
        function: create a dictionary based on the inputs from
                  'Ranking' database on USAPL site
        returns: dictionary (key: lifters' references, values: lifters' names)
    """
    fed = 'IPF - Female' if sex == 'Female' else 'IPF - Male'
    div = 'Raw Open'
    exercise = 'Total' 
    year = 'All'
    order = 'Weight'
    par_list = [sex,div,fed,wclass,exercise,state,year,order]

    return RankingList(par_list).return_dict()

def readLifters(rawinputfile):
    """ input: .csv file with lifters to search
        funciton: convert input file to a nested dictionary
        returns: dictionary (keys: lifters' names, values: lifters' parameters)
    """
    lifters_dict = {}
    with open(rawinputfile, newline='') as rawinputfile:
        inputfile = csv.reader(rawinputfile)
        row_names = next(inputfile)
        for row in inputfile:
            lifters_dict[row[0]] = {key: value for key, value in zip(row_names, row)}
    return lifters_dict

def find_lifter(rawinputfile):
    """ input: .csv file with lifters to search
        funciton: take lifters from the input file converted to dictionary by 'readLifters'
                  and search for them in the ranking dictionary (from 'build_rank_dict')
                  and print searched name, matched USAPL name, and their USAPL reference
        returns: dictionary (keys: lifters' references, values: lifters' competition history)
    """
    lifters_dict = readLifters(rawinputfile)
    lifters_ref_dict = {}
    for lifter in lifters_dict:
        regex_name = '('+normalize(lifter)+'){e<=2}'
        rank_dict = build_rank_dict(lifters_dict[lifter]['sex'], lifters_dict[lifter]['wclass'], lifters_dict[lifter]['state'])
        for ref in rank_dict:
            usapl_name = normalize(rank_dict[ref]['Lifter'])
            if regex.search(regex_name, usapl_name):
                 lifters_ref_dict[ref] = {'Input Name': lifter, 'USAPL Name': rank_dict[ref]['Lifter']}
                 print(lifter, "USAPL Name:", rank_dict[ref]['Lifter'], "USAPL ref#:", ref)
    return lifters_ref_dict

def lifterCSV(rawinputfile):
    """ input: .csv file with lifters to search
        funciton: take the returned dictionary from 'find_lifter' and print it to csv file
        returns: nothing
    """
    lifters_ref_dict = find_lifter(rawinputfile)
    for ref in lifters_ref_dict:
        lifter = Lifter(ref)
        writetoCSV_lev2(lifter.return_dict(),lifter.get_col_names(), lifter.build_filename())

rawinputfile = 'LifterSearch.csv'
lifterCSV(rawinputfile)
#print(find_lifter(rawinputfile))

