import requests
import pandas as pd
from bs4 import BeautifulSoup as BS


url = 'http://www.shanghairanking.com/ARWU2019.html'
r = requests.get(url)
page = BS(r.text, 'html.parser')

data = pd.DataFrame(data = [[0, 1, 2, 3, 4, 5, 6, 7]],
                    columns = ['Rank', 'Uni', 'Alumni', 'Award', 'HiCi', 'N&S', 'PUB', 'PCP'])

for i, uni in enumerate(page.select('table#UniversityRanking tr')):
    if i == 0:
        continue
    else:
        fields = []
        for j, indicator in enumerate(uni.select('td')):
            if j in [0, 1, 5, 6, 7, 8, 9, 10]:
                if j == 1:
                    ind = (indicator.select('a'))[0].text
                else:
                    ind = indicator.text
                fields.append(ind)
        row = pd.DataFrame(data = [[fields[0], fields[1], fields[2], fields[3], fields[4], fields[5], fields[6], fields[7]]],
                                    columns = ['Rank', 'Uni', 'Alumni', 'Award', 'HiCi', 'N&S', 'PUB', 'PCP'])
        data = data.append(row)

data.set_index('Rank', inplace = True)
data.to_excel('../Data/ARWU_Ranking_Full.xlsx')