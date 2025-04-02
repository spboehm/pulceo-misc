import requests
import json
import time
from config import host, psm_port

def read_generated_tasks(file_path):
    try:
        with open(file_path, "r") as file:
            tasks = json.load(file)
            return tasks
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return []
    except json.JSONDecodeError:
        print(f"Error decoding JSON from file: {file_path}")
        return []

# pulceo API function
def create_task(task):
    # /api/v1/tasks
    url = f"http://{host}:{psm_port}/api/v1/tasks"
    headers = {'Content-Type': 'application/json'}
    response = requests.post(url, headers=headers, data=task)

    if response.status_code == 201:
        print("Task created successfully.")
    else:
        print(f"Failed to create task. Status code: {response.status_code}, Response: {response.text}")

    pass

if __name__ == "__main__":
    tasks = read_generated_tasks("tasks/generated_tasks_100.json")
    for task in tasks:
        print(f"Processing task: {task}")
        create_task(json.dumps(task))
        time.sleep(0.1)  # Sleep for 0.1 seconds to achieve 10 executions per second