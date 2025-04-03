#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import paho.mqtt.client as mqtt
import requests
import json
import dotenv
from config import scheme, host, psm_port, prm_port

class Scheduler:
    def __init__(self, scheduling_properties, mqtt_host="localhost", mqtt_port=1883, mqtt_keepalive=60, batch_size=100):
        self.scheduling_properties = scheduling_properties
        self.mqtt_client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
        self.mqtt_client.on_connect = self.on_connect
        self.mqtt_client.on_message = self.on_message
        self.mqtt_client.connect(mqtt_host, mqtt_port, mqtt_keepalive)
        self.batch_size = batch_size

    def on_connect(self, client, userdata, flags, reason_code, properties):
        print(f"Connected with result code {reason_code}")
        client.subscribe("tasks/new")
        client.subscribe("tasks/running")  # TODO: do we need this?
        client.subscribe("tasks/scheduled")
        client.subscribe("tasks/offloaded")
        client.subscribe("tasks/completed")
        # TODO: add failed

    def on_message(self, client, userdata, msg):
        print(msg.topic + " " + str(msg.payload))
        received_task = json.loads(msg.payload.decode('utf-8'))
        print(f"Scheduler received new task: {received_task}")

        if msg.topic == "tasks/new":
            self.handle_new_task(received_task)
        elif msg.topic == "tasks/completed":
            self.handle_completed_task(received_task)
            self.batch_size = self.batch_size - 1
            if self.batch_size == 0:
                print("stop")
                self.stop()
        else:
            print(f"Unknown message received on topic {msg.topic}: {msg.payload}")

    def handle_new_task(self, task):
        try:
            allocatable_cpu_resources = self.read_allocatable_cpu()
            allocatable_mem_resources = self.read_allocatable_memory()

            elected_node = "edge-0"  # TODO: find eligible node

            task_id = task['taskUUID']
            node_id = allocatable_cpu_resources[0]['nodeUUID']
            status = "SCHEDULED"
            application_id = ""  # TODO: replace dummy
            application_component_id = ""  # TODO: replace dummy

            self.schedule_task(task_id, node_id, status, application_id, application_component_id, self.scheduling_properties)
        except json.JSONDecodeError as e:
            print(f"Failed to decode task payload: {e}")

    def handle_completed_task(self, task):
        print(f"Received completed task: {task}")
        # TODO: on completed release resources
        # TODO: cpu
        # TODO: memory

    def read_nodes(self):
        url = f"{scheme}://{host}:{prm_port}/api/v1/nodes"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch nodes: {response.status_code}, {response.text}")
            return None

    def read_allocatable_cpu(self):
        url = f"{scheme}://{host}:{prm_port}/api/v1/resources/cpus"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable CPUs: {response.status_code}, {response.text}")
            return None

    def read_allocatable_memory(self):
        url = f"{scheme}://{host}:{prm_port}/api/v1/resources/memory"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable memory: {response.status_code}, {response.text}")
            return None

    def schedule_task(self, task_id, node_id, status, application_id, application_component_id, properties):
        url = f"{scheme}://{host}:{psm_port}/api/v1/tasks/{task_id}/scheduling"
        payload = {
            "nodeId": node_id,
            "status": status,
            "applicationId": application_id,
            "applicationComponentId": application_component_id,
            "properties": {
                "policy": properties["policy"],
                "batchSize": properties["batchSize"],
                "layer": properties["layer"]
            }
        }
        headers = {'Content-Type': 'application/json'}

        response = requests.put(url, data=json.dumps(payload), headers=headers)
        if response.status_code == 200:
            print(f"Task {task_id} successfully scheduled on node {node_id}.")
            return response.json()
        else:
            print(f"Failed to schedule task {task_id}: {response.status_code}, {response.text}")
            return None

    def start(self):
        self.mqtt_client.loop_forever()

    def stop(self):
        self.mqtt_client.loop_stop()
        self.mqtt_client.disconnect()

if __name__ == "__main__":
    # print("=== Example hot to use the Python SDK ===")
    # print(read_nodes())
    # print(read_allocatable_cpu())
    # print(read_allocatable_memory())
    # print(read_node_by_id("edge-0"))
    # print(update_allocatable_cpu("edge-0", "shares", 8000))
    # print(read_allocatable_cpu())
    # print(update_allocatable_memory("edge-0", "size", 8192))
    # print(read_allocatable_memory())
    # print(read_allocatable_cpu_by_node_id("edge-0"))
    # print(read_allocatable_memory_by_node_id("edge-0"))
    # release_cpu_on_node("edge-0", "shares", 6000)
    # release_memory_on_node("edge-0", "size",  10.5)
    # scheduler = Scheduler()
    # scheduler.start()
    pass