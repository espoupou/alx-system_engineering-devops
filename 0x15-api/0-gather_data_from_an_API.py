#!/usr/bin/python3
""" Script that uses JSONPlaceholder API to get information about employee """
import requests
import sys


if __name__ == "__main__":
    url = 'https://jsonplaceholder.typicode.com/'

    user = '{}users/{}'.format(url, sys.argv[1])
    res = requests.get(user)
    u_json = res.json()
    print("Employee {} is done with tasks".format(u_json.get('name')), end="")

    todo = '{}todos?userId={}'.format(url, sys.argv[1])
    res = requests.get(todo)
    tasks = res.json()
    task_list = []
    for task in tasks:
        if task.get('completed') is True:
            task_list.append(task)

    print("({}/{}):".format(len(task_list), len(tasks)))
    for task in l_task:
        print("\t {}".format(task.get("title")))
