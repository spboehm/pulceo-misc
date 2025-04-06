#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from task_generator import generate_tasks
from task_scheduler import CloudOnlyScheduler, EdgeOnlyScheduler, JointScheduler
from task_emitter import TaskEmitter
from multiprocessing import Process

# batch_sizes = [200, 400, 600, 800]
batch_sizes = [10]
layers = ["edge-only"]
#layers = ["cloud-only", "edge-only", "joint"]

def create_scenarios():
    for batch_size in batch_sizes:
        generate_tasks(batch_size)

def start_experiments():
    for layer in layers:
        for batch_size in batch_sizes:
            properties = {
                "policy": "FIFO",
                "batchSize": str(batch_size),
                "layer": layer
            }

            # scheduler
            if layer == "cloud-only":
                scheduler = CloudOnlyScheduler(scheduling_properties=properties)
            elif layer == "edge-only":
                scheduler = EdgeOnlyScheduler(scheduling_properties=properties)
            elif layer == "joint":
                scheduler = JointScheduler(scheduling_properties=properties)
            else:
                raise ValueError(f"No appropriate scheduler found for layer: {layer}")
            def run_scheduler():
                scheduler.start()

            # start scheduler as sub process
            process = Process(target=run_scheduler)
            process.start()
            print(f"Starting scheduler for batch_size={batch_size} and layer={layer}")
            
            # start task emitter
            emitter = TaskEmitter(scheduling_properties=properties)
            emitter.start()
            print(f"TaskEmitter started for batch_size={batch_size} and layer={layer}")
            
            # wait for termination, after all tasks are completed
            process.join()
            print(f"Completed experiments for batch_size={batch_size} and layer={layer}")

if __name__ == "__main__":
    create_scenarios()
    start_experiments()
