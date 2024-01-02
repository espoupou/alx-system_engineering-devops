#!/usr/bin/python3
""" Script that uses JSONPlaceholder API to get information about employee """
import json
import requests
import sys


if __name__ == "__main__":
    url = 'https://jsonplaceholder.typicode.com/'
    user = '{}users'.format(url)
    res = requests.get(user)
    user_json = res.json()
    d_task = {}
    for user in user_json:
        task_list = []
        name = user.get('username')
        userid = user.get('id')
        todo = '{}todos?userId={}'.format(url, userid)
        res = requests.get(todo)
        tasks = res.json()
        for task in tasks:
            dict_task = {"username": name,
                         "task": task.get('title'),
                         "completed": task.get('completed')}
            task_list.append(dict_task)

        d_task[str(userid)] = task_list
    filename = 'todo_all_employees.json'
    with open(filename, mode='w') as f:
        json.dump(d_task, f)
