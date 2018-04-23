# Assignment 3
#%% Question 1
import pandas as pd
import numpy as np

def answer_one():
#import energy file, skip the header and footer, take columns from c to f
#column names are specified, missing values are specificed.
    energy = pd.read_excel('Energy Indicators.xls',sheet_name='Energy',
                       skiprows = 17,skip_footer = 38,
                       names=['Country','Energy Supply',
                              'Energy Supply per Capital',
                              '% Renewable'],
                       usecols='C:F',na_values='...')
#convert the petajoules to gigajoules in 'Energy Supply'
    energy['Energy Supply'] *= 1E6
#remove the footer number
    energy.loc[:,'Country'] = energy.loc[:,'Country'].str.replace('\d+$','')
#remove the '()' and the content inside
    energy.loc[:,'Country'] = energy.loc[:,'Country'].str.replace(' \(.+\)','')
#replace the country names
    n_change = {'Republic of Korea': 'South Korea',
            'United States of America': 'United States',
            'United Kingdom of Great Britain and Northern Ireland':
                'United Kingdom',
            'China, Hong Kong Special Administrative Region': 
                'Hong Kong'}

    for o,n in n_change.items():
        energy.loc[energy['Country']==o,'Country'] = n

#import GDP info from the world_bank.csv
    GDP = pd.read_csv('world_bank.csv',skiprows = 4)
#replace the country names
    n_change2 = {'Korea, Rep.': 'South Korea',
             'Iran, Islamic Rep.': 'Iran',
             'Hong Kong SAR, China': 'Hong Kong'}
    for o,n in n_change2.items():
        GDP.loc[GDP['Country Name']==o,'Country Name'] = n
    
#import Sciamgo rank data
    ScimEn = pd.read_excel('scimagojr-3.xlsx')

    intermediate = pd.merge(energy,ScimEn,how='inner',left_on = 'Country',
                        right_on = 'Country')
    df = pd.merge(intermediate,GDP,how='inner',left_on='Country',
                        right_on = 'Country Name')
    df = df.set_index('Country')
    columns_to_keep = ['Rank',
                   'Documents',
                   'Citable documents',
                   'Citations',
                   'Self-citations',
                   'Citations per document',
                   'H index',
                   'Energy Supply',
                   'Energy Supply per Capital',
                   '% Renewable',
                   '2006',
                   '2007',
                   '2008',
                   '2009',
                   '2010',
                   '2011',
                   '2012',
                   '2013',
                   '2014',
                   '2015']
    df = df[columns_to_keep]
    df = df.sort_values('Rank').iloc[:15]
    return df

df = answer_one()
#%% Question 2
def answer_two():
    energy = pd.read_excel('Energy Indicators.xls',sheet_name='Energy',
                       skiprows = 17,skip_footer = 38,
                       names=['Country','Energy Supply',
                              'Energy Supply per Capital',
                              '% Renewable'],
                       usecols='C:F',na_values='...')
#convert the petajoules to gigajoules in 'Energy Supply'
    energy['Energy Supply'] *= 1E6
#remove the footer number
    energy.loc[:,'Country'] = energy.loc[:,'Country'].str.replace('\d+$','')
#remove the '()' and the content inside
    energy.loc[:,'Country'] = energy.loc[:,'Country'].str.replace(' \(.+\)','')
#replace the country names
    n_change = {'Republic of Korea': 'South Korea',
            'United States of America': 'United States',
            'United Kingdom of Great Britain and Northern Ireland':
                'United Kingdom',
            'China, Hong Kong Special Administrative Region': 
                'Hong Kong'}

    for o,n in n_change.items():
        energy.loc[energy['Country']==o,'Country'] = n

#import GDP info from the world_bank.csv
    GDP = pd.read_csv('world_bank.csv',skiprows = 4)
#replace the country names
    n_change2 = {'Korea, Rep.': 'South Korea',
             'Iran, Islamic Rep.': 'Iran',
             'Hong Kong SAR, China': 'Hong Kong'}
    for o,n in n_change2.items():
        GDP.loc[GDP['Country Name']==o,'Country Name'] = n
    
#import Sciamgo rank data
    ScimEn = pd.read_excel('scimagojr-3.xlsx')

    intermediate = pd.merge(energy,ScimEn,how='inner',left_on = 'Country',
                        right_on = 'Country')
    df = pd.merge(intermediate,GDP,how='inner',left_on='Country',
                        right_on = 'Country Name')
    df = df.set_index('Country')
    columns_to_keep = ['Rank',
                   'Documents',
                   'Citable documents',
                   'Citations',
                   'Self-citations',
                   'Citations per document',
                   'H index',
                   'Energy Supply',
                   'Energy Supply per Capital',
                   '% Renewable',
                   '2006',
                   '2007',
                   '2008',
                   '2009',
                   '2010',
                   '2011',
                   '2012',
                   '2013',
                   '2014',
                   '2015']
    df = df[columns_to_keep]
    final = df.sort_values('Rank').iloc[:15]
    return np.prod(df.shape) - np.prod(final.shape)

diff_two = answer_two()
#%% Question 3
def answer_three():
    Top15 = answer_one()
    data = Top15[['2006',
                 '2007',
                 '2008',
                 '2009',
                 '2010',
                 '2011',
                 '2012',
                 '2013',
                 '2014',
                 '2015']]
    return (pd.Series(np.mean(data,axis=1),name = 'avgGDP')
               .sort_values(ascending=False))

avgGDP = answer_three()
#%% Question 4
def answer_four():
    Top15 = answer_one()
    data = Top15[['2006',
                 '2007',
                 '2008',
                 '2009',
                 '2010',
                 '2011',
                 '2012',
                 '2013',
                 '2014',
                 '2015']]
    avgGDP = answer_three()
    return (data.loc[avgGDP.index[5],'2015'] - 
            data.loc[avgGDP.index[5],'2006'])
    
diff_four = answer_four()
#%% Question 5
def answer_five():
    Top15 = answer_one()
    return Top15.loc[:,'Energy Supply per Capital'].mean()

mean_five = answer_five()
#%% Question 6
def answer_six():
    Top15 = answer_one()
    return tuple((Top15['% Renewable'].idxmax(),
                 Top15.loc[Top15['% Renewable'].idxmax(),'% Renewable']))

renewable = answer_six()