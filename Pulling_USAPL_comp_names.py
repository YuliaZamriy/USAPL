# -*- coding: utf-8 -*-
"""
Created on Thu Sep  7 13:54:57 2017

@author: yzamriy

Goal:   1. Scrape the names of all the available competitions from USAPL site
        2. Put competition names into a nested dictionary for access by other
        functions
        
Inputs: Optional:   'level' is 'NS' for national and 'RG' for regional
                    'sub' any substring within the name of the competition.
                    For example, 'Raw' or 'High School'

Output: usapl_comps (nested dictionary)
        usaple_comps_date.txt file with all competition names requested

"""

from bs4 import BeautifulSoup
import urllib3
import sys
import datetime

def get_soup(report_type = 'competitions'):
    ''' Input:   report_type corresponds to the type of report to pull from usapl site
                 default = 'competitions'
        Returns: Beautiful soup object containing all competition names
    '''    
    http = urllib3.PoolManager()
    url = 'http://usapl.liftingdatabase.com/'+report_type
    response = http.request('GET', url)
    return BeautifulSoup(response.data, "lxml")
    
def build_comp_dict():
    ''' Input:   No input required
        Goal:    Create nested dictionary
        Returns: usapl_comps dictionary containing competition names and dates
    '''    
    comp_soup = get_soup()
    comp_soup_colnames = comp_soup.find("table", class_="tabledata").find('thead').find_all('th')
    comp_soup_table = comp_soup.find("table", class_="tabledata").find('tbody').find_all('tr')
    
    usapl_comps = {}
    for comp in comp_soup_table:
        comp_name = comp.find('a').get_text().strip()
        usapl_comps[comp_name] = {}
        for cl, cv in zip(comp_soup_colnames, comp.find_all('td')):
            col_names = cl.get_text()
            col_value = cv.get_text().strip()
            usapl_comps[comp_name][col_names] = col_value
        usapl_comps[comp_name]["link"] = comp.find('a')["href"]
   
    return usapl_comps 

def get_comp_names(level = '', sub = ''):
    ''' Input:   Optional. Competition level (National, Regional etc.), string
                          Substring in the required competition name, string
        Goal:    Create a list of all competition names satisfying input criteria
        Returns: comp_names, list of names
    '''    
    comp_dict = build_comp_dict()
    comp_names = []
    for comp in comp_dict:
        if comp_dict[comp]['Sanction #'].find(level) >= 0 and comp_dict[comp]['Name'].find(sub) >= 0:
            comp_names.append(comp_dict[comp]['Name'])
    return comp_names

def print_comp_names(level = '', sub = ''):
    ''' Input:   Optional. Competition level (National, Regional etc.), string
                           Substring in the required competition name, string
        Goal:    Print the list of competition names satisfying input criteria
        Output:  .txt file with all the names
        Returns: Nothing
    '''    
    pull_date = datetime.datetime.today().strftime("%m%d%Y")
    filename = "usapl_comps_"+level+sub+"_"+pull_date+".txt"
    usapl_comps = get_comp_names(level, sub)
    
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
    
print_comp_names(level = '', sub = '')
#print(get_comp_names(level = 'RG', sub = '2017'))
