# -*- coding: utf-8 -*-
"""
Created on Mon Aug 28 14:55:08 2017

@author: yzamriy

Goal:   Scrape the data for a specified competition, put it in a nested 
        dictionary and write it out into a .csv file
        
Input:  Competition name, string. For example, "Raw Nationals 2016"        

"""
import random
from Pulling_USAPL_comp_names import *

# Specify directory for the output csv files
db_dir = "./CSV"

def get_comp_ref(comp_name):
    usapl_comps = build_comp_dict()
    return usapl_comps[comp_name]["link"]

def get_col_names(comp_name):
    ''' Input:   Competition name, string
        Goal:    Get names for the columns of competition results table
                 from beautiful soup object
        Returns: col_names, list of strings
    '''    
    comp_soup = get_soup(get_comp_ref(comp_name))
    comp_soup_colnames = comp_soup.find("table", id="competition_view_results").find('thead').find_all('th')
    
    # First column in the scraped table doesn't have a name, but it 
    # contains lister weight class data
    col_names = ['Weightclass']
    for cl in comp_soup_colnames:
        # Each lift covers 3 columns (one for each attmept)
        # Raw scraped table has three columns but only one name
        # We create column names for each attempt column
        # Squat1, Squat2, Squat3, Bench Press1, etc.
        if cl.get_text() in ['Squat','Bench press','Deadlift']:
            for i in '123':
                col_names.append(cl.get_text()+i)
        else:
           col_names.append(cl.get_text()) 
    return col_names

def get_comp_data(comp_name):
    ''' Input:   Competition name, string
        Goal:    Pull competition results from beautiful soup object
                 into a nested dictionary
        Returns: comp_table dictionary
    '''    
    comp_soup = get_soup(get_comp_ref(comp_name))
    comp_soup_table = comp_soup.find("table", id="competition_view_results").find('tbody').find_all('tr')  
    col_names = get_col_names(comp_name)
    
    comp_table = {}
    for comp in comp_soup_table:
        if comp.find('a'):
            lifter_name = comp.find('a').get_text()
            comp_table[lifter_name] = {}
            for cl, cv in zip(col_names, comp.find_all('td')):
                col_value = cv.get_text().strip()
                comp_table[lifter_name][cl] = col_value
                comp_table[lifter_name]['Link'] = comp.find('a')["href"]
    
    return comp_table
            
def write_db(comp_name, db_dir):
    ''' Input:   Competition name, string
                 output directory, string
        Goal:    Writes the nested dictionary containing competition results
                 into a csv file
        Result:  csv file with results in the output directory
        Returns: Nothing
    '''

    os.chdir(db_dir)
    filename = comp_name+".csv"
    comp_table = get_comp_data(comp_name)
    
    with open(filename, "w") as toWrite:
        writer = csv.writer(toWrite, delimiter=",")
        
        # get column names from the values of a random key (lifter name)
        writer.writerow(comp_table[random.choice(list(comp_table))].keys())
        for lifter in comp_table:
            row = []
            for col in comp_table[lifter]:
                row.append(comp_table[lifter][col])
            writer.writerow(row)

write_db("2017 Northeast Regional Championships", db_dir)


