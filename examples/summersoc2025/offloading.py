import paho.mqtt.client as mqtt
import requests
import json
import dotenv

scheme = "http"
host = "localhost"
psm_port = "7979"
prm_port = "7878"
# TODO: pms_port

# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, reason_code, properties):
    print(f"Connected with result code {reason_code}")
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("tasks/new")
    client.subscribe("tasks/completed")

# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))

    if (msg.topic == "tasks/new"):
        handle_new_task(msg.payload)
    else:
        print(f"Unknown message received on topic {msg.topic}: {msg.payload}")

def handle_new_task(payload):
    try:
        task = json.loads(payload.decode('utf-8'))
        print(f"Received new task: {task}")
        # Process the task_data as needed
        
        # TODO: find eligible node
        # TODO: read allocatable cpu resources
        # TODO: read allocatable memory resources
        # TODO: this is the result
        print(str(read_nodes()))
        elected_node = "edge-0"
        
    except json.JSONDecodeError as e:
        print(f"Failed to decode task payload: {e}")
    pass

def read_nodes():
    url = f"{scheme}://{host}:{prm_port}/api/v1/nodes"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch nodes: {response.status_code}, {response.text}")
        return None

def read_node_by_id(node_id):
    url = f"{scheme}://{host}:{prm_port}/api/v1/nodes/{node_id}"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch node with ID {node_id}: {response.status_code}, {response.text}")
        return None
    pass

def read_allocatable_cpu():
    url = f"{scheme}://{host}:{prm_port}/api/v1/resources/cpus"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch allocatable CPUs: {response.status_code}, {response.text}")
        return None

def read_allocatable_memory():
    url = f"{scheme}://{host}:{prm_port}/api/v1/resources/memory"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print(f"Failed to fetch allocatable memory: {response.status_code}, {response.text}")
        return None
    pass

def update_allocatable_cpu(node_id, key, value):
    url = f"{scheme}://{host}:{prm_port}/api/v1/nodes/{node_id}/cpu/allocatable"
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

def update_allocatable_memory(node_id, key, value):
    url = f"{scheme}://{host}:{prm_port}/api/v1/nodes/{node_id}/memory/allocatable"
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

def schedule_task(task_id):
    # TODO: put request
    pass

def handle_completed_task(msg):
    # TODO: put request
    pass

mqttc = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)
mqttc.on_connect = on_connect
mqttc.on_message = on_message

mqttc.connect("localhost", 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
# mqttc.loop_forever()

if __name__ == "__main__":
    print(read_nodes())
    print(read_allocatable_cpu())
    print(read_allocatable_memory())
    print(read_node_by_id("edge-0"))
    print(update_allocatable_cpu("edge-0", "shares", 8000))
    print(read_allocatable_cpu())
    print(update_allocatable_memory("edge-0", "size", 8192))
    print(read_allocatable_memory())
