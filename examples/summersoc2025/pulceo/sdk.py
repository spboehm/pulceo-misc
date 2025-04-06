import requests
import json

class API:
    def __init__(self, scheme = "http", host = "localhost", prm_port = 7878, psm_port = 7979):
        self.scheme = scheme
        self.host = host
        self.prm_port = prm_port
        self.psm_port = psm_port

    def read_nodes(self):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/nodes"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch nodes: {response.status_code}, {response.text}")
            return None

    def read_allocatable_cpu(self):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/resources/cpus"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable CPUs: {response.status_code}, {response.text}")
            return None

    def read_allocatable_memory(self):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/resources/memory"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable memory: {response.status_code}, {response.text}")
            return None

    def schedule_task(self, task_id, node_id, status, application_id, application_component_id, properties):
        url = f"{self.scheme}://{self.host}:{self.psm_port}/api/v1/tasks/{task_id}/scheduling"
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
        
    def create_task(self, task):
        url = f"http://{self.host}:{self.psm_port}/api/v1/tasks"
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, headers=headers, data=task)
        try:
            response_payload = response.json()
        except json.JSONDecodeError:
            print("Failed to decode response payload as JSON.")
            return None
        if response.status_code == 201:
            print("Task created successfully.")
        else:
            print(f"Failed to create task. Status code: {response.status_code}, Response: {response.text}")
        return response_payload.get('taskUUID')
