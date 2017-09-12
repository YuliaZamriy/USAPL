# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 15:59:45 2017

@author: yzamriy

Goal:   Scrape the data for a specified competition, put it in a nested 
        dictionary and write it out into a .csv file
        
Input:  Competition name, string. For example, "Raw Nationals 2016"        

"""

import random
import os, csv
from CompetitionList import CompetitionList

class Competition(object):
    def __init__(self, comp_name):
        '''
        Goal:    Initializes Competition object
        Details: Competition object has two attributes:
                        self.report_type = 'competitions'
                        self.comp_name: string, name of the competition
        Returns: Nothing
        '''
        self.report_type = 'competitions'
        self.comp_name = comp_name

    def get_comp_ref(self):
        '''
        Goal: get competition reference link to build Soup object
        Returns: competition reference, string
        '''
        usapl_comps = CompetitionList().build_comp_dict()
        self.comp_ref = usapl_comps[self.comp_name]["link"]
        return self.comp_ref
        
    def get_soup(self):
        '''
        Goal: get Soup object for the competition
        Returns: Soup object
        '''
        comp_ref = self.get_comp_ref()
        self.comp_soup = Soup(comp_ref).get_soup()
        return self.comp_soup

    def get_col_names(self):
        ''' 
        Goal: Get names for the columns of competition results table
              from Soup object
        Returns: Competition table column names, list
        '''    
        comp_soup = self.get_soup()
        comp_soup_colnames = comp_soup.find("table", id="competition_view_results").find('thead').find_all('th')
        
        # First column in the scraped table doesn't have a name, but it 
        # contains lister weight class data
        self.col_names = ['Weightclass']
        for cl in comp_soup_colnames:
            # Each lift covers 3 columns (one for each attmept)
            # Raw scraped table has three columns but only one name
            # We create column names for each attempt column
            # Squat1, Squat2, Squat3, Bench Press1, etc.
            if cl.get_text() in ['Squat','Bench press','Deadlift']:
                for i in '123':
                    self.col_names.append(cl.get_text()+i)
            else:
               self.col_names.append(cl.get_text()) 
        return self.col_names
    
    def get_comp_data(self):
        ''' 
        Goal: Get competition results from Soup object and put them 
                into a nested dictionary
        Returns: Competition results, nested dictionary
        '''    
        comp_soup = self.get_soup()
        comp_soup_table = comp_soup.find("table", id="competition_view_results").find('tbody').find_all('tr')  
        col_names = self.get_col_names()
        
        self.comp_table = {}
        for comp in comp_soup_table:
            if comp.find('a'):
                lifter_name = comp.find('a').get_text()
                self.comp_table[lifter_name] = {}
                for cl, cv in zip(col_names, comp.find_all('td')):
                    col_value = cv.get_text().strip()
                    self.comp_table[lifter_name][cl] = col_value
                    self.comp_table[lifter_name]['Link'] = comp.find('a')["href"]
        
        return self.comp_table
                
    def write_db(self, db_dir):
        ''' 
        Goal: Writes the nested dictionary containing competition results
              into a csv file
        Input: output directory, string
        Ouput: csv file with results in the output directory
        Returns: Nothing
        '''
    
        os.chdir(db_dir)
        filename = self.comp_name+".csv"
        comp_table = self.get_comp_data()
        
        with open(filename, "w") as toWrite:
            writer = csv.writer(toWrite, delimiter=",")
            
            # get column names from the values of a random key (lifter name)
            writer.writerow(comp_table[random.choice(list(comp_table))].keys())
            for lifter in comp_table:
                row = []
                for col in comp_table[lifter]:
                    row.append(comp_table[lifter][col])
                writer.writerow(row)
    
# Specify directory for the output csv files
db_dir = "./CSV"

#x = Competition("2017 Northeast Regional Championships")
#x.write_db(db_dir)