import requests
import pandas as pd
from bs4 import BeautifulSoup as BS


url = 'http://indicators.miccedu.ru/monitoring/index.php?m=vpo'
r = requests.get(url)
r.encoding = r.apparent_encoding
page = BS(r.text, 'html.parser')
year = 2019

columns = []
uni_id_list = []
uni = []
data = pd.DataFrame(data=[[0, 1, 2, 3, 4]],
                    columns=['uni_id', 'index', 'desc', 'dim', 'measure'])

for state in page.select('p.MsoListParagraph a[href]'):  # through regions
    region_url = url + '&' + str(year) + '/' + state['href']
    r = requests.get(region_url)
    r.encoding = r.apparent_encoding
    state_page = BS(r.content)

    for uni in state_page.select('.blockcontent tr td.inst a[href]'):  # through unis
        uni_id = int(uni['href'][12:])
        uni.append(uni.get_text())
        uni_id_list.append(uni_id)
        uni_url = 'https://monitoring.miccedu.ru/iam/' + str(year) + '/_vpo/' + uni['href']
        r = requests.get(uni_url)
        r.encoding = r.apparent_encoding
        uni_page = BS(r.content)

        for indicator in uni_page.select('table#analis_dop tr'):  # through the last table
            fields = []
            td_num = len(indicator.find_all('td'))

            if td_num == 4:  # skip headings and not full rows
                for td in indicator.select('td'):
                    fields.append(td.get_text())
                row = pd.DataFrame(data=[[uni_id, fields[0], fields[1], fields[2], fields[3]]],
                                   columns=['uni_id', 'index', 'desc', 'dim', 'measure'])
                data = data.append(row)

data = data.iloc[3:, :]
data.set_index('uni_id', inplace=True)
data.to_excel('../Data/all_russian_uni.xlsx', index=False)