# -*- coding: utf-8 -*-
"""
Created on Thu Sep 14 11:47:41 2017

@author: yzamriy
Goal:   Create UsaplData object containing a nested dictionary with
        data scraped from target pages
        This is a parent object for CompetitionList and RankingList objects

Input:  reference, string. Part of the url address for target page

Main methods:   1. get_col_names: returns a list of key names in the dictionary
                2. return_dict: returns nested dictionary with data

Requirements: Soup.py to get Beautiful Soup objects
"""
from Soup import *
import random

class UsaplData(object):
    def __init__(self, reference):
        '''
        Goal:    Initializes UsaplData object
        Details: Competition object has following attributes:
                        self.reference: string. Part of the url address for target page
                        self.data_dict: nested dictionary with data scraped from
                                        the target page: 
                                            Level 1 keys: text within a['href'] tag
                                            Level 2 keys -> text within 'th' tags
                                            Values -> text within 'td' tags
                        self.col_names: list with key names from the dictionary
        '''
        self.reference = reference
        self.data_dict = self.build_dict()
        self.col_names = self.get_col_names()

    def build_dict(self):
        """ 
        Goal:       Builds nested dictionary with data scraped from the target page
                    First, the data from the target page is processed with
                    Beautiful Soup and put into a soup objest
                    Then we extract the data within "tabledata" tag
                    The data itself is contained within 'tr' tags
                    Table headers between 'th' tags will be the keys
        Inputs:     none
        Returns:    nested dictionary  
        """
        data_dict = {}

        soup = getSoup(self.reference)
        soup_table = soup.find("table", class_="tabledata").find('tbody').find_all('tr')
        soup_colnames = soup.find("table", class_="tabledata").find('thead').find_all('th')

        for row in soup_table:
            row_name = row.find('a')['href']
            data_dict[row_name] = {}
            for cn, cv in zip(soup_colnames, row.find_all('td')):
                col_names = cn.get_text()
                col_value = cv.get_text().strip()
                data_dict[row_name][col_names] = col_value
    
        return data_dict

    def get_col_names(self):
        """ 
        Goal:       Return column names corresponding to keys in the dictionary
        Inputs:     none
        Returns:    list of key names 
        """
        lifter = random.choice(list(self.data_dict))
        col_names = list(self.data_dict[lifter].keys())
        # Create a name for the top level keys in the dictionary
        # that contain url reference
        col_names.insert(0, 'Link')
        return col_names               
                
    def return_dict(self):
        return self.data_dict

#test = UsaplData('competitions')