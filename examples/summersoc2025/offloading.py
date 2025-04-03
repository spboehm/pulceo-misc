#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from task_generator import generate_tasks
from scheduler import Scheduler
from task_emitter import TaskEmitter
from multiprocessing import Process

# Scenarios
properties = {
    "policy": "FIFO",
    "batchSize": "200",
    "layer": "cloud-only"
}

batch_sizes = [200, 400, 600, 800]
layers = ["cloud-only", "edge-only", "joint"]


def create_scenarios():
    for batch_size in batch_sizes:
        generate_tasks(batch_size)

# TODO: invoke scheduler.py with properties
def start_experiments():
    for layer in layers:
        for batch_size in batch_sizes:
            properties = {
                "policy": "FIFO",
                "batchSize": str(batch_size),
                "layer": layer
            }
            properties["layer"] = layer
            properties["batchSize"] = str(batch_size)
            
            # scheduler
            scheduler = Scheduler(properties)
            def run_scheduler():
                scheduler.start()

            # start scheduling as sub process
            process = Process(target=run_scheduler)
            process.start()
            
            # task_emitter
            emitter = TaskEmitter(batch_size=batch_size)
            emitter.start()
            
            # wait for termination, after all tasks are completed
            process.join()
            break

if __name__ == "__main__":
    # Add your main execution logic here
    create_scenarios()
    start_experiments()
