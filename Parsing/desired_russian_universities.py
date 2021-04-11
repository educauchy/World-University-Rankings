import requests
import pandas as pd
from bs4 import BeautifulSoup as BS
import re


url = 'http://indicators.miccedu.ru/monitoring/_vpo/inst.php?id='
unis = pd.read_excel('../Data/Russian_Universities_Initial.xlsx')

for index, uni in unis.iterrows():
    r = requests.get(url + str(uni.Uni_Id))
    r.encoding = r.apparent_encoding
    page = BS(r.text, 'html.parser')

    for indicator in page.select('table#analis_dop tr'):  # through the last table
        fields = []
        td_num = len(indicator.find_all('td'))

        if td_num == 4:  # skip headings and not full rows
            not_valid = False
            for ix, td in enumerate(indicator.select('td')):
                if re.search('№', td.get_text()) or (ix == 2 and re.search('да', td.get_text())):
                    not_valid = True
                    break
                else:
                    fields.append(td.get_text())

            if not_valid == False:
                unis.loc[index, str(fields[0])] = float(fields[3].replace(' ', '').replace(',', '.'))

    for table in page.select('table.napde'):
        row = []
        for ix, indicator in enumerate(table.select('td')):  # through the last table
            if ix in [0, 1, 2, 3]:
                continue
            else:
                res = divmod(ix, 4)
                if res[1] in [0, 3]:
                    row.append(indicator.get_text())

                if res[1] == 3:
                    unis.loc[index, str(row[0])] = float(row[1].replace(' ', '').replace(',', '.'))
                    row = []

    # working with output
    # there is an additional empty tbody before thead of the result table, so we cannot use BS
    # use regex instead
    Es = re.findall('(E\.\d)</td>', str(page))
    output_values = re.findall('right center no-repeat;\">(\d+(?:,\d+)?)<', str(page))
    income = re.findall('<span style=\"\">(\d+(?:,\d+)?)<', str(page))
    output_values.insert(4, income[0])

    for ix, val in enumerate(output_values):
        unis.loc[index, Es[ix]] = float(val.replace(',', '.'))

unis['2.1_2_3'] = unis['2.1'] + unis['2.2'] + unis['2.3']
unis['2.4_5_6'] = unis['2.4'] + unis['2.5'] + unis['2.6']
unis['3.1_2'] = unis['3.1'] + unis['3.2']
unis['6.1_2'] = unis['6.1'] + unis['6.2']
unis['13_14'] = unis['13'] + unis['14']
unis['40_41_42'] = (unis['40'] + unis['41'] + unis['42']) / 10000

unis.to_excel('../Data/desired_russian_uni.xlsx', index=False)
