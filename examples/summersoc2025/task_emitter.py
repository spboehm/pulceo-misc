#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import paho.mqtt.client as mqtt
import json
import time
import uuid
import os
import threading
from pulceo.sdk import API
from config import *
import uuid
import ssl
import threading

class TaskMetric:
    def __init__(self, task_uuid, resource, value, unit):
        self.requestUUID = str(uuid.uuid4())
        self.timestamp = TaskEmitter.get_timestamp()
        self.requestType = "task_rtt"
        self.sourceHost = os.getenv('MQTT_CLIENT_ID')
        self.destinationHost = task_uuid # TODO: replace with uuid from PSM OR UUID from processing node
        self.resource = resource
        self.value = value
        self.unit = unit

    def to_json(self):
        return json.dumps(self.__dict__)

    def to_string(self):
        return str(self.to_json())

class TaskEmitter:
    def __init__(self, scheduling_properties = {}):
        self.mqtt_host = MQTT_SERVER_NAME
        self.mqtt_port = int(MQTT_PORT)
        self.task_file = f"tasks/generated_tasks_{scheduling_properties["batchSize"]}.json"
        self.batch_size = int(scheduling_properties["batchSize"])
        self.history = {}
        self.mqtt_client = self.init_mqtt()
        self.mqtt_client.on_connect = self.on_connect
        self.mqtt_client.on_message = self.on_message
        self.scheduling_properties = scheduling_properties
        self.exit_event = threading.Event()
        self.pulceo_api = API(scheme, host, prm_port, psm_port)
        self.lock = threading.Lock()

    def init_mqtt(self):
        client = mqtt.Client(client_id=str(uuid.uuid4()), clean_session=False, callback_api_version=mqtt.CallbackAPIVersion.VERSION2)
        if (os.getenv('MQTT_USERNAME') is not None and os.getenv('MQTT_PASSWORD') is not None):
            client.username_pw_set(username=os.getenv('MQTT_USERNAME'), password=os.getenv('MQTT_PASSWORD'))
        if(os.getenv('MQTT_TLS') == 'True'):
            ca_certs = os.getenv('MQTT_CA_CERTS', default=None)
            certfile = os.getenv('MQTT_CERTFILE', default=None)
            keyfile = os.getenv('MQTT_KEYFILE', default=None)
            cert_reqs = ssl.CERT_REQUIRED if os.getenv('MQTT_CERT_REQ') == 'True' else ssl.CERT_NONE

            client.tls_set(ca_certs=ca_certs, certfile=certfile, keyfile=keyfile, cert_reqs=cert_reqs, tls_version=ssl.PROTOCOL_TLSv1_2)
            #client.tls_set(cert_reqs=cert_reqs, tls_version=ssl.PROTOCOL_TLSv1_2)
            if (os.getenv('MQTT_TLS_INSECURE') == 'True'):
                client.tls_insecure_set(True)
        client.on_connect = self.on_connect
        client.on_message = self.on_message
        client.reconnect_delay_set(min_delay=1, max_delay=3600)

        return client

    @staticmethod
    def get_timestamp():
        return int(time.time_ns())

    def on_connect(self, client, userdata, flags, reason_code, properties):
        print(f"Connected with result code {reason_code}")
        client.subscribe("tasks/+/responses")
        client.subscribe("cmd/tasks")

    def on_message(self, client, userdata, msg):
        
        if msg.topic == "cmd/tasks":
            self.stop()
        else:
            with self.lock:
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
                    print("TaskEmitter last message received")
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
            with self.lock:
                # enrich with scheduling properties
                task["schedulingProperties"] = self.scheduling_properties
                timestamp_req = self.get_timestamp()
                task_uuid = self.pulceo_api.create_task(json.dumps(task))
                self.history[task_uuid] = {
                    "task_uuid": task_uuid,
                    "timestamp_req": timestamp_req
                }
                time.sleep(0.1)
        # wait, until all messages have been received, then terminate
        self.exit_event.wait()

    def stop(self):
        self.mqtt_client.loop_stop()
        self.mqtt_client.disconnect()
        self.exit_event.set()

if __name__ == "__main__":
    emitter = TaskEmitter()
    emitter.start()
