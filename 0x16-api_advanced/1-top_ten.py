#!/usr/bin/python3
"""prints the top ten hot posts of a subreddit
"""
import requests
import sys


def top_ten(subreddit):
    """ Queries to Reddit API """
    user_agent = 'Mozilla/5.0'

    headers = {
        'User-Agent': user_agent
    }

    params = {
        'limit': 10
    }

    url = "https://www.reddit.com/r/{}/hot.json".format(subreddit)
    res = requests.get(url,
                       headers=headers,
                       params=params,
                       allow_redirects=False)
    if res.status_code != 200:
        print(None)
        return
    dic = res.json()
    hot_posts = dic['data']['children']
    if len(hot_posts) == 0:
        print(None)
    else:
        for post in hot_posts:
            print(post['data']['title'])
