# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 15:05:25 2017

@author: yzamriy

Goal:    Function returning Soup object based on the specified url reference 

Input:   URL Reference, string
         This is the string that follows "http://usapl.liftingdatabase.com"
    
Retruns: Beautiful Soup object
"""

from bs4 import BeautifulSoup
import urllib3

def getSoup(reference):
    '''
    Input:    reference, string. Part of the url address for target page
    Returns:  beautiful soup object
    '''
    url = "http://usapl.liftingdatabase.com" + "/" + reference
    http = urllib3.PoolManager()
    response = http.request('GET', url)

    return BeautifulSoup(response.data, "lxml")

#reference = "competitions"
#competitions = getSoup(reference)

#comptable = competitions.find("table", class_="tabledata").find('tbody').find_all('tr')
