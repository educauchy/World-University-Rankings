import pandas as pd
from helpers import set_rank


unis = pd.read_excel('Data/Russian_Universities.xlsx')
data = pd.read_excel('Data/Russian_Universities_TS_Initial.xlsx')
data.loc[(data.Year == 2020) & (data.Ranking == 'THE')].Rank = unis.THE
data.loc[(data.Year == 2020) & (data.Ranking == 'QS')].Rank = unis.QS
data.loc[(data.Year == 2020) & (data.Ranking == 'ARWU')].Rank = unis.ARWU
data.loc[(data.Year == 2020) & (data.Ranking == 'CWUR')].Rank = unis.CWUR

for index, row in data.iterrows():
    rank = row[2] # rank
    if not isinstance(rank, int) and not (rank is None) and not isinstance( rank, float):
        data.loc[index, 'Rank'] = set_rank(rank)

data.to_excel('Data/Russian_Universities_TS.xlsx', index = False)