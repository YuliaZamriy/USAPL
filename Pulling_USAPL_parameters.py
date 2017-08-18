# -*- coding: utf-8 -*-
"""
Created on Thu Aug 17 17:44:10 2017

@author: yzamriy

Pulling parameters of ranking database
Output: nested dictionary called usapl_parameters

"""

from bs4 import BeautifulSoup
import urllib.request
import sys

url = 'http://usapl.liftingdatabase.com/rankings'
req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
r = urllib.request.urlopen(req).read()
soup = BeautifulSoup(r, "lxml")

top_rows = soup.find_all("tr")[:7]

usapl_parameters = {}
for p in top_rows:
    usapl_parameters[p.contents[1].get_text()] = {}
    
for p in top_rows:
    l = p.contents[3].get_text().strip('\n').split('\n')
    v = p.contents[3].find_all("option")
    for i, j in zip(l,v):
        usapl_parameters[p.contents[1].get_text()][i] = j["value"]

""" Weight classes are nested within different categories
    USAPL Nationals are old weight classes
    IPF are new classes
"""

fed = top_rows[2].contents[3].find_all("optgroup")
wclass = top_rows[2].contents[3].find_all("option")    
usapl_parameters["Weightclass"] = {}
weightclasses = {}

fed = top_rows[2].contents[3].find_all("optgroup")
for f in fed:
    weightclasses[f["label"]] = {}
    wclass = f.find_all("option")
    for w in wclass:
        weightclasses[f["label"]][w.get_text()] = w["value"]

usapl_parameters["Weightclass"] = weightclasses

orig_stdout = sys.stdout
f = open("usapl_parameters.txt", 'w')
sys.stdout = f

for i in usapl_parameters:
    print("Parameter:", i)
    print()
    print("Possible values:")
    for j in usapl_parameters[i].keys():
        print(j)
    print()
    print("-"*2)
        
sys.stdout = orig_stdout
f.close()
