# Assignment 2.2

import pandas as pd
import numpy as np
census_df = pd.read_csv('census.csv')
census_df.head()

#%% Question 5
def answer_five():
    county = census_df[census_df['SUMLEV']==50]
    county = county.set_index('STNAME')
    return county.groupby('STNAME').count()['COUNTY'].idxmax()
    
answer_five()

#%% Question 5.1
def answer_five_one():
    state = census_df[census_df['SUMLEV']==50]
    return state['STNAME'].value_counts().idxmax()

answer_five_one()

#%% Question 6
def answer_six():
    county = census_df.copy()
    county = county[county['SUMLEV']==50]
    county = county.set_index('STNAME')
    popdata = county['CENSUS2010POP']
    df = pd.DataFrame(columns = ['pop'])
    for i in popdata.index.unique():
        if np.prod(popdata.loc[i].shape) > 1:
            descounties = popdata.loc[i].sort_values(ascending=False)
            popfromtop3 = descounties[:3].sum()
            df.loc[i] = [popfromtop3]
        elif np.prod(popdata.loc[i].shape) == 1:
            df.loc[i] = popdata.loc[i]
    top3 = df.sort_values(by='pop',ascending=False)
    return list(top3[:3].index)

answer_six()