# SummerSOC 2024

## API Requests

### IDLE

Assumptions:

- PULCEO is exposed on `localhost:8081`
- You have created a valid service principal for Microsoft Azure [Create an Azure service principal with Azure CLI](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?tabs=bash)

Many resources, for example, node and applications are created asynchronously.
That means that some values are either PENDING or null in some responses.
The values are updated as soon as the node or applications is fully initialized.  

#### Create an On-prem provider for computational resources

A default on-prem provider is automatically created when PULCEO is started.
The name is _default_.

Request:
```bash
curl --request GET \
  --url http://localhost:8081/api/v1/providers/default \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
```

Response:
```json
{
	"uuid": "853fae40-6d41-4d8f-80c9-22727727a4c2",
	"providerName": "default",
	"providerType": "ON_PREM"
}
```

#### Create Provider "azure-provider" (Microsoft Azure)

Request:
```bash
curl --request POST \
  --url http://localhost:8081/api/v1/providers \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
	"providerName": "azure-provider",
	"providerType": "AZURE",
	"clientId": "00000000-00000000-00000000-00000000",
	"clientSecret": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
	"tenantId": "00000000-00000000-00000000-00000000",
	"subscriptionId": "00000000-00000000-00000000-00000000"
  }'
```

Response:
```json
{
  "uuid": "00000000-00000000-00000000-00000000",
  "providerName": "azure-provider",
  "providerType": "AZURE"
}
```

#### Create Node "cloud1" (Microsoft Azure)


Request:

```json
{
	"nodeType":"AZURE",
	"providerName":"azure-provider",
	"name":"fog2",
	"type":"fog",
	"cpu":"2",
	"memory":"4",
	"region":"germanywestcentral",
	"tags": []
}
```

Response:

```json
{
	"uuid": "934bc9f9-33c6-4e40-a186-017ea28f80b8",
	"providerName": "azure-provider",
	"hostname": "PENDING",
	"pnaUUID": "00000000-0000-0000-0000-000000000000",
	"node": {
		"name": "fog2",
		"type": "FOG",
		"layer": 1,
		"role": "WORKLOAD",
		"group": "",
		"country": "Germany",
		"state": "Hessen",
		"city": "Frankfurt",
		"longitude": 8.682127,
		"latitude": 50.110924,
		"tags": []
	}
}
```

#### Create Node "fog1" (Microsoft Azure)

Request:

```json
{
	"nodeType":"AZURE",
	"providerName":"azure-provider",
	"name":"fog1",
	"type":"fog",
	"cpu":"2",
	"memory":"8",
	"region":"francecentral",
	"tags": []
}
```

Response:

```json
{
	"uuid": "e1076174-380a-47e4-a468-b9fd1b0ea309",
	"providerName": "azure-provider",
	"hostname": "PENDING",
	"pnaUUID": "00000000-0000-0000-0000-000000000000",
	"node": {
		"name": "fog1",
		"type": "FOG",
		"layer": 1,
		"role": "WORKLOAD",
		"group": "",
		"country": "France",
		"state": "Paris (chef-lieu)",
		"city": "Paris",
		"longitude": 2.373,
		"latitude": 46.3772,
		"tags": []
	}
}
```

#### Create Node "fog2" (Microsoft Azure)

Request:

```json
{
	"nodeType":"AZURE",
	"providerName":"azure-provider",
	"name":"fog2",
	"type":"fog",
	"cpu":"2",
	"memory":"4",
	"region":"germanywestcentral",
	"tags": []
}
```

Response:

```json
{
	"uuid": "934bc9f9-33c6-4e40-a186-017ea28f80b8",
	"providerName": "azure-provider",
	"hostname": "PENDING",
	"pnaUUID": "00000000-0000-0000-0000-000000000000",
	"node": {
		"name": "fog2",
		"type": "FOG",
		"layer": 1,
		"role": "WORKLOAD",
		"group": "",
		"country": "Germany",
		"state": "Hessen",
		"city": "Frankfurt",
		"longitude": 8.682127,
		"latitude": 50.110924,
		"tags": []
	}
}
```

#### Create Node "fog3" (On-premises)

Request:

```json
{
	"nodeType":"ONPREM",
	"type": "fog",
	"name": "fog3",
	"providerName":"default",
	"hostname":"h5138.pi.uni-bamberg.de",
	"pnaInitToken":"***",
	"country": "Germany",
	"state": "Bavaria",
	"city": "Bamberg",
	"latitude": 49.9036,
	"longitude": 10.8700,
	"tags": []
}
```

Response:

```json
{
	"uuid": "56718563-3580-498e-8441-8aa7d92f7654",
	"providerName": "default",
	"hostname": "h5138.pi.uni-bamberg.de",
	"pnaUUID": "6dc8fca9-d1a6-4436-b1c9-122bbaa55235",
	"node": {
		"name": "fog3",
		"type": "FOG",
		"layer": 1,
		"role": "WORKLOAD",
		"group": "",
		"country": "Germany",
		"state": "Bavaria",
		"city": "Bamberg",
		"longitude": 10.87,
		"latitude": 49.9036,
		"tags": []
	}
}
```

#### Update Node "fog3 (On-premises)

Request: `PATCH /api/v1/nodes/fog3`

```json
{
	"key": "layer",
	"value": "2"
}
```

Response:

```json
{
	"name": "fog3",
	"type": "FOG",
	"layer": 2,
	"role": "WORKLOAD",
	"group": "",
	"country": "Germany",
	"state": "Bavaria",
	"city": "Bamberg",
	"longitude": 10.87,
	"latitude": 49.9036,
	"tags": []
}
```

#### Create Link fog3->fog1

Request:

```json
{
    "linkType": "NODE_LINK",
    "name": "fog3-fog1",
    "srcNodeId": "fog3",
    "destNodeId": "fog1"
}
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "85110ccf-d12d-44c7-bb2e-17105ef34b62",
	"remoteNodeLinkUUID": "362d00ae-5cec-4193-9ff9-a8a0c5f84c6e",
	"name": "fog3-fog1",
	"srcNodeUUID": "56718563-3580-498e-8441-8aa7d92f7654",
	"destNodeUUID": "e1076174-380a-47e4-a468-b9fd1b0ea309"
}
```

#### Create Link fog3->fog2

Request:

```json
{
    "linkType": "NODE_LINK",
    "name": "fog3-fog2",
    "srcNodeId": "fog3",
    "destNodeId": "fog2"
}
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "7c3a7888-2aca-4e42-95d4-36621b1272ff",
	"remoteNodeLinkUUID": "62bb1805-1b08-4193-b225-10a4d68d2d08",
	"name": "fog3-fog2",
	"srcNodeUUID": "56718563-3580-498e-8441-8aa7d92f7654",
	"destNodeUUID": "934bc9f9-33c6-4e40-a186-017ea28f80b8"
}
```

#### Create Link fog1->cloud1

Request:

```json
{
    "linkType": "NODE_LINK",
    "name": "fog1-cloud1",
    "srcNodeId": "fog1",
    "destNodeId": "cloud1"
}
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "e84b3aa8-687c-44a6-b109-c6a3f68ec922",
	"remoteNodeLinkUUID": "b2b4fde1-98cd-4a01-a1cb-e41cca958622",
	"name": "fog1-cloud1",
	"srcNodeUUID": "e1076174-380a-47e4-a468-b9fd1b0ea309",
	"destNodeUUID": "4c37dcca-998d-49a4-861b-49b0ef91516d"
}
```
#### Create Link fog2->cloud1

Request:

```json
{
    "linkType": "NODE_LINK",
    "name": "fog2-cloud1",
    "srcNodeId": "fog2",
    "destNodeId": "cloud1"
}
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "a16dcf8c-b8e9-4b62-8bc0-4dafe38c74a2",
	"remoteNodeLinkUUID": "c7a945de-945c-4ecc-884f-b6393dc53bff",
	"name": "fog2-cloud1",
	"srcNodeUUID": "934bc9f9-33c6-4e40-a186-017ea28f80b8",
	"destNodeUUID": "4c37dcca-998d-49a4-861b-49b0ef91516d"
}
```

#### Create Link cloud1->fog1

Request:

```json
{
    "linkType": "NODE_LINK",
    "name": "cloud1-fog1",
    "srcNodeId": "cloud1",
    "destNodeId": "fog1"
}
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "67fbfccf-f470-4a82-81f0-731480be934b",
	"remoteNodeLinkUUID": "4df64c53-0f35-4143-bce6-d726eff899c2",
	"name": "cloud1-fog1",
	"srcNodeUUID": "4c37dcca-998d-49a4-861b-49b0ef91516d",
	"destNodeUUID": "e1076174-380a-47e4-a468-b9fd1b0ea309"
}
```

#### Create Link cloud1->fog2

Request:

```json
{
    "linkType": "NODE_LINK",
    "name": "cloud1-fog2",
    "srcNodeId": "cloud1",
    "destNodeId": "fog2"
}
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "532030fd-9c23-44d9-9df7-ab62a90727ed",
	"remoteNodeLinkUUID": "45c33b76-37b8-484b-8b9f-7aec51a36be6",
	"name": "cloud1-fog2",
	"srcNodeUUID": "4c37dcca-998d-49a4-861b-49b0ef91516d",
	"destNodeUUID": "934bc9f9-33c6-4e40-a186-017ea28f80b8"
}
```

#### Create Node Metric Request CPU

Request:

```json
{
	"resourceId": "*", 
	"type":"cpu-util",
	"recurrence":"60",
	"enabled":"true"
}
```

Response:

```json
{
	"uuid": "99f18b89-5433-4e6a-99aa-d2269126472d",
	"remoteMetricRequestUUID": "dc1c240b-6531-496d-b9c0-0b5b50d2e011",
	"linkUUID": "f95a7d9c-8cf3-4e02-a50c-82583a335de1",
	"type": "cpu-util",
	"recurrence": "60",
	"enabled": true
}
```

#### Create Node Metric Request Memory

Request:

```json
{
	"resourceId": "*", 
	"type":"mem-util",
	"recurrence":"60",
	"enabled":"true"
}
```

Response:

```json
{
	"uuid": "c8dc7d3b-9c0c-4553-859d-935aadfd9762",
	"remoteMetricRequestUUID": "9fd5a92e-4eff-4110-8adc-9430548664dc",
	"linkUUID": "f95a7d9c-8cf3-4e02-a50c-82583a335de1",
	"type": "mem-util",
	"recurrence": "60",
	"enabled": true
}
```

#### Create Node Metric Request Storage

Request:

```json
{
	"resourceId": "*", 
	"type":"storage-util",
	"recurrence":"60",
	"enabled":"true"
}
```

Response:

```json
{
	"uuid": "9e5f413d-5bc8-419d-a1ff-3629e0b3a9ff",
	"remoteMetricRequestUUID": "676dd607-0ea9-4cd0-9881-fc4ccdab098a",
	"linkUUID": "f95a7d9c-8cf3-4e02-a50c-82583a335de1",
	"type": "storage-util",
	"recurrence": "60",
	"enabled": true
}
```

#### Create Node Metric Request Network

Request:

```json
{
	"resourceId": "*", 
	"type":"net-util",
	"recurrence":"60",
	"enabled":"true"
}
```

Response:

```json
{
	"uuid": "d0829f4d-acd1-4c9d-bd6e-f6a608cdcd5f",
	"remoteMetricRequestUUID": "8e5010bb-88c9-45e3-a8c0-f545e6a4fd8a",
	"linkUUID": "f95a7d9c-8cf3-4e02-a50c-82583a335de1",
	"type": "net-util",
	"recurrence": "60",
	"enabled": true
}
```

#### Create Link Metric Request ICMP

Request:

```json
{
	"type":"icmp-rtt",
	"linkId":"*",
	"recurrence":"3600"
}

```

Response:

```json
{
	"uuid": "a5be92e6-1743-4167-8eef-f87e95b47f42",
	"remoteMetricRequestUUID": "9d5500de-166d-4602-a6bf-fa6a53b483c5",
	"linkUUID": "45c33b76-37b8-484b-8b9f-7aec51a36be6",
	"type": "icmp-rtt",
	"recurrence": "3600",
	"enabled": true
}
```

#### Create Link Metric Request TCP BW

Request:

```json
{
	"type":"tcp-bw",
	"linkId":"*",
	"recurrence":"3600",
	"bitrate": 65,
	"initialDelay": 30
}
```

Response:

```json
{
	"uuid": "c25fdefe-81c5-433b-bb79-ac009b1a7974",
	"remoteMetricRequestUUID": "ec2d8e88-7b75-4f18-b40d-5ceda769a9a5",
	"linkUUID": "45c33b76-37b8-484b-8b9f-7aec51a36be6",
	"type": "tcp-bw",
	"recurrence": "3600",
	"enabled": true
}
```

#### Create Link Metric Request UDP BW

Request:

```json
{
	"type":"udp-bw",
	"linkId":"*",
	"recurrence":"3600",
	"bitrate": 65,
	"initialDelay": 30
}
```

Response:

```json
{
	"uuid": "900ca980-4655-41e4-9810-1264bf0a4ee7",
	"remoteMetricRequestUUID": "fd34dc7e-a302-4511-bdec-e93de5d78742",
	"linkUUID": "45c33b76-37b8-484b-8b9f-7aec51a36be6",
	"type": "udp-bw",
	"recurrence": "3600",
	"enabled": true
}
```

### LOAD

Same step as with `IDLE`, `LOAD` just extends it.

#### Create Application eis on cloud1

##### Allocate CPU resources on cloud1

Request: `GET /api/v1/nodes/cloud1/cpu`

Response:

```json
{
	"uuid": "db380a84-194a-460c-a93d-248f94fdaeff",
	"nodeUUID": "4c37dcca-998d-49a4-861b-49b0ef91516d",
	"nodeName": "cloud1",
	"cpuCapacity": {
		"modelName": "Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz",
		"cores": 4,
		"threads": 4,
		"bogoMIPS": 4589.37,
		"minimalFrequency": 2294.685,
		"averageFrequency": 2294.685,
		"maximalFrequency": 2294.685,
		"shares": 4000,
		"slots": 0.0,
		"mips": 4589.37,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz",
		"cores": 4,
		"threads": 4,
		"bogoMIPS": 4589.37,
		"minimalFrequency": 2294.685,
		"averageFrequency": 2294.685,
		"maximalFrequency": 2294.685,
		"shares": 4000,
		"slots": 0.0,
		"mips": 4589.37,
		"gflop": 0.0
	}
}
```

Request: `PATCH /api/v1/nodes/cloud1/cpu/allocatable`

```json
{
	"key": "shares",
	"value": 3000
}
```

Response:

```json
{
	"uuid": "db380a84-194a-460c-a93d-248f94fdaeff",
	"nodeUUID": "4c37dcca-998d-49a4-861b-49b0ef91516d",
	"nodeName": "cloud1",
	"cpuCapacity": {
		"modelName": "Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz",
		"cores": 4,
		"threads": 4,
		"bogoMIPS": 4589.37,
		"minimalFrequency": 2294.685,
		"averageFrequency": 2294.685,
		"maximalFrequency": 2294.685,
		"shares": 4000,
		"slots": 0.0,
		"mips": 4589.37,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz",
		"cores": 4,
		"threads": 4,
		"bogoMIPS": 4589.37,
		"minimalFrequency": 2294.685,
		"averageFrequency": 2294.685,
		"maximalFrequency": 2294.685,
		"shares": 3000,
		"slots": 0.0,
		"mips": 4589.37,
		"gflop": 0.0
	}
}
```

##### Allocate Memory resources on cloud1

Request: `GET /api/v1/nodes/cloud1/memory`

Response:

```json
{
	"uuid": "ef7379fa-5f3e-425a-bcd0-05bf8e8124c9",
	"nodeUUID": "4c37dcca-998d-49a4-861b-49b0ef91516d",
	"nodeName": "cloud1",
	"memoryCapacity": {
		"size": 15.616077,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 15.616077,
		"slots": 0
	}
}
```

Request: `PATCH /api/v1/nodes/cloud1/memory/allocatable`

```json
{
	"key": "size",
	"value": 14.61
}
```

Response:

```json
{
	"uuid": "ef7379fa-5f3e-425a-bcd0-05bf8e8124c9",
	"nodeUUID": "4c37dcca-998d-49a4-861b-49b0ef91516d",
	"nodeName": "cloud1",
	"memoryCapacity": {
		"size": 15.616077,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 14.61,
		"slots": 0
	}
}
```

##### Create Application eis on "cloud1"

Request: `POST /api/v1/applications`

Request:

```json
{
	"nodeId": "cloud1",
	"name": "edge-iot-simulator",
	"applicationComponents": [
		{
			"name": "component-eis",
			"image": "ghcr.io/spboehm/edge-iot-simulator:v1.1.0",
			"port": 80,
			"protocol": "HTTPS",
			"applicationComponentType": "PUBLIC",
			"environmentVariables": {
				"MQTT_SERVER_NAME":"{{ _.MQTT_HOST }}",
				"MQTT_PORT":"8883",
				"MQTT_TLS":"True",
				"MQTT_USERNAME": "{{ _.MQTT_USER }}",
				"MQTT_PASSWORD": "{{ _.MQTT_PASSWORD }}",
				"MQTT_CLIENT_ID":"cloud1-edge-iot-simulator",
				"WEB_PORT": 80
			}
		}
	]
}
```

Response:

```json
{
	"applicationUUID": "8896aa59-d6eb-45ff-9083-40f7f3b24bf3",
	"remoteApplicationUUID": "00000000-0000-0000-0000-000000000000",
	"nodeId": "4c37dcca-998d-49a4-861b-49b0ef91516d",
	"endpoint": "https://null:80",
	"name": "cloud1-edge-iot-simulator",
	"applicationComponents": [
		{
			"applicationComponentUUID": "b267bda5-c2eb-494c-b306-5949c9979d0f",
			"name": "component-eis",
			"endpoint": "https://null:80",
			"image": "ghcr.io/spboehm/edge-iot-simulator:v1.1.0",
			"port": 80,
			"protocol": "HTTPS",
			"applicationComponentType": "PUBLIC"
		}
	]
}
```

Same procedure for all other nodes.

#### Create Applications Metric Request CPU

Request: `POST /api/v1/metric-requests`

```json
{
	"resourceId": "*", 
	"resourceType": "application",
	"type":"cpu-util",
	"recurrence":"30",
	"enabled":"true"
}
```

Response:

```json
{
	"uuid": "8809178f-c414-4b33-8af3-96ee1510dfa1",
	"remoteMetricRequestUUID": "db7c7b67-b2a2-42b5-96cb-55aa119b6527",
	"linkUUID": "5775d654-2aff-45ee-86ab-e7abe942af72",
	"type": "cpu-util",
	"recurrence": "30",
	"enabled": true
}
```

#### Create Applications Metric Request Memory

Request: `POST /api/v1/metric-requests`

```json
{
	"resourceId": "*", 
	"resourceType": "application",
	"type":"mem-util",
	"recurrence":"30",
	"enabled":"true"
}
```

Response:

```json
{
	"uuid": "25d777c2-2260-4e7e-8c53-03cf92afabb3",
	"remoteMetricRequestUUID": "64c84302-9aa4-4216-a518-6035ffae350b",
	"linkUUID": "5775d654-2aff-45ee-86ab-e7abe942af72",
	"type": "mem-util",
	"recurrence": "30",
	"enabled": true
}
```

#### Create Applications Metric Request Storage

Request: `POST /api/v1/metric-requests`

```json
{
	"resourceId": "*", 
	"resourceType": "application",
	"type":"storage-util",
	"recurrence":"30",
	"enabled":"true"
}
```

Response:

```json
{
	"uuid": "e8b9bd32-ffe3-4f29-9d4c-1eb365f080f9",
	"remoteMetricRequestUUID": "d2c58473-f18e-415a-b67f-2905503fe911",
	"linkUUID": "5775d654-2aff-45ee-86ab-e7abe942af72",
	"type": "storage-util",
	"recurrence": "30",
	"enabled": true
}
```

#### Create Applications Metric Request Network

Request: `POST /api/v1/metric-requests`

```json
{
	"resourceId": "*", 
	"resourceType": "application",
	"type":"net-util",
	"recurrence":"30",
	"enabled":"true"
}
```

```json
{
	"uuid": "d7cd8d27-8684-4b4c-a5f7-93b3f8aa210d",
	"remoteMetricRequestUUID": "b841444a-3b72-40be-b268-64dfca26e2c7",
	"linkUUID": "5775d654-2aff-45ee-86ab-e7abe942af72",
	"type": "net-util",
	"recurrence": "30",
	"enabled": true
}
```