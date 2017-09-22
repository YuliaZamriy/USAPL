# -*- coding: utf-8 -*-
"""
Created on Mon Sep 18 17:27:10 2017

@author: yzamriy
Goal:           Create Roster object
                Containing history of lifters in the roster subset (based 
                on weight class and division)

Input:          par_list: list of parameters for the selected lifters
                rawinputfile: csv file with the roster
                weightclass: weightclass of interest
                division: division of interest

Main methods:   return_dict: returns lifter history dictionary
                get_col_names: returns column names corresponding to keys in the dictionary 
                build_filename: eturns filename for the csv file containing the dictionary

Requirements:   RankingList.py, Lifter.py
"""

from RankingList import RankingList
from Lifter import Lifter
import csv, random

# Function to read in the full roster file from the csv to a nested dictionary
def readRoster(rawinputfile):
    """
    Roster is provided via link to google sheets file
    It has been saved in the csv format in the working directory
    Returns: nested dictionary
    """
    roster_dict = {}
    with open(rawinputfile, newline='') as rawinputfile:
        roster = csv.reader(rawinputfile)
        row_names = next(roster)
        for row in roster:
            roster_dict[row[0]] = {key: value for key, value in zip(row_names, row)}
    return roster_dict

class Roster(object):
    def __init__(self, par_list, rawinputfile, weightclass, division):
        '''
        Goal:    Initializes Roster object
        Details: Competition object has following attributes:
                        self.par_list: list of parameters for the selected lifters
                                        must match weightclass/division
                                        it will be used to pull lifter's history
                                        based on their reference link retreived
                                        from RankingList object
                        self.rawinputfile: csv file with the roster
                        self.weightclass: weightclass of interest
                                            since roster compiled outside 
                                            USAPL website, its format doesn't
                                            match USAPL parameters. Hence, it's
                                            inputed separately from par_list
                        self.division: division of interest
                                            since roster compiled outside 
                                            USAPL website, its format doesn't
                                            match USAPL parameters. Hence, it's
                                            inputed separately from par_list
        '''
        self.par_list = par_list
        self.rawinputfile = rawinputfile
        self.weightclass = weightclass
        self.division = division
        self.comp_history_dict = self.get_competitor_history()

    def build_competitor_dict(self):
        ''' 
        Goal: Subset roster dictionary to lifters within weightclass/division
                of inteterst. Then retreive lifters' url link from RankingList
        Returns: Dictionary with lifters' names and links
        '''    
        roster = readRoster(self.rawinputfile)
        competitor_dict = {}
        for lifter in roster:
            if roster[lifter]['WtCls'] == self.weightclass and roster[lifter]['Div 1'] == self.division:
                lifter_ref = RankingList(self.par_list).get_lifter_ref(lifter)
                competitor_dict[lifter] = lifter_ref
        return competitor_dict

    def get_competitor_history(self):
        ''' 
        Goal: Pull competition history for every lifter in the roster subset
        Returns: Lifters history, nested dicitonary
        '''    
        competitor_dict = self.build_competitor_dict()
        for lifter in list(competitor_dict.keys()):
            try:
                hist = Lifter(competitor_dict[lifter]).build_lifter_dict()
            except:
                print(lifter, "not found")
                del competitor_dict[lifter]
            else:
                competitor_dict[lifter] = hist
        return competitor_dict

    def return_dict(self):
        return self.comp_history_dict        

    def get_col_names(self):
        """ 
        Goal:       Return column names corresponding to keys in the dictionary
        Returns:    list of key names 
        """
        col_names = ['Name','Link']
        hist_dict = self.return_dict()
        lifter = random.choice(list(hist_dict))
        comp = random.choice(list(hist_dict[lifter]))
        for col in hist_dict[lifter][comp]:
            col_names.append(col)
        return col_names               
                
    def build_filename(self):
        '''
        Returns: string, filename for the csv file containing the dictionary
        '''
        return "roster_history_" + self.weightclass + self.division +".csv"

