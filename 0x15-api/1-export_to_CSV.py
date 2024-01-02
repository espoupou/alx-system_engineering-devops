#!/usr/bin/python3
""" Script that uses JSONPlaceholder API to get information about employee """
import csv
import requests
import sys


if __name__ == "__main__":
    url = 'https://jsonplaceholder.typicode.com/'

    userid = sys.argv[1]
    user = '{}users/{}'.format(url, userid)
    res = requests.get(user)
    json_o = res.json()
    name = json_o.get('username')

    todo = '{}todos?userId={}'.format(url, userid)
    res = requests.get(todo)
    tasks = res.json()
    task_list = []
    for task in tasks:
        task_list.append([userid,
                       name,
                       task.get('completed'),
                       task.get('title')])

    filename = '{}.csv'.format(userid)
    with open(filename, mode='w') as file:
        employee_writer = csv.writer(file,
                                     delimiter=',',
                                     quotechar='"',
                                     quoting=csv.QUOTE_ALL)
        for task in task_list:
            employee_writer.writerow(task)
