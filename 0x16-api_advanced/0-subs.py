#!/usr/bin/python3
"""
returns the number of subscribers for a given subreddit
"""
import requests

def number_of_subscribers(subreddit):
    """ Queries to Reddit API """
    user_agent = 'Mozilla/5.0'

    headers = {
        'User-Agent': user_agent,
    }

    url = "https://www.reddit.com/r/{}/about.json".format(subreddit)
    res = requests.get(url,
                       headers=headers,
                       allow_redirects=False)

    if res.status_code != 200:
        return 0

    dic = res.json()
    if 'data' not in dic:
        return 0
    if 'subscribers' not in dic.get('data'):
        return 0
    return dic['data']['subscribers']
