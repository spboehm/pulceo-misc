#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import paho.mqtt.client as mqtt
import json
from pulceo.sdk import API
from config import *
import ssl
import uuid
from abc import ABC, abstractmethod
import logging
import threading

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

class Scheduler(ABC):
    def __init__(self, scheduling_properties):
        self.scheduling_properties = scheduling_properties
        self.mqtt_host = MQTT_SERVER_NAME
        self.mqtt_port = int(MQTT_PORT)
        self.mqtt_client = self.init_mqtt()
        self.mqtt_client.on_connect = self.on_connect
        self.mqtt_client.on_message = self.on_message
        self.batch_size = int(scheduling_properties['batchSize'])
        self.pulceo_api = API(scheme, host, prm_port, psm_port)
        self.on_init()

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
        logging.info(f"Connected with result code {reason_code}")
        client.subscribe("tasks/new")
        client.subscribe("tasks/running")  # TODO: do we need this?
        client.subscribe("tasks/scheduled")
        client.subscribe("tasks/offloaded")
        client.subscribe("tasks/completed")

    def on_message(self, client, userdata, msg):
        logging.info(msg.topic + " " + str(msg.payload))
        received_task = json.loads(msg.payload.decode('utf-8'))
        logging.info(f"Scheduler received new task: {received_task}")

        if msg.topic == "tasks/new":
            self.handle_new_task(received_task)
        elif msg.topic == "tasks/completed":
            self.handle_completed_task(received_task)
            self.batch_size = self.batch_size - 1
            logging.info("Scheduler remaining batch size " + str(self.batch_size))
            logging.info("Remaining size in buffer " + str(len(self.pendingTasks)))
            if self.batch_size == 0:
                self.mqtt_client.publish("cmd/tasks", "STOP")
                self.stop()

        else:
            logging.info(f"Unknown message received on topic {msg.topic}: {msg.payload}")
    
    @abstractmethod
    def on_init(self):
        pass

    @abstractmethod
    def handle_new_task(self, task):
        pass
    
    @abstractmethod
    def handle_completed_task(self, task):
        pass

    @abstractmethod
    def on_terminate(self):
        pass

    def start(self):
        self.mqtt_client.connect(self.mqtt_host, self.mqtt_port, 60)
        self.mqtt_client.loop_forever()

    def stop(self):
        self.on_terminate()
        self.mqtt_client.loop_stop()
        self.mqtt_client.disconnect()

class EdgeOnlyScheduler(Scheduler):

    name = "EdgeOnlyScheduler"
    processedTasks = {}
    pendingTasks = []
    PENDING_TASKS_THRESHOLD = 0
    on_terminate = False

    def deferTasks(self, task):
        self.pendingTasks.append(task)
        
    def maxAllocatableCPU(self, value):
        return value * 0.75

    def maxAllocatableMem(self, value):
        if value < 2.00:
            return 0.576
        elif value < 4.00:
            return 3.82
        elif value < 8:
            return 5.5125
        elif value < 16:
            return 13.2685
        
    def on_init(self):
        # read all nodes
        nodes = self.pulceo_api.read_nodes()
        for node in nodes:
            # set custom resource limits, resources must be left for hypervisor and platform components
            cpu_on_node = self.pulceo_api.read_allocatable_cpu_by_node_id(node['uuid'])
            self.pulceo_api.update_allocatable_cpu(node['uuid'], 'shares', self.maxAllocatableCPU(cpu_on_node['cpuCapacity']['shares']))

            # set custom resource limits, resources must be left for hypervisor and platform components
            memory_on_node = self.pulceo_api.read_allocatable_memory_by_node_id(node['uuid'])
            self.pulceo_api.update_allocatable_memory(node['uuid'], 'size', self.maxAllocatableMem((memory_on_node['memoryCapacity']['size'])))

    def schedule(self, task, nodeType):
        # requirements of tasks
        req_cpu_share_task = int(task['requirements']['cpu_shares'])
        req_memory_task = float(task['requirements']['memory_size'])

        # find an eligible node
        # since this is the edge-only scheduler, only edge nodes are required
        cpu_resources = self.pulceo_api.read_allocatable_cpu_by_node_type(nodeType)

        # first, try to find an appropriate node that satisfies the CPU requirements
        try:
            if (len(cpu_resources) == 0):
                raise RuntimeError("Severe error: Unable to find a suitable node for task scheduling.")
            highest_shares_node = max(cpu_resources, key=lambda x: x["cpuAllocatable"]["shares"])
        except ValueError:
            logging.error("No eligible nodes found. 'cpu_resources' is empty, unable to determine the node with the highest CPU shares.")
            self.pendingTasks.append(task)
            return
        
        if highest_shares_node["cpuAllocatable"]["shares"] >= req_cpu_share_task:
            # CPU requirements are satisfied, now, check for memory resources
            memory_resources = self.pulceo_api.read_allocatable_memory_by_node_type(nodeType)

            try:
                if (memory_resources is None or len(memory_resources) == 0):
                    raise RuntimeError("Severe error: Unable to find a suitable node for task scheduling.")
                highest_memory_size_node = max(memory_resources, key=lambda x: x["memoryAllocatable"]["size"])
            except ValueError:
                logging.error("No eligible nodes found. 'memory_resources' is empty, unable to determine the node with the highest memory size.")
                self.pendingTasks.append(task)
                return
            
            if highest_memory_size_node['memoryAllocatable']['size'] > req_memory_task:
                # ready to deloy
                elected_node = highest_memory_size_node["nodeName"]
                print(f"Elected node for task deployment: {elected_node}")
                node_id = highest_memory_size_node['nodeUUID']

                # update resources
                self.pulceo_api.update_allocatable_cpu(node_id, "shares", highest_shares_node["cpuAllocatable"]["shares"] - req_cpu_share_task)
                self.pulceo_api.update_allocatable_memory(node_id, "size", highest_memory_size_node['memoryAllocatable']['size'] - req_memory_task)
                
                # prepare for scheduling
                task_id = task['taskUUID']
                status = "SCHEDULED"
                application_id = ""  # TODO: replace dummy
                if (bool(os.getenv('LOCAL_SCHEDULING')) is True):
                    if (elected_node == "edge-0"):
                        application_component_id = "127.0.0.1:8087"
                    else:
                        application_component_id = "127.0.0.2:8087"
                else:
                    pass
                    # TODO: resolve workaround, putting the port the application_component_id
                # application_component_id = elected_node + "-edge-iot-simulator-component-eis" + ".pulceo.svc.cluster.local:80"
                # schedule
                self.pulceo_api.schedule_task(task_id, node_id, status, application_id, application_component_id, self.scheduling_properties)
                # add mapping between task_id and node_id to processedTasks for later mapping
                # will be return by the API later
                self.processedTasks[task_id] = node_id
            else:
                # Add the task to the pendingTasks buffer for future scheduling
                self.pendingTasks.append(task)
                logging.info(f"Task {task['taskUUID']} added to pending buffer due to insufficient memory resources.")
        else:
            # Add the task to the pendingTasks buffer for future scheduling
            self.pendingTasks.append(task)
            logging.info(f"Task {task['taskUUID']} added to pending buffer due to insufficient CPU resources.")
    
    def handle_new_task(self, task):
        logging.info(f"{self.name} Received new task: {task}")
        self.schedule(task, "EDGE")

        if len(self.pendingTasks) > self.PENDING_TASKS_THRESHOLD:
            self.handle_new_task(self.pendingTasks.pop())
            print("Remaining in buffer from handle_new_task " + str(len(self.pendingTasks)))
        
    def handle_completed_task(self, task):
        logging.info(f"{self.name} Received completed task: {task}")
        self.pulceo_api.release_cpu_on_node(self.processedTasks[task['taskUUID']], "shares", int(task['requirements']['cpu_shares']))
        self.pulceo_api.release_memory_on_node(self.processedTasks[task['taskUUID']], "size", float(task['requirements']['memory_size']))

        if len(self.pendingTasks) > self.PENDING_TASKS_THRESHOLD:
            self.handle_new_task(self.pendingTasks.pop())
            print("Remaining in buffer from handle_completed_task" + str(len(self.pendingTasks)))

    def on_terminate(self):
        MAX_RETRIES = 1000
        pass
        # while (len(self.pendingTasks) > 0):
        #     print("on_terminate")
        #     CURRENT_NUMBER_OF_TASKS = len(self.pendingTasks)
        #     self.handle_new_task(self.pendingTasks.pop())
        #     if (len(self.pendingTasks) == CURRENT_NUMBER_OF_TASKS):
        #         MAX_RETRIES = MAX_RETRIES - 1
        #     if (MAX_RETRIES == 0):
        #         raise RuntimeError("Unable to process pending tasks after maximum retries.")

class JointScheduler(EdgeOnlyScheduler):

    name = "JointScheduler"

    def handle_new_task(self, task):
        logging.info(f"{self.name} Received new task: {task}")
        self.schedule(task, "")

class CloudOnlyScheduler(EdgeOnlyScheduler):

    name = "CloudOnlyScheduler"

    def handle_new_task(self, task):
        logging.info(f"{self.name} Received new task: {task}")
        self.schedule(task, "CLOUD")

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