import requests
import json

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

    def read_allocatable_cpu_by_node_id(self, node_id):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/nodes/{node_id}/cpu"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable CPU for node {node_id}: {response.status_code}, {response.text}")
            return None
        
    def read_allocatable_cpu_by_node_type(self, node_type):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/resources/cpus?type={node_type}"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable CPU for node type {node_type}: {response.status_code}, {response.text}")
            return None

    def read_allocatable_memory(self):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/resources/memory"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable memory: {response.status_code}, {response.text}")
            return None
        
    def read_allocatable_memory_by_node_id(self, node_id):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/nodes/{node_id}/memory"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable memory for node {node_id}: {response.status_code}, {response.text}")
            return None
    
    def read_allocatable_memory_by_node_type(self, node_type):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/resources/memory?type={node_type}"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable memory for node type {node_type}: {response.status_code}, {response.text}")
            return None

    def update_allocatable_cpu(self, node_id, key, value):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/nodes/{node_id}/cpu/allocatable"
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

    def update_allocatable_memory(self, node_id, key, value):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/nodes/{node_id}/memory/allocatable"
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

    def release_cpu_on_node(self, node_id, key, value):
        current_allocatable_cpu = self.read_allocatable_cpu_by_node_id(node_id)
        self.update_allocatable_cpu(node_id, key, current_allocatable_cpu['cpuAllocatable'][key] + value)

    def release_memory_on_node(self, node_id, key, value):
        current_allocatable_memory = self.read_allocatable_memory_by_node_id(node_id)
        self.update_allocatable_memory(node_id, key, current_allocatable_memory['memoryAllocatable'][key] + value)

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
