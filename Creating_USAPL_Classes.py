# -*- coding: utf-8 -*-
"""
Created on Fri Aug 18 14:26:12 2017

@author: yzamriy
"""
from bs4 import BeautifulSoup
import urllib.request
import datetime as dt
import os, csv

class usaplURL(object):
    def __init__(self, report):
        '''
        Initializes a usaplURL object

        a usaplURL object has two attributes:
            self.report_type: string, determined by input text
            self.home_url = "http://usapl.liftingdatabase.com"
        '''
        self.report_type = report
        self.home_url = "http://usapl.liftingdatabase.com"

    def get_full_url(self):
        '''
        Returns: full url for selected report
        '''
        return self.home_url + "/" + self.report_type

    def __str__(self):
        '''
        Prints full url as a string
        '''
        return str(self.home_url + "/" + self.report_type)


class rankingURL(usaplURL):
    def __init__(self, report):
        '''
        Initializes a rankings url object        
        
        A rankingURL object inherits from usaplURL
        '''
        usaplURL.__init__(self, report)

    def apply_soup(self):
        '''
        Applies Beautiful Soup to the page at the specified url
        Returns top 7 rows that contain parameter information
        '''
        
        url = usaplURL.get_full_url(self)
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        r = urllib.request.urlopen(req).read()
        soup = BeautifulSoup(r, "lxml")
        self.top_rows = soup.find_all("tr")[:7]
        
        return self.top_rows

    def build_par_dict(self):
        '''
        Creates and returns a nested dictionary with all the possible ranking parameters
        '''
        
        top_rows = self.apply_soup()
        self.usapl_parameters = {}
        for p in top_rows:
            self.usapl_parameters[p.contents[1].get_text()] = {}
            
        for p in top_rows:
            l = p.contents[3].get_text().strip('\n').split('\n')
            v = p.contents[3].find_all("option")
            for i, j in zip(l,v):
                self.usapl_parameters[p.contents[1].get_text()][i] = j["value"]
        
        # Weight classes are nested within different categories
        # USAPL Nationals are old weight classes
        # IPF are new classes

        fed = top_rows[2].contents[3].find_all("optgroup")
        wclass = top_rows[2].contents[3].find_all("option")    
        self.usapl_parameters["Weightclass"] = {}
        weightclasses = {}       
        fed = top_rows[2].contents[3].find_all("optgroup")
        
        for f in fed:
            weightclasses[f["label"]] = {}
            wclass = f.find_all("option")
            for w in wclass:
                weightclasses[f["label"]][w.get_text()] = w["value"]        
        self.usapl_parameters["Weightclass"] = weightclasses
        
        return self.usapl_parameters
    
    def build_url(self, par_list):
        '''
        Constructs and returns a string with custom parameters 
        Input is a list of parameters created outside the class
        '''
        
        usapl_parameters = self.build_par_dict()        
        sex = usapl_parameters['Sex'][par_list[0]]
        div = usapl_parameters['Division'][par_list[1]]
        wclass = usapl_parameters['Weightclass'][par_list[2]][par_list[3]]
        ex = usapl_parameters['Exercise'][par_list[4]]
        state = usapl_parameters['State'][par_list[5]]
        year = usapl_parameters['Year'][par_list[6]]
        order = usapl_parameters['Order by'][par_list[7]]
        
        self.par_list = "s="+sex+"&c="+div+"&w="+wclass+"&e="+ex+"&st="+state+"&y="+year+"&o="+order
        return self.par_list
        
    def retrun_url(self, par_list):
        '''
        Constructs and returns url with custom parameters 
        '''
        
        url = self.get_full_url()
        parameters = self.build_url(par_list)
        self.par_url = url + "-default?"+parameters
        return self.par_url
        

class rankingDB(object):
    def __init__(self, report, par_list):
        '''
        Initializes a rankingDB object

        a rankingDB object has two attributes:
            self.report_type: string, type of report (valid values: competitions/lifters/rankings/records)
            self.par_list: list of custom parameters
        '''
        self.report_type = report
        self.par_list = par_list

    def apply_soup(self):
        '''
        Applies Beautiful Soup to the page at the specified url
        Returns all rows after row 8 because lifter information start at #9
        '''
        u = rankingURL(self.report_type)
        url = u.retrun_url(self.par_list)
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        r = urllib.request.urlopen(req).read()
        soup = BeautifulSoup(r, "lxml")
        self.lifters = soup.find_all("tr")[9:]
        
        return self.lifters
    
    def build_db(self):
        """ 
        Takes the result of apply_soup and converts it into a nested dictionary
        For each lifter (key in the dictionary) create value dictionary
        Each sub-value in that dictionary corresponds to lifter specific data
        Returns nested dictionary
        """
        
        lifters = self.apply_soup()
        
        # Lifter's name is stored in the 3rd element of the list 
        self.database = {}
        for lifter in lifters:
            self.database[lifter.contents[3].get_text()] = {}
        
        for lifter in lifters:
            self.database[lifter.contents[3].get_text()]['rank'] = lifter.contents[1].get_text()[:-1]
            i = lifter.contents[3].a["href"].find("id")
            self.database[lifter.contents[3].get_text()]['id'] = lifter.contents[3].a["href"][i+3:]
            self.database[lifter.contents[3].get_text()]['rank_meet_date'] = lifter.contents[5].get_text()
            self.database[lifter.contents[3].get_text()]['points'] = lifter.contents[7].get_text()
            self.database[lifter.contents[3].get_text()]['weight'] = lifter.contents[9].get_text()[:-3]
        
        return self.database

    def write_db(self, db_dir):
        """ 
        Takes built database and writes into a csv file
        This method has a custom input 
            db_dir: directory as a string to store the database
        Filename has two parts:
            Data of the pull
            Custom parameters specific to the pull
        Returns nothing
        """
    
        os.chdir(db_dir)
        pull_date = dt.datetime.today().strftime("%m%d%Y")

        u = rankingURL(self.report_type)
        parameters = u.build_url(self.par_list)
        filename = "usapl_ranking_"+pull_date+parameters+".csv"
        database = self.build_db()
        
        with open(filename, "w") as toWrite:
            writer = csv.writer(toWrite, delimiter=",")
            writer.writerow(["name", "rank", "id", "rank_meet_date", "points", "weight"])
            for a in database.keys():
                writer.writerow([a, 
                                 database[a]["rank"], 
                                 database[a]["id"],
                                 database[a]["rank_meet_date"],
                                 database[a]["points"],
                                 database[a]["weight"]])


# Directory for the csv output
db_dir = "/Users/yzamriy/Documents/Tools and Methodology/DS/Powerlifting"

# Enter desired parameters
# All possible values are stored in the file called "usapl_parameters.txt"
sex = 'Female' # Possible Values: 'Male' and 'Female'
div = 'Raw Open' # Possible Values: 'All', 'Raw Open', etc.
fed = 'IPF - Female' # Possible Values: 'IPF - Female' and 'IPF - Male'
wclass = '-84' # Possible Values: '-84', '84+', etc.
exercise = 'Total' # Possible Values: 'Total', 'Squat', 'Bench press', 'Deadlift'
state = 'All' # Possible Values: 'All', 'Nationals', 'Regionals', 'New York'
year = 'All' # Possible Values: 'All', '2017', etc.
order = 'Weight' # Possible Values: 'Points' and 'Weight'

par_list = [sex,div,fed,wclass,exercise,state,year,order]

#rankings = rankingURL("rankings")
#test_url = rankings.retrun_url(par_list)
#test_url = rankingURL.retrun_url("rankings", par_list)
#print(test_url)
db = rankingDB("rankings", par_list)
#db.build_db()
db.write_db(db_dir)