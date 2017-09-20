# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 14:48:34 2017

@author: yzamriy

Goal:   Create object CompetitionList that contains a dictionary with all 
        available USAPL competitions as keys
        It inherets all attributes and methods from UsaplData object
        
Inputs (Optional):   
        'level' is 'NS' for national and 'RG' for regional
        'sub' any substring within the name of the competition.
        For example, 'Raw' or 'High School'

Main methods: 1. get_comp_names: creates a dictionary with 
                 key = competition url reference
                 value = competition name
              2. comp_names_to_txt: prints the output dictionary from
                 get_comp_names to a .txt file
              3. get_comp_ref: based on competition name, return its url reference
              4. get_comp_date: based on competition reference, return 
                 competition date
              4. get_comp_name: based on competition reference, return 
                 competition name
    
Requirements: UsaplData.py to get UsaplData object
"""

from UsaplData import UsaplData
import sys

class CompetitionList(UsaplData):
    def __init__(self, level = '', substring = ''):
        '''
        Goal:       Initializes CompetitionList object
        Details:    CompetitionList object has following attributes:
                    inherited:
                        self.data_dict: nested dictionary with data
                        self.col_names: list with key names from the dictionary
                    own:
                        self.reference: string. Part of the url address for target page
                        self.level: input string, indicated competition level
                        self.substring: input string, used to subset comptitions
                        self.comp_names: nested dictionary containing 
                                         competition names and url references
        '''
        self.reference = 'competitions'
        UsaplData.__init__(self, self.reference)
        self.level = level
        self.substring = substring
        self.comp_names = self.get_comp_names()

    def get_comp_names(self):
        ''' 
        Goal:    Get the list of competition names satisfying input criteria
                 based on self.level and self.substring values
        Returns: nexted dictionary with a subset of competition names
        '''    
        comp_names = {}
        for comp in self.data_dict:
            if self.data_dict[comp]['Sanction #'].find(self.level) >= 0 and self.data_dict[comp]['Name'].find(self.substring) >= 0:
                comp_names[comp] = self.data_dict[comp]['Name']
        return comp_names

    def comp_names_to_txt(self):
        ''' 
        Goal:    Print the list of competitions satisfying input criteria
        Output:  .txt file with all the names and url references in the same directory
        Returns:  Nothing   
        '''    
        filename = "usapl_comps"+self.level+self.substring+".txt"
        orig_stdout = sys.stdout
        file = open(filename, 'w')
        sys.stdout = file
        
        if self.level != '':
            print('Sanction:', self.level, self.substring)
            print('-'*20)
        for ref in self.comp_names:
            print(self.comp_names[ref].encode("utf-8"), "link ref:", ref)
                
        file.close()
        sys.stdout = orig_stdout

    def get_comp_ref(self, comp_name):
        '''
        Returns: list contaiing competition url reference based on competition name
                 There might be multiple competition names with the same name
                 Hence, multiple references in the list are possible
        '''
        ref_list = []
        for ref in self.comp_names:
            if self.comp_names[ref] == comp_name:
                ref_list.append(ref)
        return ref_list

    def get_comp_date(self, comp_ref):
        '''
        Returns: date for the competition specified by the url reference
        '''
        return self.data_dict[comp_ref]['Date']

    def get_comp_name(self, comp_ref):
        '''
        Returns: competition name specified by the url reference
        '''
        return self.data_dict[comp_ref]['Name']

