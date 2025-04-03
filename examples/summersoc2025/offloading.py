#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from task_generator import generate_tasks

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
def create_schedulers():
    for layer in layers:
        for batch_size in batch_sizes:
            # TODO: create scheduler
            # TODO: start task_emitter.py
            # TODO: 
            pass



# TODO: invoke task_emitter.py

if __name__ == "__main__":
    # Add your main execution logic here
    create_scenarios()
    pass

