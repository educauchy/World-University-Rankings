import random, re
import numpy as np


def set_rank(rank_range):
    """
    Set university rank if it is defined as range, but not a single value

    Parameters:
    rank_range (str): Consists university rank. Two formats: "a-b" or "c+", where a, b, c are integers and a < b

    Return
    int: University rank as an integer
    """

    range_min_max = re.search('(\d+)?-?(\d+)?\+?', rank_range)

    if range_min_max[2] is None:
        return int(range_min_max[1])
    else:
        rank = random.randint(int(range_min_max[1]), int(range_min_max[2]))
        return int(rank)


def kendall_w(data):
    """
    Calculate and return Kendall's coefficient of concordance

    Parameters
    data (Pandas dataframe): Dataframe of data

    Return
    int: W coefficient
    """

    m = 4
    n = len(data)
    Ri = data.sum(axis=1)
    T = 0
    for ranking in data:
        vc = data[ranking].value_counts()
        d = vc[vc > 1]
        t = np.sum(list(map(lambda t: t ** 3 - t, d)))
        T = T + t

    W = (12 * np.sum(Ri) - 3 * m ** 2 * n * (n + 1) ** 2) / (m ** 2 * n * (n ** 2 - 1) - m * T)
    rS = (m * W - 1) / (m - 1)

    return (T, W, rS)