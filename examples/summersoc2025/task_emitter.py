#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import paho.mqtt.client as mqtt
import requests
import json
import time
import uuid
import os
import threading
from pulceo.sdk import API

class TaskMetric:
    def __init__(self, task_uuid, resource, value, unit):
        self.requestUUID = str(uuid.uuid4())
        self.timestamp = TaskEmitter.get_timestamp()
        self.requestType = "task_rtt"
        self.sourceHost = os.getenv('MQTT_CLIENT_ID')
        self.destinationHost = task_uuid
        self.resource = resource
        self.value = value
        self.unit = unit

    def to_json(self):
        return json.dumps(self.__dict__)

    def to_string(self):
        return str(self.to_json())

class TaskEmitter:
    def __init__(self, mqtt_host="localhost", mqtt_port=1883, scheduling_properties = {}):
        self.mqtt_host = mqtt_host
        self.mqtt_port = mqtt_port
        self.task_file = f"tasks/generated_tasks_{scheduling_properties["batchSize"]}.json"
        self.batch_size = int(scheduling_properties["batchSize"])
        self.history = {}
        self.mqtt_client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
        self.mqtt_client.on_connect = self.on_connect
        self.mqtt_client.on_message = self.on_message
        self.scheduling_properties = scheduling_properties
        self.exit_event = threading.Event()
        self.pulceo_api = API()

    @staticmethod
    def get_timestamp():
        return int(time.time_ns())

    def on_connect(self, client, userdata, flags, reason_code, properties):
        print(f"Connected with result code {reason_code}")
        client.subscribe("tasks/+/responses")

    def on_message(self, client, userdata, msg):
        received_task = json.loads(msg.payload.decode('utf-8'))
        print(f"Emitter Received new task: {received_task}")
        timestamp_res = self.get_timestamp()
        task_uuid = received_task['globalTaskUUID']
        self.history[task_uuid]['timestamp_res'] = timestamp_res

        time_diff_ms = (timestamp_res - self.history[task_uuid]['timestamp_req']) / 1_000_000

        requests_topic = "dt/pulceo/requests"
        task_metric = TaskMetric(
            task_uuid=task_uuid,
            resource="response_time",
            value=time_diff_ms,
            unit="ms"
        )
        self.mqtt_client.publish(requests_topic, task_metric.to_json())
        self.batch_size = self.batch_size - 1
        if self.batch_size == 0:
            self.stop()

    def read_generated_tasks(self):
        try:
            with open(self.task_file, "r") as file:
                tasks = json.load(file)
                return tasks
        except FileNotFoundError:
            print(f"File not found: {self.task_file}")
            return []
        except json.JSONDecodeError:
            print(f"Error decoding JSON from file: {self.task_file}")
            return []

    def start(self):
        self.mqtt_client.connect(self.mqtt_host, self.mqtt_port, 60)
        self.mqtt_client.loop_start()

        tasks = self.read_generated_tasks()
        for task in tasks:
            # enrich with scheduling properties
            task["schedulingProperties"] = self.scheduling_properties
            print(f"Processing task: {task}")
            timestamp_req = self.get_timestamp()
            task_uuid = self.pulceo_api.create_task(json.dumps(task))
            if task_uuid:
                self.history[task_uuid] = {
                    "task_uuid": task_uuid,
                    "timestamp_req": timestamp_req
                }
            time.sleep(0.1)

        # wait, until all messages have been received, then terminate
        self.exit_event.wait()

    def stop(self):
        self.exit_event.set()
        self.mqtt_client.disconnect()

if __name__ == "__main__":
    emitter = TaskEmitter()
    emitter.start()
