"""
Created on Thu Aug 17 17:44:10 2017

@author: yzamriy

Goal:   Create Parameters object containing a nested dictionary with
        USAPL structure parameters (divisions, levels, etc) 
        These parameters will be used to extract specific data from 
        the database (about lifters and competition)

Input:  No input is required. 

Main methods:   1. par_to_txt: prints all possible parameter values to .txt      
                2. build_par_ref: builds a string for the url reference
                3. return_dict: returns parameter nested dictionary

Requirements: Soup.py to get Beautiful Soup objects
"""

from Soup import *
import sys

class Parameters(object):
    def __init__(self):
        '''
        Goal:       Initializes Parameters object
        Details:    Parameters object has following attributes:
                        self.reference: constant string 'rankings'
                        self.usapl_parameters: nested dictionary
        '''
        self.reference = 'rankings'
        self.usapl_parameters = self.build_par_dict()

    def build_par_dict(self):
        '''
        Goal:       Builds parameter dictionary
        Inputs:     none
        Returns:    nested dictionary  
        '''        
        # all the necessary data is contained in the top part of the page
        soup = getSoup(self.reference)
        top_rows = soup.find_all("tr", limit = 7)
        
        # usapl_parameters is a nested dictionary
        # First layer contains the following keys:
        # Sex, Division, Weightclass, Exercise, State, Year, Order by
        # Second layer exists only for Weightclass. The keys are
        # IPF - Female; IPF - Male; USAPL Nationals - Female; USAPL Nationals - Male
        # The last two are old weight classes
        
        usapl_parameters = {}
        for p in top_rows:
            key = p.find("th").get_text()
            usapl_parameters[key] = {}
            if key == "Weightclass":
                weightclasses = {}
                for fed in p.find_all("optgroup"):
                    weightclasses[fed["label"]] = {}
                    wclass = fed.find_all("option")
                    for w in wclass:
                        weightclasses[fed["label"]][w.get_text()] = w["value"]
                usapl_parameters["Weightclass"] = weightclasses
            else:    
                for option in p.find_all("option"):
                    code = option["value"]
                    textname = option.get_text()
                    usapl_parameters[key][textname] = code
        return usapl_parameters
                    
    def return_dict(self):
        return self.usapl_parameters

    def par_to_txt(self):
        ''' 
        Goal:    Print all parameter values to a .txt
        Inputs:  non
        Output:  .txt file with all parameter values
        Returns:  Nothing   
        '''     
        usapl_parameters = self.return_dict()    

        # Write the dictionary to a txt file
        orig_stdout = sys.stdout
        file = open("usapl_parameters.txt", 'w')
        sys.stdout = file
        
        for par in usapl_parameters:
            print()
            print("-"*2)
            print("Parameter:", par)
            if par == "Weightclass":
                for fed in usapl_parameters[par]:
                    print()
                    print("Federation:", fed)
                    print("Possible values:")
                    for wclass in usapl_parameters[par][fed]:
                        print(wclass)
            else:
                print()
                print("Possible values:")
                for val in usapl_parameters[par].keys():
                    print(val)
        file.close()
        sys.stdout = orig_stdout
        
    def build_par_ref(self, par_list):
        '''
        Goal:    Constructs and returns a string with custom parameters 
        Inputs:  par_list, list of specific parameters 
        Returns: string, to be used as a url reference
        '''
        usapl_parameters = self.return_dict()    
        sex = usapl_parameters['Sex'][par_list[0]]
        div = usapl_parameters['Division'][par_list[1]]
        wclass = usapl_parameters['Weightclass'][par_list[2]][par_list[3]]
        ex = usapl_parameters['Exercise'][par_list[4]]
        state = usapl_parameters['State'][par_list[5]]
        year = usapl_parameters['Year'][par_list[6]]
        order = usapl_parameters['Order by'][par_list[7]]
        
        return "s="+sex+"&c="+div+"&w="+wclass+"&e="+ex+"&st="+state+"&y="+year+"&o="+order
        
#Parameters()
