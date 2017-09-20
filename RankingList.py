# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:26:12 2017

@author: yzamriy
Goal:           Create RankingList object
                Containing a dictionary of lifters in the ranking
                based on specified parameters
                It inherets all attributes and methods from UsaplData object

Input:          par_list, list
                Consists of:    sex, division, federation, weight class,
                                exercise, state, year, order                

Main methods:   1. get_lifter_ref: returns lifter url reference based on 
                                    specified name
                2. build_filename: construct a filename for the csv file 
                                    containing the dictionary
    
Requirements:   UsaplData.py to get UsaplData object
                Parameters.py to build reference urls for specific paramters
"""
from Parameters import Parameters
from UsaplData import UsaplData
import datetime

class RankingList(UsaplData):
    def __init__(self, par_list):
        '''
        Goal:       Initializes RankingList object
        Details:    RankingList object has following attributes:
                    inherited:
                        self.data_dict: nested dictionary with data
                        self.col_names: list with key names from the dictionary
                    own:
                        self.par_list: list of ranking parameters
                        self.par_ref: string, url based on par_list
                        self.reference: string, part of the url address for target page
        '''
        self.par_list = par_list
        self.par_ref = Parameters().build_par_ref(self.par_list)
        self.reference = "rankings-default?" + self.par_ref
        UsaplData.__init__(self, self.reference)

    def get_lifter_ref(self, lifter_name):
        '''
        Returns: lifter url reference based on specified name
        '''
        data_dict = self.return_dict()
        for ref in data_dict:
            if data_dict[ref]['Lifter'] == lifter_name:
                return ref
            
    def build_filename(self):
        '''
        Returns: string, filename for the csv file containing the dictionary
        '''
        pull_date = datetime.datetime.today().strftime("%m%d%Y")
        return "usapl_ranking_"+pull_date+str(self.par_ref)+".csv"

