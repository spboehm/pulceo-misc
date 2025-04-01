#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import paho.mqtt.client as mqtt
import requests
import json
import dotenv
from config import scheme, host, psm_port, prm_port


# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, reason_code, properties):
    print(f"Connected with result code {reason_code}")
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("tasks/new")
    client.subscribe("tasks/running") # TOOD: do we need this?s
    client.subscribe("tasks/scheduled")
    client.subscribe("tasks/offloaded")
    client.subscribe("tasks/completed")

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))

    received_task = json.loads(received_task.decode('utf-8'))
    print(f"Received new task: {received_task}")
    
    if (msg.topic == "tasks/new"):
        handle_new_task(received_task)
    elif (msg.topic == "tasks/completed"):
        handle_completed_task(received_task)
    else:
        print(f"Unknown message received on topic {msg.topic}: {msg.payload}")

# USER OVERRIDES
def handle_new_task(task):
    try:
        # TODO: find eligible node
        # TODO: read allocatable cpu resources
        allocatable_cpu_resources = read_allocatable_cpu()
        # TODO: read allocatable memory resources
        allocatable_mem_resources = read_allocatable_memory()

        # TODO: this is the result
        elected_node = "edge-0"

        task_id = task['taskUUID']
        node_id = allocatable_cpu_resources[0]['nodeUUID']
        status = "SCHEDULED"
        application_id = ""
        application_component_id = ""

        schedule_task(task_id, node_id, status, application_id, application_component_id)
        
    except json.JSONDecodeError as e:
        print(f"Failed to decode task payload: {e}")
    pass

# USER OVERRIDES
def handle_completed_task(task):
    task = json.loads(task.decode('utf-8'))
    print(f"Received completed task: {task}")
    
    # TODO: on completed release resources
    # TODO: cpu
    # TODO: memory

### === PULCEO SDK FUNCTIONS === ###
def read_nodes():
    url = f"{scheme}://{host}:{prm_port}/api/v1/nodes"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch nodes: {response.status_code}, {response.text}")
        return None

def read_node_by_id(node_id):
    url = f"{scheme}://{host}:{prm_port}/api/v1/nodes/{node_id}"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch node with ID {node_id}: {response.status_code}, {response.text}")
        return None
    pass

def read_allocatable_cpu():
    url = f"{scheme}://{host}:{prm_port}/api/v1/resources/cpus"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch allocatable CPUs: {response.status_code}, {response.text}")
        return None

def read_allocatable_cpu_by_node_id(node_id):
    url = f"{scheme}://{host}:{prm_port}/api/v1/nodes/{node_id}/cpu"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch allocatable CPU for node {node_id}: {response.status_code}, {response.text}")
        return None

def read_allocatable_memory_by_node_id(node_id):
    url = f"{scheme}://{host}:{prm_port}/api/v1/nodes/{node_id}/memory"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch allocatable memory for node {node_id}: {response.status_code}, {response.text}")
        return None

def read_allocatable_memory():
    url = f"{scheme}://{host}:{prm_port}/api/v1/resources/memory"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch allocatable memory: {response.status_code}, {response.text}")
        return None
    pass

def update_allocatable_cpu(node_id, key, value):
    url = f"{scheme}://{host}:{prm_port}/api/v1/nodes/{node_id}/cpu/allocatable"
    payload = {"key": key,
               "value": value}
    headers = {'Content-Type': 'application/json'}

    response = requests.patch(url, data=json.dumps(payload), headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to update allocatable CPU for node {node_id}: {response.status_code}, {response.text}")
        return None
    # TODO: validation
    pass

def update_allocatable_memory(node_id, key, value):
    url = f"{scheme}://{host}:{prm_port}/api/v1/nodes/{node_id}/memory/allocatable"
    payload = {"key": key,
               "value": value}
    headers = {'Content-Type': 'application/json'}

    response = requests.patch(url, data=json.dumps(payload), headers=headers)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to update allocatable memory for node {node_id}: {response.status_code}, {response.text}")
        return None
    # TODO: validation
    pass

# wrapper function for read and update
def release_cpu_on_node(node_id, key, value):
    current_allocatable_cpu = read_allocatable_cpu_by_node_id(node_id)
    update_allocatable_cpu(node_id, key, current_allocatable_cpu['cpuAllocatable'][key] + value)

# wrapper function for read and update
def release_memory_on_node(node_id, key, value):
    current_allocatable_memory = read_allocatable_memory_by_node_id(node_id)
    update_allocatable_memory(node_id, key, current_allocatable_memory['memoryAllocatable'][key] + value)

def schedule_task(task_id, node_id, status, application_id, application_component_id):
    # TODO: put request
    url = f"{scheme}://{host}:{psm_port}/api/v1/tasks/{task_id}/scheduling"
    payload = {
        "nodeId": node_id,
        "status": status,
        "applicationId": application_id,
        "applicationComponentId": application_component_id
    }
    headers = {'Content-Type': 'application/json'}

    response = requests.put(url, data=json.dumps(payload), headers=headers)
    if response.status_code == 200:
        print(f"Task {task_id} successfully scheduled on node {node_id}.")
        return response.json()
    else:
        print(f"Failed to schedule task {task_id}: {response.status_code}, {response.text}")
        return None

mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
mqttc.on_connect = on_connect
mqttc.on_message = on_message

mqttc.connect("localhost", 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
#mqttc.loop_forever()

if __name__ == "__main__":
    print("=== Example hot to use the Python SDK ===")
    print(read_nodes())
    print(read_allocatable_cpu())
    print(read_allocatable_memory())
    print(read_node_by_id("edge-0"))
    print(update_allocatable_cpu("edge-0", "shares", 8000))
    print(read_allocatable_cpu())
    print(update_allocatable_memory("edge-0", "size", 8192))
    print(read_allocatable_memory())
    print(read_allocatable_cpu_by_node_id("edge-0"))
    print(read_allocatable_memory_by_node_id("edge-0"))
    release_cpu_on_node("edge-0", "shares", 6000)
    release_memory_on_node("edge-0", "size",  10.5)
    pass