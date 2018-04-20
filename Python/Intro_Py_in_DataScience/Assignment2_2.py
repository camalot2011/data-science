# Assignment 2.2

import pandas as pd
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
    county.groupby('STNAME')['CENSUS2010POP'].sort_values(ascending=False)
