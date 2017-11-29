"""
@author: yzamriy

Goal:    Scrape the data from the Internet and output it into csv format 
"""

from bs4 import BeautifulSoup
import urllib3
import os, csv
import random

def getSoup(url):
    """
    Input:    url of the target page, string
    Returns:  beautiful soup object
    """
    http = urllib3.PoolManager()
    response = http.request('GET', url)

    return BeautifulSoup(response.data, "lxml")

def build_dict(url):
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

    soup = getSoup(url)
    souptable = soup.find("table", class_="tabledata").find('tbody').find_all('tr')
    soupheaders = soup.find("table", class_="tabledata").find('thead').find_all('th')
    
    soupdict = {}

    for row in souptable:
        row_name = row.find('a')['href']
        soupdict[row_name] = {}
        for cn, cv in zip(soupheaders, row.find_all('td')):
            col_names = cn.get_text()
            col_value = cv.get_text().strip()
            soupdict[row_name][col_names] = col_value

    return soupdict

def writetoCSV(somedict, filename, outputdir):
    ''' 
    Goal: Writes 2-level nested dictionary into a csv file
    Input: 2-level nested dictionary
           output file name
           output directory
    Ouput: csv file with results in the output directory
    Returns: Nothing
    '''
    
    # get secondary keys based on the random record
    randomcomp = random.choice(list(somedict))
    colheaders = list(somedict[randomcomp].keys())
    
    # Create a name for the top level keys in the dictionary
    # that contain unique competition ID
    colheaders.insert(0, 'Comp ID')

    home_dir = os.getcwd()
    # subdirectory for csv output
    db_dir = outputdir
    os.chdir(db_dir)

    with open(filename, "w", newline = '', encoding = 'utf-8') as toWrite:
        writer = csv.writer(toWrite, delimiter=",")
        writer.writerow(colheaders)
        for key in somedict:
            row = [key]
            for key2 in somedict[key]:
                row.append(somedict[key][key2])
            writer.writerow(row)

    os.chdir(home_dir)
    
url = "http://usapl.liftingdatabase.com/competitions"
allcomps = build_dict(url)
filename = 'someoutput.csv'
outputdir = "./CSV"
writetoCSV(allcomps, filename, outputdir)
