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
