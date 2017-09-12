"""
Created on Thu Aug 17 17:44:10 2017

@author: yzamriy

Goal:   extrat USAPL structure parameters (divisions, levels, etc) 
        These parameters will be used to extract specific data from 
        the database (about lifters and competition)

Output: 1. Nested dictionary called usapl_parameters 
        2. .txt file 

"""

from bs4 import BeautifulSoup
import urllib3
import sys

http = urllib3.PoolManager()
url = 'http://usapl.liftingdatabase.com/rankings'
response = http.request('GET', url)
soup = BeautifulSoup(response.data, "lxml")

# all the necessary data is contained in the top part of the page
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

# Write the dictionary to a txt file
orig_stdout = sys.stdout
file = open("usapl_parameters.txt", 'w')
sys.stdout = file

for i in usapl_parameters:
    print()
    print("-"*2)
    print("Parameter:", i)
    if i == "Weightclass":
        for fed in usapl_parameters[i]:
            print()
            print("Federation:", fed)
            print("Possible values:")
            for w in usapl_parameters[i][fed]:
                print(w)
    else:
        print()
        print("Possible values:")
        for j in usapl_parameters[i].keys():
            print(j)
        
file.close()
sys.stdout = orig_stdout

