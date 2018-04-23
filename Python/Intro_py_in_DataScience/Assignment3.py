# Assignment 3
#%% Question 1
import pandas as pd
import numpy as np
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
energy.loc[:,'Country'].str.replace('\d+$','')
#replace the country names
n_change = {'Republic of Korea': 'South Korea',
                       'United States of America': 'United States',
                       'United Kingdom of Great Britain and Northern Ireland':
                           'United Kingdom',
                       'China, Hong Kong Special Administrative Region': 
                           'Hong Kong'}

for o,n in n_change.items():
    energy.loc[energy['Country']==o,'Country'] = n

