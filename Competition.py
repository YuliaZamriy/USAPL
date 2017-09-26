# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 15:59:45 2017

@author: yzamriy

Goal:           Create Competition object
                Containing all details about the competition

Input:          Competition url reference, string             

Main methods: 
    
    1. return_dict: returns the competition dictionary
    2. get_lifter_ref: returns lifter url reference based on specified name
    3. get_comp_name: returns competition name
    4. build_filename: returns filename for the csv file containing the dictionary
    5. get_col_names: returns column names corresponding to keys in the dictionary
    6. get_comp_lifter_history: get full history of competitions for each lifter
    7. prior_history: remove records from the history dictionary that happened
                    after the competition
    8. build_hist_filename: returns filename for the csv file containing history dictionary
    9. return_hist_dict: returns the competition history dictionary
    10. get_hist_col_names: returns column names corresponding to keys in history dictionary

Requirements:   CompetitionList.py to get Beautiful Soup objects
                Lifter.py to get lifter history
"""

import random
import datetime 
from CompetitionList import CompetitionList
from Lifter import Lifter

class Competition(object):
    def __init__(self, reference):
        '''
        Goal:    Initializes Competition object
        Details: Competition object has following attributes:
                        self.reference: url reference for the competition
                        self.comp_dict: nested dictionary with data scraped from
                                        the competition specific page: 
                                            Level 1 keys: text within 'a' tag
                                            Level 2 keys -> text within 'th' tags
                                            Values -> text within 'td' tags
        '''
        self.reference = reference
        self.comp_dict = self.build_comp_dict()
        
    def build_col_names(self):
        ''' 
        Goal: Get names for the columns of competition results table
              from Soup object
        Returns: Competition table column names, list
        '''    
        soup = getSoup(self.reference)
        soup_colnames = soup.find("table", id="competition_view_results").find('thead').find_all('th')
        
        # First column in the scraped table doesn't have a name, but it 
        # contains lister weight class data
        col_names = ['Weightclass']
        for cn in soup_colnames:
            # Each lift covers 3 columns (one for each attmept)
            # Raw scraped table has three columns but only one name
            # We create column names for each attempt column
            # Squat1, Squat2, Squat3, Bench Press1, etc.
            if cn.get_text() in ['Squat','Bench press','Deadlift']:
                for i in '123':
                    col_names.append(cn.get_text()+i)
            else:
               col_names.append(cn.get_text()) 
        return col_names
    
    def build_comp_dict(self):
        ''' 
        Goal:       Builds nested dictionary with data scraped from the target 
                    competition page
                    First, the data from the target page is processed with
                    Beautiful Soup and put into a soup objest
                    Then we extract the data within "competition_view_results" tag
                    The data itself is contained within 'tr' tags
                    Table headers between 'th' tags will be the keys
        Returns: Competition results, nested dictionary
        '''    
        comp_dict = {}
        
        soup = getSoup(self.reference)
        soup_table = soup.find("table", id="competition_view_results").find('tbody').find_all('tr')  
        col_names = self.build_col_names()
        
        for comp in soup_table:
            if comp.find('a'):
                lifter_name = comp.find('a').get_text()
                comp_dict[lifter_name] = {}
                for cl, cv in zip(col_names, comp.find_all('td')):
                    col_value = cv.get_text().strip()
                    comp_dict[lifter_name][cl] = col_value
                    comp_dict[lifter_name]['Link'] = comp.find('a')["href"]
        
        return comp_dict

    def return_dict(self):
        return self.comp_dict

    def get_lifter_ref(self, lifter_name):
        '''
        Returns: lifter url reference based on specified name
        '''
        return self.comp_dict[lifter_name]['Link']
    
    def get_comp_name(self):
        '''
        Returns: competition name 
        '''
        return CompetitionList().get_comp_name(self.reference)

    def build_filename(self):
        '''
        Returns: string, filename for the csv file containing the dictionary
        '''
        return self.get_comp_name()+".csv"

    def get_col_names(self):
        """ 
        Goal:       Return column names corresponding to keys in the dictionary
        Returns:    list of key names 
        """
        lifter = random.choice(list(self.comp_dict))
        col_names = list(self.comp_dict[lifter].keys())
        # Create a name for the top level keys in the dictionary
        # that contain lifter's name
        col_names.insert(0, 'Name')

    def get_comp_lifter_history(self):
        """ 
        Goal:       get full history of competitions for each lifter
        Returns:    nested dictionary
        """
        lifters_history = {}
        for lifter in self.comp_dict:
            lifter_ref = self.get_lifter_ref(lifter)
            lifters_history[lifter] = Lifter(lifter_ref).return_dict()
        return lifters_history

    def prior_history(self):
        """ 
        Goal:       remove records from the lifter history dictionary 
                    that happened after the competition
        Returns:    nested dictionary
        """
        comp_date = CompetitionList().get_comp_date(self.reference)
        comp_date = datetime.datetime.strptime(comp_date, '%m/%d/%Y') - datetime.timedelta(days=7)
        lifters_history = self.get_comp_lifter_history()
        lifters_history_prior = {}
        for lifter in lifters_history:
            lifters_history_prior[lifter] = {}
            for comp in lifters_history[lifter]:
                comp_date_hist = datetime.datetime.strptime(lifters_history[lifter][comp]['Date'], '%m/%d/%Y')
                if comp_date_hist < comp_date:
                    lifters_history_prior[lifter][comp] = lifters_history[lifter][comp]
        return lifters_history_prior

    def build_hist_filename(self):
        '''
        Returns: string, filename for the csv file containing history dictionary
        '''
        return self.get_comp_name()+"_lifter_history.csv"

    def return_hist_dict(self):
        return self.prior_history()

    def get_hist_col_names(self):
        """ 
        Goal:       Return column names corresponding to keys in history dictionary
        Returns:    list of key names 
        """
        # Top level in the dictionary is lifter's name
        # Next level is competition reference
        col_names = ['Name','Link']
        hist_dict = self.prior_history()
        # To extract column names we need a non-empty dictionary
        # A lot of lifters compete for the first time, hence,
        # their history is empty
        # we'll keep looking for a lifter with history with a while loop
        while True:
            lifter = random.choice(list(hist_dict))
            if len(hist_dict[lifter]) > 0:
                comp = random.choice(list(hist_dict[lifter]))
                col_names.extend(list(hist_dict[lifter][comp].keys()))
                return col_names  
            print("first comp for", lifter)
                          
# test = Competition('competitions-view?id=1622')
