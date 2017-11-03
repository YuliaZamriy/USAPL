# -*- coding: utf-8 -*-
"""
Created on Mon Aug 28 14:55:08 2017

@author: yzamriy

Goal:           Create Lifter object
                Containing lifter's history

Input:          Lifter url reference, string             

Main methods:   return_dict: returns lifter history dictionary

Requirements:   Soup.py to get Beautiful Soup objects
"""

from Soup import *
import random

class Lifter(object):
    def __init__(self, reference):
        '''
        Goal:    Initializes Lifter object
        Details: Competition object has following attributes:
                        self.reference: url reference for the
                        self.lifter_dict: nested dictionary with data scraped from
                                            the lifter specific page: 
                                            Level 1 keys: text within 'a[href] tag
                                            Level 2 keys -> text within 'th' tags
                                            Values -> text within 'td' tags
        '''
        self.reference = reference
        self.lifter_dict = self.build_lifter_dict()

    def build_col_names(self):
        ''' 
        Goal: Get names for the columns of lifter history table
              from Soup object
        Returns: Lifter table column names, list
        '''    
        soup = getSoup(self.reference)
        soup_colnames = soup.find("table", id="competition_view_results").find('thead').find_all('th')
        
        col_names = ['Date']
        for cl in soup_colnames:
            if cl.get_text() in ['Squat','Bench press','Deadlift']:
                for i in '123':
                    col_names.append(cl.get_text()+i)
            elif cl.get_text() == 'Division':
                col_names.append(cl.get_text())
                col_names.append('Weightclass')
            else:
               col_names.append(cl.get_text()) 
        return col_names

    def get_lifter_yob(self):
        '''
        Returns: competition name 
        '''
        soup = getSoup(self.reference)
        if (soup.find("table").find('tbody').find('td')):
            yob = soup.find("table").find('tbody').find('td').get_text()
        else:
            yob = '0000'
        
        return yob

    def build_lifter_dict(self):
        ''' 
        Goal: Get lifter history from Soup object and put them 
                into a nested dictionary
        Returns: Lifter, nested dictionary
        '''    
        soup = getSoup(self.reference)
        soup_table = soup.find("table", id="competition_view_results").find('tbody').find_all('tr')
        # name row starts with "Lifter - "
        lifter_name = soup.find("h2").get_text().strip()[9:]
        yob = self.get_lifter_yob()
        col_names = self.build_col_names()
        
        lifter_dict = {}
        for lifter in soup_table:
            comp_ref = lifter.find('a')['href']
            lifter_dict[comp_ref] = {'Name': lifter_name, 'YOB': yob}
            for col_name, cv in zip(col_names, lifter.find_all('td')):
                col_value = cv.get_text().strip()
                lifter_dict[comp_ref][col_name] = col_value
       
        return lifter_dict
    
    def return_dict(self):
        return self.lifter_dict

    def get_lifter_name(self):
        '''
        Returns: competition name 
        '''
        comp = random.choice(list(self.lifter_dict))
        return self.lifter_dict[comp]['Name']

    def get_col_names(self):
        """ 
        Goal:       Return column names corresponding to keys in the dictionary
        Returns:    list of key names 
        """
        comp = random.choice(list(self.lifter_dict))
        col_names = list(self.lifter_dict[comp].keys())
        # Create a name for the top level keys in the dictionary
        # that contain lifter's name
        col_names.insert(0, 'Link')
        return col_names

    def build_filename(self):
        '''
        Returns: string, filename for the csv file containing the dictionary
        '''
        return self.get_lifter_name()+"_comp_history.csv"

#print(Lifter('lifters-view?id=23702').get_lifter_yob())