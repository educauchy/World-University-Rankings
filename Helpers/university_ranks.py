import pandas as pd
from helpers import set_rank


unis = pd.read_excel('../Data/desired_russian_uni.xlsx', index=False)
for index, university in unis.iterrows():
    for ranking in ['THE', 'QS', 'CWUR', 'ARWU']:
        value = unis.loc[unis.University == university[0], ranking]
        if not (isinstance(value[index], int) or value[index] is None or isinstance(value[index], float)):
            unis.loc[unis.University == university[0], ranking] = set_rank(value[index])

unis.to_excel('../Data/Russian_Universities.xlsx', index=False)
unis.to_csv('./Data/Russian_Universities.csv', index=False)