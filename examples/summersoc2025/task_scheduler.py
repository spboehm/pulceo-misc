#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import paho.mqtt.client as mqtt
import json
from pulceo.sdk import API
from config import *
import ssl
import uuid

class Scheduler:
    def __init__(self, scheduling_properties):
        self.scheduling_properties = scheduling_properties
        self.mqtt_host = MQTT_SERVER_NAME
        self.mqtt_port = int(MQTT_PORT)
        self.mqtt_client = self.init_mqtt()
        self.mqtt_client.on_connect = self.on_connect
        self.mqtt_client.on_message = self.on_message
        self.batch_size = int(scheduling_properties['batchSize'])
        self.pulceo_api = API(scheme, host, prm_port, psm_port)

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

    def on_connect(self, client, userdata, flags, reason_code, properties):
        print(f"Connected with result code {reason_code}")
        client.subscribe("tasks/new")
        client.subscribe("tasks/running")  # TODO: do we need this?
        client.subscribe("tasks/scheduled")
        client.subscribe("tasks/offloaded")
        client.subscribe("tasks/completed")

    def on_message(self, client, userdata, msg):
        print(msg.topic + " " + str(msg.payload))
        received_task = json.loads(msg.payload.decode('utf-8'))
        print(f"Scheduler received new task: {received_task}")

        if msg.topic == "tasks/new":
            self.handle_new_task(received_task)
        elif msg.topic == "tasks/completed":
            self.handle_completed_task(received_task)
            self.batch_size = self.batch_size - 1
            print("Scheduler remaining batch size " + str(self.batch_size))
            if self.batch_size == 0:
                self.stop()
        else:
            print(f"Unknown message received on topic {msg.topic}: {msg.payload}")

    def handle_new_task(self, task):
        try:
            allocatable_cpu_resources = self.pulceo_api.read_allocatable_cpu()
            allocatable_mem_resources = self.pulceo_api.read_allocatable_memory()

            elected_node = "edge-0"  # TODO: find eligible node

            task_id = task['taskUUID']
            node_id = allocatable_cpu_resources[0]['nodeUUID']
            status = "SCHEDULED"
            application_id = ""  # TODO: replace dummy
            application_component_id = ""  # TODO: replace dummy

            self.pulceo_api.schedule_task(task_id, node_id, status, application_id, application_component_id, self.scheduling_properties)
        except json.JSONDecodeError as e:
            print(f"Failed to decode task payload: {e}")

    def handle_completed_task(self, task):
        print(f"Scheduler Received completed task: {task}")
        # TODO: on completed release resources
        # TODO: cpu
        # TODO: memory

    def start(self):
        self.mqtt_client.connect(self.mqtt_host, self.mqtt_port, 60)
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