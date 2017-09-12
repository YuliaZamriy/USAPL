# -*- coding: utf-8 -*-
"""
Created on Tue Sep 12 15:05:25 2017

@author: yzamriy

Goal: Apply Beautiful soup to a specified url
"""

from bs4 import BeautifulSoup
import urllib3

class Soup(object):
    def __init__(self, ref):
        '''
        Goal:       Initializes Soup object
        Details:    Soup object has two attributes:
                        self.reference: string, reference to be appeneded to the home url
                        self.home_url = "http://usapl.liftingdatabase.com"
        Returns: Nothing
        '''
        self.reference = ref
        self.home_url = "http://usapl.liftingdatabase.com"

    def get_full_url(self):
        '''
        Goal:    Construct url for the target data
        Returns: Full url wtih specified reference
        '''
        return self.home_url + "/" + self.reference

    def get_soup(self):
        '''
        Goal:   Pull the data from the specified url and
                convert it to beautiful soup package
        Returns: Beautiful soup object 
        '''    
        http = urllib3.PoolManager()
        url = self.get_full_url()
        response = http.request('GET', url)
        self.soup_obj = BeautifulSoup(response.data, "lxml")
        
        return self.soup_obj 

    def __str__(self):
        '''
        Prints full url as a string
        '''
        return str(self.home_url + "/" + self.report_type)
    
#r = Soup('competitions')
#s = r.get_soup()