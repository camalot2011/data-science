# Assigment_2 part_1
#%%
import pandas as pd

df = pd.read_csv('olympics.csv', index_col=0, skiprows=1)

for col in df.columns:
    if col[:2]=='01':
        df.rename(columns={col:'Gold'+col[4:]}, inplace=True)
    if col[:2]=='02':
        df.rename(columns={col:'Silver'+col[4:]}, inplace=True)
    if col[:2]=='03':
        df.rename(columns={col:'Bronze'+col[4:]}, inplace=True)
    if col[:1]=='№':
        df.rename(columns={col:'#'+col[1:]}, inplace=True)

names_ids = df.index.str.split('\s\(') # split the index by '('

df.index = names_ids.str[0] # the [0] element is the country name (new index) 
df['ID'] = names_ids.str[1].str[:3] # the [1] element is the abbreviation or ID (take first 3 characters from that)

df = df.drop('Totals')
df.head()

#%% Question 0
def answer_zero():
    return df.iloc[0]

answer_zero()

#%% Question 1
def answer_one():
    return df['Gold'].idx()

answer_one()

#%% Question 2
def answer_two():
    diff = abs(df['Total']-df['Total.1'])
    return diff.idxmax()

answer_two()

#%% Question 3
def answer_three():
    somegold = df[(df['Gold'] > 0) & (df['Gold.1']>0)]
    perc_diff = abs(somegold['Gold']-somegold['Gold.1'])/somegold['Gold.2']
    return perc_diff.idxmax()

answer_three()

#%% Question 4
def answer_four():
    Points = df['Gold.2']*3+df['Silver.2']*2+df['Bronze.2']
    return Points

answer_four()