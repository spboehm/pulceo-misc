#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import paho.mqtt.client as mqtt
import requests
import json
import time
from config import host, psm_port

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, reason_code, properties):
    print(f"Connected with result code {reason_code}")
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("tasks/+/responses")

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    received_task = json.loads(msg.payload.decode('utf-8'))
    print(f"Received new task: {received_task}")
    timestamp_res = getTimeStamp()
    history[received_task['globalTaskUUID']]['timestamp_res'] = timestamp_res

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
    try:
        response_payload = response.json()
    except json.JSONDecodeError:
        print("Failed to decode response payload as JSON.")
    if response.status_code == 201:
        print("Task created successfully.")
    else:
        print(f"Failed to create task. Status code: {response.status_code}, Response: {response.text}")
    return response_payload['taskUUID']

def getTimeStamp():
    posix_timestamp = int(time.time_ns())
    return(posix_timestamp)

class TaskMetric():
    def __init__(self, task_uuid, resource, value, unit):
        self.requestUUID = str(uuid.uuid4())
        self.timestamp = getTimeStamp()
        self.requestType = "task_rtt"
        self.sourceHost = os.getenv('MQTT_CLIENT_ID')
        self.taskUUID = task_uuid
        self.resource = resource
        self.value = value
        self.unit = unit

    def to_json(self):
        return json.dumps(self.__dict__)

    def to_string(self):
        return str(self.to_json())

mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
mqttc.on_connect = on_connect
mqttc.on_message = on_message

mqttc.connect("localhost", 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
mqttc.loop_start()

if __name__ == "__main__":

    # TODO: subscribe to mqtt endpoint, given by pms, listen for responses
    # callback_protocol=mqtt
    # callback_endpoint=tasks/uuid/response

    history = {}

    tasks = read_generated_tasks("tasks/generated_tasks_100.json")
    for task in tasks:
        print(f"Processing task: {task}")
        # Simulate waiting for a response and updating the history
        # In a real scenario, this would be updated in the on_message callback
        task_uuid = create_task(json.dumps(task))
        time.sleep(0.1)
        # Sleep for 0.1 seconds to achieve 10 executions per second
        timestamp_req = getTimeStamp()
        history[task_uuid] = {
            "task_uuid": task_uuid,
            "timestamp_req": timestamp_req
            }
        break

    while(True):
        time.sleep(5)