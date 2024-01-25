#!/usr/bin/python3
"""
returns the number of subscribers for a given subreddit
"""
import requests

def number_of_subscribers(subreddit):
    """ Queries to Reddit API """

    headers = {
<<<<<<< HEAD
        'User-Agent': 'Mozilla/5.0',
=======
        'user-agent': user_agent,
>>>>>>> 2d5997df73bb9e3c05113ca0073b958e88abe3d8
    }

    url = "https://www.reddit.com/r/{}/about.json".format(subreddit)
    print(url)
    res = requests.get(url,
                       headers=headers)
#                       allow_redirects=False)
    print(res.content.decode())
    if res.status_code != 200:
        return 0

    dic = res.json()
    if 'data' not in dic:
        return 0
    if 'subscribers' not in dic.get('data'):
        return 0
    return dic['data']['subscribers']
