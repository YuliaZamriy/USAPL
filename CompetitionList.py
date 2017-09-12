# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 14:48:34 2017

@author: yzamriy

Goal:   Create object CompetitionList that contains the list of all 
        available USAPL competitions
        1. Scrape the names of all the available competitions from USAPL site
        2. Put competition names into a nested dictionary for access by other
        classes
        
Inputs: Optional:   'level' is 'NS' for national and 'RG' for regional
                    'sub' any substring within the name of the competition.
                    For example, 'Raw' or 'High School'

Requirements: Soup.py to get Beautiful Soup objects
"""

from Soup import Soup
import sys
import datetime


class CompetitionList(object):
    def __init__(self):
        '''
        Goal:       Initializes CompetitionList object
        Details:    Soup object has one constant attribute:
                        self.report_type = 'competitions'
        Returns:    Nothing   
        '''
        self.report_type = 'competitions'

    def build_comp_dict(self):
        ''' 
        Goal:    Build nested dictionary with
                     keys => competition names,
                     values => competition details (time, sanction # etc.)
        Returns:    List of available competitions with details, nested dictionary   
        '''    
        comp_soup = Soup(self.report_type).get_soup()
        comp_soup_colnames = comp_soup.find("table", class_="tabledata").find('thead').find_all('th')
        comp_soup_table = comp_soup.find("table", class_="tabledata").find('tbody').find_all('tr')
        
        self.usapl_comps = {}
        for comp in comp_soup_table:
            comp_name = comp.find('a').get_text().strip()
            self.usapl_comps[comp_name] = {}
            for cl, cv in zip(comp_soup_colnames, comp.find_all('td')):
                col_names = cl.get_text()
                col_value = cv.get_text().strip()
                self.usapl_comps[comp_name][col_names] = col_value
            self.usapl_comps[comp_name]["link"] = comp.find('a')["href"]
       
        return self.usapl_comps 

    def get_comp_names(self, level = '', sub = ''):
        ''' 
        Goal:    Get the list of competition names satisfying input criteria
        Input:   Optional:
                     'level': Competition level (National, Regional etc.), string
                     'sub':   Substring in the required competition name, string
        Returns:    Competition names, list   
        '''    
        comp_dict = self.build_comp_dict()
        self.comp_names = []
        for comp in comp_dict:
            if comp_dict[comp]['Sanction #'].find(level) >= 0 and comp_dict[comp]['Name'].find(sub) >= 0:
                self.comp_names.append(comp_dict[comp]['Name'])
        return self.comp_names

    def comp_names_to_txt(self, level = '', sub = ''):
        ''' 
        Goal:    Print the list of competition names satisfying input criteria
        Input:   Optional:
                     'level': Competition level (National, Regional etc.), string
                     'sub':   Substring in the required competition name, string
        Output:  .txt file with all the names in the same directory
        Returns:  Nothing   
        '''    
        pull_date = datetime.datetime.today().strftime("%m%d%Y")
        filename = "usapl_comps_"+level+sub+"_"+pull_date+".txt"
        usapl_comps = self.get_comp_names(level, sub)
        
        orig_stdout = sys.stdout
        file = open(filename, 'w')
        sys.stdout = file
        
        if level != '':
            print('Sanction:', level, sub)
            print('-'*20)
        for i in usapl_comps:
            print(i.encode("utf-8"))
                
        file.close()
        sys.stdout = orig_stdout

#r = CompetitionList()
#r.comp_names_to_txt(level = '', sub = '')
