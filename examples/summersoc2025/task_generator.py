#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import json
from config import host, psm_port
import os

def save_generated_tasks(num_tasks, tasks):
    # Ensure the 'tasks' subdirectory exists
    tasks_dir = "tasks"
    os.makedirs(tasks_dir, exist_ok=True)

    # Create the filename with the number of tasks
    filename = os.path.join(tasks_dir, f"generated_tasks_{num_tasks}.json")

    # Write tasks to the file
    with open(filename, "w") as file:
        json.dump(tasks, file, indent=4)

    print(f"Tasks saved to {filename}")

if __name__ == "__main__":
    # Define the proportions
    task_distribution = {
        "small": 0.50,
        "medium": 0.30,
        "large": 0.20
    }

    # Define task properties
    task_properties = {
        "small": {
            "createdBy": "task_emitter.py",
            "sizeOfWorkload": 10,
            "sizeDuringTransmission": 10,
            "deadline": 50,
            "payload_length": 10,
            "cpu_shares": 500,
            "memory_size": 0.25,
            "properties": {"task_type": "small"}
        },
        "medium": {
            "createdBy": "task_emitter.py",
            "sizeOfWorkload": 100,
            "sizeDuringTransmission": 100,
            "deadline": 250,
            "payload_length": 100,
            "cpu_shares": 1000,
            "memory_size": 0.50,
            "properties": {"task_type": "medium"}
        },
        "large": {
            "createdBy": "task_emitter.py",
            "sizeOfWorkload": 1000,
            "sizeDuringTransmission": 1000,
            "deadline": 1500,
            "payload_length": 1000,
            "cpu_shares": 2000,
            "memory_size": 1.00,
            "properties": {"task_type": "large"}
        },
    }

    # Generate 100 tasks
    num_tasks = 100
    tasks = []
    for task_type, proportion in task_distribution.items():
        num_task_type = int(num_tasks * proportion)
        for _ in range(num_task_type):
            task_data = {"task type": task_type}
            task_data.update(task_properties[task_type])
            tasks.append(task_data)
    
    # Save the generated tasks to a file
    save_generated_tasks(num_tasks, tasks)


