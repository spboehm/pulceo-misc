import requests
import json
import os

class API:
    def __init__(self, scheme="http", host="localhost", pms_port=7777):
        self.scheme = scheme
        self.host = host
        self.pms_port = pms_port

    def check_health(self):
        url = f"{self.scheme}://{self.host}:{self.pms_port}/pms/health"
        response = requests.get(url)
        if response.status_code == 200:
            print("PMS health check passed.")
        else:
            print(f"PMS health check failed: {response.status_code}, {response.text}")
            raise Exception(f"PMS health check failed: {response.status_code}, {response.text}")

    def create_metric_request(self, path_to_json):
        metric_request = self.read_json(path_to_json)
        url = f"{self.scheme}://{self.host}:{self.pms_port}/api/v1/metric-requests"
        headers = {'Content-Type': 'application/json'}
        response = requests.post(url, headers=headers, data=json.dumps(metric_request))
        if response.status_code == 201:
            print("Metric request created successfully.")
            return response.json()
        else:
            print(f"Failed to create metric request: {response.status_code}, {response.text}")
            if "already exists" in response.text:
                return None
            raise Exception(f"Metric request creation failed: {response.status_code}, {response.text}")
    
    def read_metric_requests(self):
        url = f"{self.scheme}://{self.host}:{self.pms_port}/api/v1/metric-requests"
        response = requests.get(url)
        if response.status_code == 200:
            return response.json()
        else:
            print(f"Failed to fetch metric requests: {response.status_code}, {response.text}")
            return None

    def read_json(self, path):
        with open(path, 'r') as file:
            return json.load(file)