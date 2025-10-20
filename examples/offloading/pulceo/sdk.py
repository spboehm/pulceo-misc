from dotenv import load_dotenv
load_dotenv()
import requests
import json
import os
from . import monitoring
from enum import Enum
from jinja2 import Template

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
# print(read_memory_by_node_id("edge-0"))
# release_cpu_on_node("edge-0", "shares", 6000)
# release_memory_on_node("edge-0", "size",  10.5)

class API:
    def __init__(self, scheme = "http", host = "localhost", prm_port = 7878, psm_port = 7979, pms_port = 7777):
        self.check_for_env_file()
        self.scheme = scheme
        self.host = host
        self.prm_port = prm_port
        self.psm_port = psm_port
        self.pms_port = pms_port
        self.monitoring = monitoring.API()

    def check_for_env_file(self):
        if not os.path.exists(".env"):
            raise FileNotFoundError("The .env file does not exist. Please create it and try again.")

    def check_health(self):
        self.check_heath_prm()
        self.check_health_psm()
        self.monitoring.check_health()

    def check_heath_prm(self):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/prm/health"
        response = requests.get(url)
        if response.status_code == 200:
            print("PRM health check passed.")
        else:
            print(f"PRM health check failed: {response.status_code}, {response.text}")
            raise Exception(f"PRM health check failed: {response.status_code}, {response.text}")

    def check_health_psm(self):
        url = f"{self.scheme}://{self.host}:{self.psm_port}/psm/health"
        response = requests.get(url)
        if response.status_code == 200:
            print("PSM health check passed.")
        else:
            print(f"PSM health check failed: {response.status_code}, {response.text}")
            raise Exception(f"PSM health check failed: {response.status_code}, {response.text}")

    def get_orchestration_context(self, scope = "service"):
        if scope not in ["service", "all"]:
            raise ValueError("scope must be either 'service' or 'all'")
        url = f"{self.scheme}://{self.host}:{self.psm_port}/api/v1/orchestration-context?scope={scope}"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch orchestration context: {response.status_code}, {response.text}")
            return None
        
    def reset_orchestration_context(self):
        url = f"{self.scheme}://{self.host}:{self.psm_port}/api/v1/orchestration-context/reset"
        response = requests.post(url)
        if response.status_code == 200:
            print("Orchestration context successfully reset.")
        else:
            print(f"Failed to reset orchestration context: {response.status_code}, {response.text}")
            raise Exception(f"Failed to reset orchestration context: {response.status_code}, {response.text}")
    
    def create_orchestration(self, name = "name", description = "description", properties = {}):
        url = f"{self.scheme}://{self.host}:{self.psm_port}/api/v1/orchestrations"
        payload = {
            "name": name,
            "description": description,
            "properties": properties
        }
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, headers=headers, data=json.dumps(payload))
        if response.status_code == 201:
            print("Orchestration created successfully.")
            return response.json()
        else:
            print(f"Failed to create orchestration: {response.status_code}, {response.text}")
            return None

    def read_orchestration(self, orchestration_id):
        url = f"{self.scheme}://{self.host}:{self.psm_port}/api/v1/orchestrations/{orchestration_id}"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch orchestration: {response.status_code}, {response.text}")
            return None

    def start_orchestration(self, orchestration_id):
        self.update_orchestration_status(orchestration_id, OrchestrationStatus.RUNNING.name)

    def stop_orchestration(self, orchestration_id):
        self.update_orchestration_status(orchestration_id, OrchestrationStatus.COMPLETED.name)

    def update_orchestration_status(self, orchestration_id, status):
        url = f"{self.scheme}://{self.host}:{self.psm_port}/api/v1/orchestrations/{orchestration_id}/status"

        if status not in OrchestrationStatus.__members__:
            raise ValueError(f"Invalid status '{status}'. Must be one of: {list(OrchestrationStatus.__members__.keys())}")

        payload = {"orchestrationStatus": status}
        headers = {'Content-Type': 'application/json'}
        response = requests.put(url, headers=headers, data=json.dumps(payload))
        if response.status_code == 200:
            print(f"Orchestration status updated to {status}.")
            return response.json()
        else:
            print(f"Failed to update orchestration status: {response.status_code}, {response.text}")
            return None

    def read_nodes(self):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/nodes"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch nodes: {response.status_code}, {response.text}")
            return None

    def create_node(self, path_to_json):
        node = self.read_json(path_to_json)
        if (node['nodeType'] == "ONPREM"):
            # inject pnaInitToken from env
            node['pnaInitToken'] = os.getenv('PNA_INIT_TOKEN')
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/nodes"
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, headers=headers, data=json.dumps(node))
        if response.status_code == 201:
            print("Node created successfully.")
            return response.json()
        else:
            print(f"Failed to create node: {response.status_code}, {response.text}")
            if "already exists" in response.text:
                return None
            raise Exception(f"Node creation failed: {response.status_code}, {response.text}")

    def read_links(self):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/links"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch links: {response.status_code}, {response.text}")
            return None
        
    def create_link(self, path_to_json):
        link = self.read_json(path_to_json)
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/links"
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, headers=headers, data=json.dumps(link))
        if response.status_code == 201:
            print("Link created successfully.")
            return response.json()
        else:
            print(f"Failed to create link: {response.status_code}, {response.text}")
            if "already exists" in response.text:
                return None
            raise Exception(f"Link creation failed: {response.status_code}, {response.text}")
        
    def read_json(self, path):
        with open(path, 'r') as file:
            return json.load(file)

    def read_cpu(self):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/resources/cpus"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable CPUs: {response.status_code}, {response.text}")
            return None

    def read_cpu_by_node_id(self, node_id):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/nodes/{node_id}/cpu"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable CPU for node {node_id}: {response.status_code}, {response.text}")
            return None
    
    def read_cpu_by_node_type(self, node_type):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/resources/cpus?type={node_type}"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable CPU for node type {node_type}: {response.status_code}, {response.text}")
            return None

    def read_memory(self):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/resources/memory"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable memory: {response.status_code}, {response.text}")
            return None
        
    def read_memory_by_node_id(self, node_id):
        url = f"{self.scheme}://{self.host}:{self.prm_port}/api/v1/nodes/{node_id}/memory"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch allocatable memory for node {node_id}: {response.status_code}, {response.text}")
            return None
    
    def read_memory_by_node_type(self, node_type):
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
        current_allocatable_cpu = self.read_cpu_by_node_id(node_id)
        self.update_allocatable_cpu(node_id, key, current_allocatable_cpu['cpuAllocatable'][key] + value)

    def release_memory_on_node(self, node_id, key, value):
        current_allocatable_memory = self.read_memory_by_node_id(node_id)
        self.update_allocatable_memory(node_id, key, current_allocatable_memory['memoryAllocatable'][key] + value)

    def create_application(self, node_id, application_name, path_to_json):
        application = self.read_json(path_to_json)
        template = Template(json.dumps(application))
        application = json.loads(template.render(node_id=node_id, name=application_name, **os.environ))
        url = f"{self.scheme}://{self.host}:{self.psm_port}/api/v1/applications"
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, headers=headers, data=json.dumps(application))
        if response.status_code == 201:
            print("Applications created successfully.")
            return response.json()
        else:
            print(f"Failed to create application: {response.status_code}, {response.text}")
            if "already exists" in response.text:
                return None
            raise Exception(f"Node creation failed: {response.status_code}, {response.text}")

    def read_applications(self):
        url = f"{self.scheme}://{self.host}:{self.psm_port}/api/v1/applications"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch applications: {response.status_code}, {response.text}")
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
        url = f"{self.scheme}://{self.host}:{self.psm_port}/api/v1/tasks"
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

    def create_orchestration_report(self, orchestration_id):
        url = f"{self.scheme}://{self.host}:{self.psm_port}/api/v1/orchestrations/{orchestration_id}/reports"
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, headers=headers)
        if response.status_code == 201:
            print("Orchestration report created successfully.")
        else:
            print(f"Failed to create orchestration report: {response.status_code}, {response.text}")
            return None

class OrchestrationStatus(Enum):
    RUNNING = "RUNNING"
    COMPLETED = "COMPLETED"