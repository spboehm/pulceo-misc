# SOSE 2024

## API Requests

### PROD

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

#### Create Provider "azure-provider" (Microsoft Azure) (#1)

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

#### Further cloud providers (#1)

tbd.

#### Create Node "cloud1" (Microsoft Azure) (#2)

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/nodes \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
	"nodeType":"AZURE",
	"providerName":"azure-provider",
	"name":"cloud1",
	"type":"cloud",
	"cpu":"2",
	"mem":"4",
	"region":"westeurope",
	"tags": [
		{
			"key": "properties",
			"value": "Java, .NET, Ruby, MySQL"
		}
	]
  }'
```

Response:

```json
{
  "uuid": "d696dbd2-15a9-4cc0-8b01-376255a41ff3",
  "providerName": "azure-provider",
  "hostname": "pulceo-node-ede1859139.westeurope.cloudapp.azure.com",
  "pnaUUID": "e669e920-220a-409f-9866-751225082ab3",
  "node": {
    "name": "cloud1",
    "type": "CLOUD",
    "layer": 1,
    "role": "WORKLOAD",
    "group": "",
    "country": "Netherlands",
    "state": "Noord-Holland",
    "city": "Schiphol",
    "longitude": 4.9,
    "latitude": 52.3667,
    "tags": [
      {
        "key": "properties",
        "value": "Java, .NET, Ruby, MySQL"
      }
    ]
  }
}
```

#### Create Node "cloud2" (Microsoft Azure) (#2)

Request

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/nodes \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
	"nodeType":"AZURE",
	"providerName":"azure-provider",
	"name":"cloud2",
	"type":"cloud",
	"cpu":"2",
	"mem":"4",
	"region":"westus",
	"tags": [
		{
			"key": "properties",
			"value": "C++, Spark, MySQL, Linux, .NET, Python"
		}
	]
  }'
```

Response:

```json
{
  "uuid": "141901c3-4305-45e5-9bc9-0b5de5af22d5",
  "providerName": "azure-provider",
  "hostname": "pulceo-node-e031859180.westus.cloudapp.azure.com",
  "pnaUUID": "a9012402-a7bc-422c-ade0-08a547e0ff25",
  "node": {
    "name": "cloud2",
    "type": "CLOUD",
    "layer": 1,
    "role": "WORKLOAD",
    "group": "",
    "country": "USA",
    "state": "California",
    "city": "San Francisco",
    "longitude": -119.852,
    "latitude": 47.233,
    "tags": [
      {
        "key": "properties",
        "value": "C++, Spark, MySQL, Linux, .NET, Python"
      }
    ]
  }
}
```

#### Create Node "fog1" (On-premises) (#2)

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/nodes \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
	"nodeType":"ONPREM",
	"type": "fog",
	"name": "fog1",
	"providerName":"default",
	"hostname":"h5138.pi.uni-bamberg.de",
	"pnaInitToken":"fnvAmtJre13rgEZ2AA0g3AKAtH0mvVi0NmEFZGD1mtEVi6WfacuqdejiA8vtPv47C7SSuHDqVZvT",
	"country": "Germany",
	"state": "Bavaria",
	"city": "Bamberg",
	"latitude": 49.9036,
	"longitude": 10.8700,
	"tags": [
		{
			"key": "properties",
			"value": "C++, Linux, Python"
		}
	]
  }'
```

Response:

```bash
{
"uuid": "262dbecb-ae4b-442c-9751-39acd183e586",
"providerName": "default",
"hostname": "h5138.pi.uni-bamberg.de",
"pnaUUID": "6dc8fca9-d1a6-4436-b1c9-122bbaa55235",
"node": {
  "name": "fog1",
  "type": "FOG",
  "layer": 1,
  "role": "WORKLOAD",
  "group": "",
  "country": "Germany",
  "state": "Bavaria",
  "city": "Bamberg",
  "longitude": 10.87,
  "latitude": 49.9036,
  "tags": [
    {
      "key": "properties",
      "value": "C++, Linux, Python"
    }
  ]
}
```

#### Create Node "fog2" (On-premises) (#2)

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/nodes \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
	"nodeType":"ONPREM",
	"type": "fog",
	"name": "fog2",
	"providerName":"default",
	"hostname":"h5136.pi.uni-bamberg.de",
	"pnaInitToken":"fnvAmtJre13rgEZ2AA0g3AKAtH0mvVi0NmEFZGD1mtEVi6WfacuqdejiA8vtPv47C7SSuHDqVZvT",
	"country": "Germany",
	"state": "Bavaria",
	"city": "Bamberg",
	"latitude": 49.9036,
	"longitude": 10.8700,
	"tags": [
		{
			"key": "properties",
			"value": "MySQL, .NET, C++, Python"
		}
	]
  }'
```

Response:

```bash
{
"uuid": "cf230cd5-d8c8-4537-8e7c-5da23973f4ce",
"providerName": "default",
"hostname": "h5136.pi.uni-bamberg.de",
"pnaUUID": "265916fb-2092-40ee-9528-b32f4ea911a1",
"node": {
  "name": "fog2",
  "type": "FOG",
  "layer": 1,
  "role": "WORKLOAD",
  "group": "",
  "country": "Germany",
  "state": "Bavaria",
  "city": "Bamberg",
  "longitude": 10.87,
  "latitude": 49.9036,
  "tags": [
    {
      "key": "properties",
      "value": "MySQL, .NET, C++, Python"
    }
  ]
}
}
```

#### Create Node "fog3" (On-premises) (#2)

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/nodes \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data '{
	"nodeType":"ONPREM",
	"type": "fog",
	"name": "fog3",
	"providerName":"default",
	"hostname":"h5137.pi.uni-bamberg.de",
	"pnaInitToken":"fnvAmtJre13rgEZ2AA0g3AKAtH0mvVi0NmEFZGD1mtEVi6WfacuqdejiA8vtPv47C7SSuHDqVZvT",
	"country": "Germany",
	"state": "Bavaria",
	"city": "Bamberg",
	"latitude": 49.9036,
	"longitude": 10.8700,
	"tags": [
		{
			"key": "properties",
			"value": "C++, Linux, Python"
		}
	]
  }'
```

Response:

```bash
{
    "uuid": "b2dd336a-3d28-47c3-9469-673023947939",
    "providerName": "default",
    "hostname": "h5137.pi.uni-bamberg.de",
    "pnaUUID": "be6f0093-ebff-4494-8123-6ab50d3ae8e5",
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
      "tags": [
        {
          "key": "properties",
          "value": "C++, Linux, Python"
        }
      ]
    }
```

#### Create Links (#3)

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "fog3-fog2",
    "srcNodeId": "fog3",
    "destNodeId": "fog2"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "0ef2c36e-648f-4c44-b14c-14ab571df0c8",
	"remoteNodeLinkUUID": "ee2ce748-7c2a-44af-90df-6d99760745f4",
	"name": "fog3-fog2",
	"srcNodeUUID": "b86a550b-c300-4203-acde-4e4a017ff667",
	"destNodeUUID": "38a7d459-efee-44fa-b96a-dfefb0b51ac7"
}
```

Request;

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "fog1-fog3",
    "srcNodeId": "fog1",
    "destNodeId": "fog3"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "ee404b7c-34ad-4d16-8e60-047b3b515059",
	"remoteNodeLinkUUID": "0381fc5f-fc69-497e-8952-eef4db37bdce",
	"name": "fog1-fog3",
	"srcNodeUUID": "48e71b4b-dc7b-4eb0-85d3-b954c3b60d31",
	"destNodeUUID": "b86a550b-c300-4203-acde-4e4a017ff667"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "fog2-cloud2",
    "srcNodeId": "fog2",
    "destNodeId": "cloud2"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "5020baf6-4b12-4c7c-a1fe-df159e93adff",
	"remoteNodeLinkUUID": "08bdc520-715d-40e2-b393-dcf97d4afbd5",
	"name": "fog2-cloud2",
	"srcNodeUUID": "38a7d459-efee-44fa-b96a-dfefb0b51ac7",
	"destNodeUUID": "e9b048c2-3a7f-469e-8ae0-3fe410bcb6c5"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "fog2-cloud1",
    "srcNodeId": "fog2",
    "destNodeId": "cloud1"
}'
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "fog3-cloud2",
    "srcNodeId": "fog3",
    "destNodeId": "cloud2"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "73b6cfc7-f589-44c0-bd4b-fff4ab02683e",
	"remoteNodeLinkUUID": "2e7abd7e-3ce7-4ade-bce1-a0c5178889bc",
	"name": "fog3-cloud2",
	"srcNodeUUID": "b86a550b-c300-4203-acde-4e4a017ff667",
	"destNodeUUID": "e9b048c2-3a7f-469e-8ae0-3fe410bcb6c5"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "fog3-cloud1",
    "srcNodeId": "fog3",
    "destNodeId": "cloud1"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "0420435a-3db3-448c-b2fc-08e2e3ee6efb",
	"remoteNodeLinkUUID": "a0032bf4-51f0-49e5-b56c-29f6cfb78c9d",
	"name": "fog3-cloud1",
	"srcNodeUUID": "b86a550b-c300-4203-acde-4e4a017ff667",
	"destNodeUUID": "ea8aca7b-8eff-4ebb-8df9-4e87185a9e89"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "fog1-cloud2",
    "srcNodeId": "fog1",
    "destNodeId": "cloud2"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "a82b6ab1-0da7-4185-9126-2457dd1a0b3f",
	"remoteNodeLinkUUID": "3210d153-fe38-4fcc-bcb4-0b887e6682a6",
	"name": "fog1-cloud2",
	"srcNodeUUID": "48e71b4b-dc7b-4eb0-85d3-b954c3b60d31",
	"destNodeUUID": "e9b048c2-3a7f-469e-8ae0-3fe410bcb6c5"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "fog1-cloud1",
    "srcNodeId": "fog1",
    "destNodeId": "cloud1"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "83a45a2e-c5e2-4b86-9c32-7024a0f25a44",
	"remoteNodeLinkUUID": "703244a1-d52c-46f2-9c19-10e996825342",
	"name": "fog1-cloud1",
	"srcNodeUUID": "48e71b4b-dc7b-4eb0-85d3-b954c3b60d31",
	"destNodeUUID": "ea8aca7b-8eff-4ebb-8df9-4e87185a9e89"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "cloud2-fog2",
    "srcNodeId": "cloud2",
    "destNodeId": "fog2"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "cdc9c656-7a5f-439c-930a-0adfc8459602",
	"remoteNodeLinkUUID": "c582d2e8-2e72-4acc-aeb1-9bf41a8041b5",
	"name": "cloud2-fog2",
	"srcNodeUUID": "e9b048c2-3a7f-469e-8ae0-3fe410bcb6c5",
	"destNodeUUID": "38a7d459-efee-44fa-b96a-dfefb0b51ac7"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "cloud2-fog3",
    "srcNodeId": "cloud2",
    "destNodeId": "fog3"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "ea5773fd-81d2-4159-aaf3-8331c6ef42f9",
	"remoteNodeLinkUUID": "80d8157d-87b1-4e30-a0b4-53e9398623fa",
	"name": "cloud2-fog3",
	"srcNodeUUID": "e9b048c2-3a7f-469e-8ae0-3fe410bcb6c5",
	"destNodeUUID": "b86a550b-c300-4203-acde-4e4a017ff667"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "cloud2-fog1",
    "srcNodeId": "cloud2",
    "destNodeId": "fog1"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "8a675240-5efd-481d-801f-fe816fdd3a1c",
	"remoteNodeLinkUUID": "9f261acd-4adb-477f-9192-097125fc7a35",
	"name": "cloud2-fog1",
	"srcNodeUUID": "e9b048c2-3a7f-469e-8ae0-3fe410bcb6c5",
	"destNodeUUID": "48e71b4b-dc7b-4eb0-85d3-b954c3b60d31"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "cloud1-fog3",
    "srcNodeId": "cloud1",
    "destNodeId": "fog3"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "e21e5cc4-13ec-4bad-aec5-c13bf0436725",
	"remoteNodeLinkUUID": "36a015fd-3c08-4fbc-a1e1-1638c42d3185",
	"name": "cloud1-fog3",
	"srcNodeUUID": "ea8aca7b-8eff-4ebb-8df9-4e87185a9e89",
	"destNodeUUID": "b86a550b-c300-4203-acde-4e4a017ff667"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "cloud1-fog2",
    "srcNodeId": "cloud1",
    "destNodeId": "fog2"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "ea9c3f0d-2736-4fe0-9fd7-956c043a7678",
	"remoteNodeLinkUUID": "308fd90f-1000-4512-82ab-c172dfcddd8e",
	"name": "cloud1-fog2",
	"srcNodeUUID": "ea8aca7b-8eff-4ebb-8df9-4e87185a9e89",
	"destNodeUUID": "38a7d459-efee-44fa-b96a-dfefb0b51ac7"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "cloud1-fog1",
    "srcNodeId": "cloud1",
    "destNodeId": "fog1"
}'
```

Response:

```bash
{
	"linkType": "NODE_LINK",
	"linkUUID": "2cc9c4f8-62c7-4938-9f9b-9bcd36e06518",
	"remoteNodeLinkUUID": "e083769d-ff43-4e39-bcb2-33f461f019e4",
	"name": "cloud1-fog1",
	"srcNodeUUID": "ea8aca7b-8eff-4ebb-8df9-4e87185a9e89",
	"destNodeUUID": "48e71b4b-dc7b-4eb0-85d3-b954c3b60d31"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/links \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
    "linkType": "NODE_LINK",
    "name": "fog1-fog2",
    "srcNodeId": "fog1",
    "destNodeId": "fog2"
}'
```

Response:

```json
{
	"linkType": "NODE_LINK",
	"linkUUID": "f583acd0-da22-4495-a868-6da1513f2833",
	"remoteNodeLinkUUID": "38e8ef71-4102-48d2-81eb-2a35b938c868",
	"name": "fog1-fog2",
	"srcNodeUUID": "48e71b4b-dc7b-4eb0-85d3-b954c3b60d31",
	"destNodeUUID": "38a7d459-efee-44fa-b96a-dfefb0b51ac7"
}
```

#### Metric Requests (#4)

##### Batch Metric Requests for Nodes

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"resourceId": "*", 
	"type":"cpu-util",
	"recurrence":"60",
	"enabled":"true"
}'
```

Response:

```json
{
	"uuid": "248b9d76-eef4-497f-a7c7-6ddf888fdfa7",
	"remoteMetricRequestUUID": "91bb5560-4147-418a-b6a3-7e7ced483afb",
	"linkUUID": "0d788df6-f35b-4042-a56c-b2910611891e",
	"type": "cpu-util",
	"recurrence": "60",
	"enabled": true
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"resourceId": "*", 
	"type":"mem-util",
	"recurrence":"60",
	"enabled":"true"
}'
```

Response:

```json
{
	"uuid": "e258eb33-c43c-4fbf-bd93-a1595b455149",
	"remoteMetricRequestUUID": "b6723a8b-bef6-4745-a289-91fa9e74da4f",
	"linkUUID": "0d788df6-f35b-4042-a56c-b2910611891e",
	"type": "mem-util",
	"recurrence": "60",
	"enabled": true
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"resourceId": "*", 
	"type":"storage-util",
	"recurrence":"60",
	"enabled":"true"
}'
```

Response:

```json
{
	"uuid": "13d6c241-8ea7-4d9b-b554-937b690a043c",
	"remoteMetricRequestUUID": "69a66092-4f0a-412e-a54e-5f726de3bb3a",
	"linkUUID": "0d788df6-f35b-4042-a56c-b2910611891e",
	"type": "storage-util",
	"recurrence": "60",
	"enabled": true
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"resourceId": "*", 
	"type":"net-util",
	"recurrence":"60",
	"enabled":"true"
}'
```

Response:

```json
{
	"uuid": "71550232-29a8-4e1c-976d-e56c5cb902ea",
	"remoteMetricRequestUUID": "d903c8e0-35dc-4f01-9b04-2e6a4a64209c",
	"linkUUID": "0d788df6-f35b-4042-a56c-b2910611891e",
	"type": "net-util",
	"recurrence": "60",
	"enabled": true
}
```

##### Batch Metric Requests for Links

Request:
  
```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"type":"icmp-rtt",
	"linkId":"*",
	"recurrence":"3600"
}'
```

Response:

```json
{
	"uuid": "a60ecd2d-5776-4a76-98ad-12cc853a3379",
	"remoteMetricRequestUUID": "974e24b2-f7cd-44fd-a85b-8d32eafc6b83",
	"linkUUID": "e083769d-ff43-4e39-bcb2-33f461f019e4",
	"type": "icmp-rtt",
	"recurrence": "3600",
	"enabled": true
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"type":"tcp-bw",
	"linkId":"*",
	"recurrence":"3600",
	"bitrate": 65,
	"initialDelay": 30
}'
```

Response:

```json
{
	"uuid": "538cbc74-b7f8-486a-af43-060be5f22df3",
	"remoteMetricRequestUUID": "75b37a0b-2057-44d0-a73b-ec93fc41908c",
	"linkUUID": "e083769d-ff43-4e39-bcb2-33f461f019e4",
	"type": "tcp-bw",
	"recurrence": "3600",
	"enabled": true
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"type":"udp-bw",
	"linkId":"*",
	"recurrence":"3600",
	"bitrate": 65,
	"initialDelay": 30
}'
```

Response:

```json
{
	"uuid": "b3f0ff31-79a4-474d-94a7-d94b730882a9",
	"remoteMetricRequestUUID": "6b13c4c4-ef8c-4e75-8b10-63674a0b7add",
	"linkUUID": "e083769d-ff43-4e39-bcb2-33f461f019e4",
	"type": "udp-bw",
	"recurrence": "3600",
	"enabled": true
}
```

##### Non-Batch Metric Requests for Links

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"type":"icmp-rtt",
	"linkId":"fog1-fog2",
	"recurrence":"3600"
}'
```

Response:

```json
{
	"uuid": "b9e3a95c-97ae-4dc4-947c-e1111f0b123c",
	"remoteMetricRequestUUID": "3d78eccd-16be-438b-8dff-58ca499f67ea",
	"linkUUID": "38e8ef71-4102-48d2-81eb-2a35b938c868",
	"type": "icmp-rtt",
	"recurrence": "3600",
	"enabled": true
}
```

Request:
  
```bash
{
	"type":"tcp-bw",
	"linkId":"fog1-fog2",
	"recurrence":"3600",
	"bitrate": 100,
	"initialDelay": 30
}
```

Response:

```json
{
	"uuid": "7d155d43-fadb-4b38-96a1-cebe673189fa",
	"remoteMetricRequestUUID": "56c51141-d501-4ccc-9d82-a42813bb33fa",
	"linkUUID": "38e8ef71-4102-48d2-81eb-2a35b938c868",
	"type": "tcp-bw",
	"recurrence": "3600",
	"enabled": true
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"type":"udp-bw",
	"linkId":"fog1-fog2",
	"recurrence":"3600",
	"bitrate": 100,
	"initialDelay": 30
}'
```

Response:

```json
{
	"uuid": "bebcde2c-818c-48c3-b1f8-8ed3d2aa2fc9",
	"remoteMetricRequestUUID": "be6fde8a-21f5-4d93-aef9-a97cb557c16a",
	"linkUUID": "38e8ef71-4102-48d2-81eb-2a35b938c868",
	"type": "udp-bw",
	"recurrence": "3600",
	"enabled": true
}
```

##### Metric Requests for Applications (#16)

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"resourceId": "*", 
	"resourceType": "application",
	"type":"cpu-util",
	"recurrence":"30",
	"enabled":"true"
}'
```

Response:

```json
{
	"resourceId": "*", 
	"resourceType": "application",
	"type":"cpu-util",
	"recurrence":"30",
	"enabled":"true"
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"resourceId": "*", 
	"resourceType": "application",
	"type":"mem-util",
	"recurrence":"30",
	"enabled":"true"
}'
```

Response:

```json
{
	"uuid": "5fca5d0c-e923-434d-b10e-709d931bfa31",
	"remoteMetricRequestUUID": "1e0767bd-9bb3-49a1-906b-125b197349c5",
	"linkUUID": "2addfe48-709a-4fe1-8eb8-2c8cbefaad52",
	"type": "mem-util",
	"recurrence": "30",
	"enabled": true
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"resourceId": "*", 
	"resourceType": "application",
	"type":"storage-util",
	"recurrence":"30",
	"enabled":"true"
}'
```

Response:

```json
{
	"uuid": "b34e590a-e27a-46a9-86b4-7af90666fbcf",
	"remoteMetricRequestUUID": "54f73fa8-3cee-4147-a516-1695fb26a4a8",
	"linkUUID": "2addfe48-709a-4fe1-8eb8-2c8cbefaad52",
	"type": "storage-util",
	"recurrence": "30",
	"enabled": true
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/metric-requests \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"resourceId": "*", 
	"resourceType": "application",
	"type":"net-util",
	"recurrence":"30",
	"enabled":"true"
}'
```

Response:

```json
{
	"uuid": "ee0264fe-898f-4491-bf95-52c3b7919f9a",
	"remoteMetricRequestUUID": "65fce878-006a-4767-a3fb-59e9476eaf39",
	"linkUUID": "2addfe48-709a-4fe1-8eb8-2c8cbefaad52",
	"type": "net-util",
	"recurrence": "30",
	"enabled": true
}
```

#### Resources (#5-6)

##### CPU (#5)

Responses have been truncated for better readability. Just check the subsequent `GET /api/v1/nodes/{resourceId}/cpu` or `GET /api/v1/nodes/{resourceId}/memory` requests during application creation in the next section.

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/resources/cpus \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8' \
```

Response:

```json
[
	{
		"uuid": "c9fed4a2-35e5-455c-97e1-93218f4fa554",
		"nodeUUID": "4e0f4b43-7d82-4ebd-8f75-29c18fe09a34",
		"nodeName": "edge-0",
		"cpuCapacity": {
			"modelName": "12th Gen Intel(R) Core(TM) i7-1260P",
			"cores": 12,
			"threads": 24,
			"bogoMIPS": 4993.0,
			"minimalFrequency": 400.0,
			"averageFrequency": 2550.0,
			"maximalFrequency": 4700.0,
			"shares": 24000,
			"slots": 0.0,
			"mips": 4993.0,
			"gflop": 0.0
		},
		"cpuAllocatable": {
			"modelName": "12th Gen Intel(R) Core(TM) i7-1260P",
			"cores": 12,
			"threads": 24,
			"bogoMIPS": 4993.0,
			"minimalFrequency": 400.0,
			"averageFrequency": 2550.0,
			"maximalFrequency": 4700.0,
			"shares": 24000,
			"slots": 0.0,
			"mips": 4993.0,
			"gflop": 0.0
		}
	},
	...
]
```

##### CPU (#6)

Request: `/resources/memory`

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/resources/memory \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8' \
```

```json
[
	{
		"uuid": "7f3593b1-19c4-4302-b675-323bc186afd1",
		"nodeUUID": "4e0f4b43-7d82-4ebd-8f75-29c18fe09a34",
		"nodeName": "edge-0",
		"memoryCapacity": {
			"size": 15.322136,
			"slots": 0
		},
		"memoryAllocatable": {
			"size": 15.322136,
			"slots": 0
		}
	},
	...
]
```

#### Tags (#7)

Responses have been truncated for better readability. Just check the first `POST /api/v1/nodes` requests in the former sections.

Request:

```bash
curl --request GET \
  --url 'http://localhost:8081/api/v1/tags?type=node' \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8' \
```

Response:

```json
[
	{
		"tagId": "aaf6fc47-faa5-4b84-b089-2aa59430cd0f",
		"tagType": "NODE",
		"tagKey": "properties",
		"tagValue": "Java, MySQL",
		"parentResource": {
			"resourceType": "NODE",
			"resourceUUID": "4e0f4b43-7d82-4ebd-8f75-29c18fe09a34",
			"resourceId": "edge-0",
			"url": "http://localhost:8081/api/v1/nodes/4e0f4b43-7d82-4ebd-8f75-29c18fe09a34"
		}
	},
	...
]
```

#### Link Metrics (#11)

Request: 

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/metrics?type=link \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8' \
```

Response:

```json
[
	{
		"metricUUID": "2135620d-d7df-4a2e-97a9-a74341c9253a",
		"metricType": "ICMP_RTT",
		"sourceNode": "h5136.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"startTime": "2024-04-17T18:17:26.628383652Z",
		"endTime": "2024-04-17T18:17:35.882284967Z",
		"value": 169.165,
		"unit": "ms"
	},
	{
		"metricUUID": "6ffe62ea-3c2f-4270-af0b-62411368c0ce",
		"metricType": "ICMP_RTT",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"startTime": "2024-04-17T18:17:27.090803992Z",
		"endTime": "2024-04-17T18:17:36.127744490Z",
		"value": 23.604,
		"unit": "ms"
	},
	{
		"metricUUID": "1b47bde4-f1b2-4e55-bf15-61ab02f62e28",
		"metricType": "ICMP_RTT",
		"sourceNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"destinationNode": "h5138.pi.uni-bamberg.de",
		"startTime": "2024-04-17T18:17:27.932000723Z",
		"endTime": "2024-04-17T18:17:37.280731955Z",
		"value": 169.146,
		"unit": "ms"
	},
	{
		"metricUUID": "ccca696b-3002-45f6-a053-7ca78a7076c8",
		"metricType": "ICMP_RTT",
		"sourceNode": "h5137.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"startTime": "2024-04-17T18:17:26.910408320Z",
		"endTime": "2024-04-17T18:17:35.949943682Z",
		"value": 22.055,
		"unit": "ms"
	},
	{
		"metricUUID": "622fb68d-5e3f-4e09-ac24-78e2824f7212",
		"metricType": "ICMP_RTT",
		"sourceNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"destinationNode": "h5137.pi.uni-bamberg.de",
		"startTime": "2024-04-17T18:17:28.511937540Z",
		"endTime": "2024-04-17T18:17:37.580451387Z",
		"value": 21.945,
		"unit": "ms"
	},
	{
		"metricUUID": "2c18429a-8681-4cb3-97ad-f2c467f5cd5e",
		"metricType": "ICMP_RTT",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:33:30.227151050Z",
		"endTime": "2024-04-17T17:33:39.267866632Z",
		"value": 0.991,
		"unit": "ms"
	},
	{
		"metricUUID": "20e56a17-ebaa-42dd-b6e3-dae4c8f09fdb",
		"metricType": "ICMP_RTT",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "h5137.pi.uni-bamberg.de",
		"startTime": "2024-04-17T18:17:26.524913832Z",
		"endTime": "2024-04-17T18:17:35.542005410Z",
		"value": 1.096,
		"unit": "ms"
	},
	{
		"metricUUID": "3ee8565f-112e-4666-82af-204b5c237c25",
		"metricType": "ICMP_RTT",
		"sourceNode": "h5136.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"startTime": "2024-04-17T18:17:26.718689767Z",
		"endTime": "2024-04-17T18:17:35.757733862Z",
		"value": 23.465,
		"unit": "ms"
	},
	{
		"metricUUID": "4a34a36e-18d9-4acf-b6cd-a8e8b7b3d116",
		"metricType": "ICMP_RTT",
		"sourceNode": "h5137.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"startTime": "2024-04-17T18:17:26.815199214Z",
		"endTime": "2024-04-17T18:17:36.001544708Z",
		"value": 169.265,
		"unit": "ms"
	},
	{
		"metricUUID": "daa62025-6f77-49cb-b683-65e3ce591fac",
		"metricType": "ICMP_RTT",
		"sourceNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T18:17:28.665300381Z",
		"endTime": "2024-04-17T18:17:37.721735016Z",
		"value": 23.561,
		"unit": "ms"
	},
	{
		"metricUUID": "a71296e1-37a6-495e-b6db-e6f1b6ee3bbf",
		"metricType": "ICMP_RTT",
		"sourceNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T18:17:27.327069896Z",
		"endTime": "2024-04-17T18:17:36.673838824Z",
		"value": 169.09,
		"unit": "ms"
	},
	{
		"metricUUID": "866976d1-97d7-445f-948e-4a9fcda81963",
		"metricType": "ICMP_RTT",
		"sourceNode": "h5137.pi.uni-bamberg.de",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T18:17:26.411138453Z",
		"endTime": "2024-04-17T18:17:35.429636023Z",
		"value": 1.105,
		"unit": "ms"
	},
	{
		"metricUUID": "f9caebad-4722-46fa-86f2-448a1607068c",
		"metricType": "ICMP_RTT",
		"sourceNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"destinationNode": "h5138.pi.uni-bamberg.de",
		"startTime": "2024-04-17T18:17:28.817040608Z",
		"endTime": "2024-04-17T18:17:37.897000641Z",
		"value": 23.647,
		"unit": "ms"
	},
	{
		"metricUUID": "cd6eb484-f19b-4527-8d8c-58f580805b19",
		"metricType": "ICMP_RTT",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"startTime": "2024-04-17T18:17:27.001452937Z",
		"endTime": "2024-04-17T18:17:36.183422042Z",
		"value": 169.662,
		"unit": "ms"
	},
	{
		"metricUUID": "ab25202a-8517-476b-86ac-20555ccfdebf",
		"metricType": "ICMP_RTT",
		"sourceNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"destinationNode": "h5137.pi.uni-bamberg.de",
		"startTime": "2024-04-17T18:17:27.631436115Z",
		"endTime": "2024-04-17T18:17:37.415537018Z",
		"value": 169.127,
		"unit": "ms"
	},
	{
		"metricUUID": "28c3d85b-558e-48a9-b7db-2c68f8ad2677",
		"metricType": "TCP_BW",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"startTime": "2024-04-17T17:20:41.401860116Z",
		"endTime": "2024-04-17T17:20:47.624196745Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "64f15524-69de-448b-84dc-ad2e8bebde94",
		"metricType": "TCP_BW",
		"sourceNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"destinationNode": "h5138.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:22:42.732350998Z",
		"endTime": "2024-04-17T17:22:49.247744578Z",
		"value": 39.4,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "40a10636-9716-48dc-b391-2dd06135c0b3",
		"metricType": "TCP_BW",
		"sourceNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"destinationNode": "h5137.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:22:12.337339439Z",
		"endTime": "2024-04-17T17:22:18.699433245Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "d2e004f0-5548-43c7-9659-39267d5f6ab1",
		"metricType": "TCP_BW",
		"sourceNode": "h5137.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"startTime": "2024-04-17T18:20:11.015278837Z",
		"endTime": "2024-04-17T18:20:16.209843385Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "adf2c74c-2abe-4baa-b066-502a18a456f4",
		"metricType": "TCP_BW",
		"sourceNode": "h5136.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"startTime": "2024-04-17T18:19:10.387035306Z",
		"endTime": "2024-04-17T18:19:15.565002135Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "b115cddb-d52a-49e9-9992-5bfdb4b680e3",
		"metricType": "TCP_BW",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "h5137.pi.uni-bamberg.de",
		"startTime": "2024-04-17T18:18:09.759959516Z",
		"endTime": "2024-04-17T18:18:14.770129679Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "55dd8547-99a5-471f-a4e8-5a50be9185ad",
		"metricType": "TCP_BW",
		"sourceNode": "h5137.pi.uni-bamberg.de",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T18:17:39.566573176Z",
		"endTime": "2024-04-17T18:17:44.577218417Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "c562aab8-c113-410f-bda0-171b6dc789de",
		"metricType": "TCP_BW",
		"sourceNode": "h5137.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"startTime": "2024-04-17T18:19:40.775755865Z",
		"endTime": "2024-04-17T18:19:46.966047438Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "2fb53054-7063-4af9-8e8b-96bbe3f9ec4e",
		"metricType": "TCP_BW",
		"sourceNode": "h5136.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"startTime": "2024-04-17T18:18:40.151071334Z",
		"endTime": "2024-04-17T18:18:46.340397686Z",
		"value": 52.8,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "7f0898aa-42e4-4515-ad59-2636ddd30907",
		"metricType": "TCP_BW",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:33:33.757683587Z",
		"endTime": "2024-04-17T17:33:38.767770146Z",
		"value": 100.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "a6107bf7-5635-4eb8-b6b0-10edbe41f27a",
		"metricType": "TCP_BW",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"startTime": "2024-04-17T17:21:11.637383176Z",
		"endTime": "2024-04-17T17:21:16.843112590Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "fa16ffaa-30dc-4db8-8df7-3b741cbb7cdb",
		"metricType": "TCP_BW",
		"sourceNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"destinationNode": "h5137.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:23:13.402545811Z",
		"endTime": "2024-04-17T17:23:18.602992520Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "8a0468af-1c4f-418c-a9d1-4463a85bf67c",
		"metricType": "TCP_BW",
		"sourceNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"destinationNode": "h5138.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:24:13.938362823Z",
		"endTime": "2024-04-17T17:24:19.137083724Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "396d5838-8114-4dde-9797-aa7ef1d2209c",
		"metricType": "TCP_BW",
		"sourceNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:23:43.693265851Z",
		"endTime": "2024-04-17T17:23:48.883088326Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "1afed73c-849e-4fbf-b594-a613793b3306",
		"metricType": "TCP_BW",
		"sourceNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:21:41.941547579Z",
		"endTime": "2024-04-17T17:21:48.302774140Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "3c658594-d46b-4ace-91da-a34327812812",
		"metricType": "UDP_BW",
		"sourceNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"destinationNode": "h5137.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:31:12.028467304Z",
		"endTime": "2024-04-17T17:31:17.192410842Z",
		"value": 64.6,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "b9b57654-2d34-4304-9b26-423787f775b7",
		"metricType": "UDP_BW",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "h5137.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:26:08.029246828Z",
		"endTime": "2024-04-17T17:26:13.038853227Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "4e1057af-0709-4c1d-959c-24628cfc1cba",
		"metricType": "UDP_BW",
		"sourceNode": "h5136.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"startTime": "2024-04-17T17:27:09.087073108Z",
		"endTime": "2024-04-17T17:27:14.270593909Z",
		"value": 64.6,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "5afdf93c-05f3-48d1-a02f-0df1c32b0f6c",
		"metricType": "UDP_BW",
		"sourceNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:31:42.261024337Z",
		"endTime": "2024-04-17T17:31:47.446382060Z",
		"value": 64.6,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "0425e557-da8e-40a1-8acf-60b8b4742a4f",
		"metricType": "UDP_BW",
		"sourceNode": "h5136.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"startTime": "2024-04-17T17:26:38.780399872Z",
		"endTime": "2024-04-17T17:26:44.834044275Z",
		"value": 62.8,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "096cd926-a4ce-4f89-a1b3-c252a6e69b7c",
		"metricType": "UDP_BW",
		"sourceNode": "h5137.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"startTime": "2024-04-17T17:28:09.708508024Z",
		"endTime": "2024-04-17T17:28:14.934940093Z",
		"value": 64.5,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "8ef7773f-82f4-4375-bd23-02ba7ca9753e",
		"metricType": "UDP_BW",
		"sourceNode": "h5137.pi.uni-bamberg.de",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:25:37.842490546Z",
		"endTime": "2024-04-17T17:25:42.853947077Z",
		"value": 65.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "a1440c72-120c-4b7e-9452-0521982ca98f",
		"metricType": "UDP_BW",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:36:23.559081863Z",
		"endTime": "2024-04-17T17:36:28.568869587Z",
		"value": 100.0,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "4a489704-cdf7-48f3-b12d-f20f0d8f571e",
		"metricType": "UDP_BW",
		"sourceNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"destinationNode": "h5138.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:30:41.386990951Z",
		"endTime": "2024-04-17T17:30:47.582398032Z",
		"value": 62.8,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "c8561afa-ca26-43ba-9b93-5a74994382aa",
		"metricType": "UDP_BW",
		"sourceNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"destinationNode": "h5138.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:32:12.492045337Z",
		"endTime": "2024-04-17T17:32:17.664634470Z",
		"value": 64.7,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "0713e156-e4ef-459b-8794-d7fa198712d0",
		"metricType": "UDP_BW",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"startTime": "2024-04-17T17:28:40.080878900Z",
		"endTime": "2024-04-17T17:28:46.149950726Z",
		"value": 62.8,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "e1d63776-faf8-4652-9f2f-928d5514943a",
		"metricType": "UDP_BW",
		"sourceNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"destinationNode": "h5136.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:29:40.627468230Z",
		"endTime": "2024-04-17T17:29:46.823392927Z",
		"value": 62.8,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "b74fcb38-9d67-4eda-a08d-a42dc04a196b",
		"metricType": "UDP_BW",
		"sourceNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"destinationNode": "h5137.pi.uni-bamberg.de",
		"startTime": "2024-04-17T17:30:11.011686651Z",
		"endTime": "2024-04-17T17:30:17.516469231Z",
		"value": 62.8,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "71cd07b3-82d1-4b72-9584-880dad0a6e22",
		"metricType": "UDP_BW",
		"sourceNode": "h5137.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-6659339536.westus.cloudapp.azure.com",
		"startTime": "2024-04-17T17:27:39.466408516Z",
		"endTime": "2024-04-17T17:27:45.515647049Z",
		"value": 62.8,
		"unit": "Mbit/s"
	},
	{
		"metricUUID": "98f2023d-49e1-41d8-9b96-09020ef7008b",
		"metricType": "UDP_BW",
		"sourceNode": "h5138.pi.uni-bamberg.de",
		"destinationNode": "pulceo-node-eae9342543.westeurope.cloudapp.azure.com",
		"startTime": "2024-04-17T17:29:10.312106109Z",
		"endTime": "2024-04-17T17:29:15.511916263Z",
		"value": 64.5,
		"unit": "Mbit/s"
	}
]
```

#### Applications (#8-10 and #12-15)

##### Cloud 1

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/cloud1/cpu \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```json
{
	"uuid": "1ad7f082-fd26-4d05-92c4-e30a2fee05a0",
	"nodeUUID": "98036c1c-1d51-4fcd-81ab-21fb40b14b3b",
	"nodeName": "cloud1",
	"cpuCapacity": {
		"modelName": "Intel(R) Xeon(R) Platinum 8171M CPU @ 2.60GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 4190.15,
		"minimalFrequency": 2095.076,
		"averageFrequency": 2095.076,
		"maximalFrequency": 2095.076,
		"shares": 2000,
		"slots": 0.0,
		"mips": 4190.15,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Xeon(R) Platinum 8171M CPU @ 2.60GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 4190.15,
		"minimalFrequency": 2095.076,
		"averageFrequency": 2095.076,
		"maximalFrequency": 2095.076,
		"shares": 2000,
		"slots": 0.0,
		"mips": 4190.15,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/cloud1/cpu/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "shares",
	"value": 1000
}'
```

Response:

```json
{
	"uuid": "1ad7f082-fd26-4d05-92c4-e30a2fee05a0",
	"nodeUUID": "98036c1c-1d51-4fcd-81ab-21fb40b14b3b",
	"nodeName": "cloud1",
	"cpuCapacity": {
		"modelName": "Intel(R) Xeon(R) Platinum 8171M CPU @ 2.60GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 4190.15,
		"minimalFrequency": 2095.076,
		"averageFrequency": 2095.076,
		"maximalFrequency": 2095.076,
		"shares": 2000,
		"slots": 0.0,
		"mips": 4190.15,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Xeon(R) Platinum 8171M CPU @ 2.60GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 4190.15,
		"minimalFrequency": 2095.076,
		"averageFrequency": 2095.076,
		"maximalFrequency": 2095.076,
		"shares": 1000,
		"slots": 0.0,
		"mips": 4190.15,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/cloud1/memory \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```json
{
	"uuid": "1760e62f-c589-43d1-ad1d-cac3866db84e",
	"nodeUUID": "98036c1c-1d51-4fcd-81ab-21fb40b14b3b",
	"nodeName": "cloud1",
	"memoryCapacity": {
		"size": 3.8216248,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 3.8216248,
		"slots": 0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/cloud1/memory/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "size",
	"value": 2.82
}'
```

Response:

```json
{
	"uuid": "1760e62f-c589-43d1-ad1d-cac3866db84e",
	"nodeUUID": "98036c1c-1d51-4fcd-81ab-21fb40b14b3b",
	"nodeName": "cloud1",
	"memoryCapacity": {
		"size": 3.8216248,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 2.82,
		"slots": 0
	}
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/applications \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
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
				"MQTT_SERVER_NAME":"localhost:1883",
				"MQTT_PORT":"8883",
				"MQTT_TLS":"True",
				"MQTT_USERNAME": "aaaa",
				"MQTT_PASSWORD": "aaaaaaaa",
				"MQTT_CLIENT_ID":"cloud1-edge-iot-simulator",
				"WEB_PORT": 80
			}
		}
	]
}'
```

Response:

```json
{
	"applicationUUID": "c7727953-12ab-4652-b68c-2beb5b2b1868",
	"remoteApplicationUUID": "00000000-0000-0000-0000-000000000000",
	"nodeId": "98036c1c-1d51-4fcd-81ab-21fb40b14b3b",
	"endpoint": "https://null:80",
	"name": "cloud1-edge-iot-simulator",
	"applicationComponents": [
		{
			"applicationComponentUUID": "a1f50038-735c-4d92-a58b-607e760dac42",
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

##### Cloud 2

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/cloud2/cpu \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```


Response:

```json
{
	"uuid": "2db96045-8fbe-45d4-978d-0dff460d35d1",
	"nodeUUID": "3f425fb8-c4e5-4eab-9d30-4552e94abdb3",
	"nodeName": "cloud2",
	"cpuCapacity": {
		"modelName": "Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 4589.37,
		"minimalFrequency": 2294.685,
		"averageFrequency": 2294.685,
		"maximalFrequency": 2294.685,
		"shares": 2000,
		"slots": 0.0,
		"mips": 4589.37,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 4589.37,
		"minimalFrequency": 2294.685,
		"averageFrequency": 2294.685,
		"maximalFrequency": 2294.685,
		"shares": 1000,
		"slots": 0.0,
		"mips": 4589.37,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/cloud2/cpu/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "shares",
	"value": 1000
}'
```

Response:

```json
{
	"uuid": "2db96045-8fbe-45d4-978d-0dff460d35d1",
	"nodeUUID": "3f425fb8-c4e5-4eab-9d30-4552e94abdb3",
	"nodeName": "cloud2",
	"cpuCapacity": {
		"modelName": "Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 4589.37,
		"minimalFrequency": 2294.685,
		"averageFrequency": 2294.685,
		"maximalFrequency": 2294.685,
		"shares": 2000,
		"slots": 0.0,
		"mips": 4589.37,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Xeon(R) CPU E5-2673 v4 @ 2.30GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 4589.37,
		"minimalFrequency": 2294.685,
		"averageFrequency": 2294.685,
		"maximalFrequency": 2294.685,
		"shares": 1000,
		"slots": 0.0,
		"mips": 4589.37,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/cloud2/memory \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```
{
	"uuid": "43715554-1605-4451-a455-48a889d55599",
	"nodeUUID": "3f425fb8-c4e5-4eab-9d30-4552e94abdb3",
	"nodeName": "cloud2",
	"memoryCapacity": {
		"size": 3.8216286,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 2.82,
		"slots": 0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/cloud2/memory/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "size",
	"value": 2.82
}'
```

Response:

```json
{
  "uuid": "43715554-1605-4451-a455-48a889d55599",
  "nodeUUID": "3f425fb8-c4e5-4eab-9d30-4552e94abdb3",
  "nodeName": "cloud2",
  "memoryCapacity": {
    "size": 3.8216286,
    "slots": 0
  },
  "memoryAllocatable": {
    "size": 2.82,
    "slots": 0
  }
}
```

Request:
  
```bash
curl --request POST \
  --url http://localhost:8081/api/v1/applications \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"nodeId": "cloud2",
	"name": "edge-iot-simulator",
	"applicationComponents": [
		{
			"name": "component-eis",
			"image": "ghcr.io/spboehm/edge-iot-simulator:v1.1.0",
			"port": 80,
			"protocol": "HTTPS",
			"applicationComponentType": "PUBLIC",
			"environmentVariables": {
				"MQTT_SERVER_NAME":"localhost:1883",
				"MQTT_PORT":"8883",
				"MQTT_TLS":"True",
				"MQTT_USERNAME": "aaaa",
				"MQTT_PASSWORD": "aaaaaaaa",
				"MQTT_CLIENT_ID":"cloud2-edge-iot-simulator",
				"WEB_PORT": 80
			}
		}
	]
}'
```

Response:

```json
{
	"applicationUUID": "29e89324-c0da-4481-8fd1-f29251f24de2",
	"remoteApplicationUUID": "00000000-0000-0000-0000-000000000000",
	"nodeId": "3f425fb8-c4e5-4eab-9d30-4552e94abdb3",
	"endpoint": "https://null:80",
	"name": "cloud2-edge-iot-simulator",
	"applicationComponents": [
		{
			"applicationComponentUUID": "a6386475-7e58-43f3-9299-bb38ae6c1108",
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

##### Fog 1

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/fog1/cpu \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```json
{
	"uuid": "55f93a32-182d-47ef-aaf6-0be31749da18",
	"nodeUUID": "615ba998-3ecb-40f4-8a00-bdebf5894303",
	"nodeName": "fog1",
	"cpuCapacity": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 7200.11,
		"minimalFrequency": 3600.058,
		"averageFrequency": 3600.058,
		"maximalFrequency": 3600.058,
		"shares": 2000,
		"slots": 0.0,
		"mips": 7200.11,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 7200.11,
		"minimalFrequency": 3600.058,
		"averageFrequency": 3600.058,
		"maximalFrequency": 3600.058,
		"shares": 2000,
		"slots": 0.0,
		"mips": 7200.11,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/fog1/cpu/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "shares",
	"value": 1000
}'
```

Response:

```json
{
	"uuid": "55f93a32-182d-47ef-aaf6-0be31749da18",
	"nodeUUID": "615ba998-3ecb-40f4-8a00-bdebf5894303",
	"nodeName": "fog1",
	"cpuCapacity": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 7200.11,
		"minimalFrequency": 3600.058,
		"averageFrequency": 3600.058,
		"maximalFrequency": 3600.058,
		"shares": 2000,
		"slots": 0.0,
		"mips": 7200.11,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 2,
		"threads": 2,
		"bogoMIPS": 7200.11,
		"minimalFrequency": 3600.058,
		"averageFrequency": 3600.058,
		"maximalFrequency": 3600.058,
		"shares": 1000,
		"slots": 0.0,
		"mips": 7200.11,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/fog1/memory \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```json
{
	"uuid": "0500a08f-e4f0-447e-95c0-03143f730a85",
	"nodeUUID": "615ba998-3ecb-40f4-8a00-bdebf5894303",
	"nodeName": "fog1",
	"memoryCapacity": {
		"size": 1.9250717,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 1.9250717,
		"slots": 0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/fog1/memory/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "size",
	"value": 0.92
}'
```

Response:
  
```json
{
	"uuid": "0500a08f-e4f0-447e-95c0-03143f730a85",
	"nodeUUID": "615ba998-3ecb-40f4-8a00-bdebf5894303",
	"nodeName": "fog1",
	"memoryCapacity": {
		"size": 1.9250717,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 0.92,
		"slots": 0
	}
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/applications \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"nodeId": "fog1",
	"name": "edge-iot-simulator",
	"applicationComponents": [
		{
			"name": "component-eis",
			"image": "ghcr.io/spboehm/edge-iot-simulator:v1.1.0",
			"port": 80,
			"protocol": "HTTPS",
			"applicationComponentType": "PUBLIC",
			"environmentVariables": {
				"MQTT_SERVER_NAME":"localhost:1883",
				"MQTT_PORT":"8883",
				"MQTT_TLS":"True",
				"MQTT_USERNAME": "aaaa",
				"MQTT_PASSWORD": "aaaaaaaa",
				"MQTT_CLIENT_ID":"fog1-edge-iot-simulator",
				"WEB_PORT": 80
			}
		}
	]
}'
```

Response:

```json
{
	"applicationUUID": "bce5169c-a2e4-4ce4-a5db-0e5383e78d33",
	"remoteApplicationUUID": "00000000-0000-0000-0000-000000000000",
	"nodeId": "615ba998-3ecb-40f4-8a00-bdebf5894303",
	"endpoint": "https://null:80",
	"name": "fog1-edge-iot-simulator",
	"applicationComponents": [
		{
			"applicationComponentUUID": "3d42bfac-9167-4f65-8794-8462eb1371ed",
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

##### Fog 2

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/fog2/cpu \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```json
{
	"uuid": "014f64d3-d7b9-48aa-9217-fce7a9766904",
	"nodeUUID": "22d5cc00-3264-4ad5-b85d-26c1bbb4cbf3",
	"nodeName": "fog2",
	"cpuCapacity": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 4,
		"threads": 4,
		"bogoMIPS": 7200.11,
		"minimalFrequency": 3600.056,
		"averageFrequency": 3600.056,
		"maximalFrequency": 3600.056,
		"shares": 4000,
		"slots": 0.0,
		"mips": 7200.11,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 4,
		"threads": 4,
		"bogoMIPS": 7200.11,
		"minimalFrequency": 3600.056,
		"averageFrequency": 3600.056,
		"maximalFrequency": 3600.056,
		"shares": 4000,
		"slots": 0.0,
		"mips": 7200.11,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/fog2/cpu/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "shares",
	"value": 3000
}'
```

Response:

```json
{
	"uuid": "014f64d3-d7b9-48aa-9217-fce7a9766904",
	"nodeUUID": "22d5cc00-3264-4ad5-b85d-26c1bbb4cbf3",
	"nodeName": "fog2",
	"cpuCapacity": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 4,
		"threads": 4,
		"bogoMIPS": 7200.11,
		"minimalFrequency": 3600.056,
		"averageFrequency": 3600.056,
		"maximalFrequency": 3600.056,
		"shares": 4000,
		"slots": 0.0,
		"mips": 7200.11,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 4,
		"threads": 4,
		"bogoMIPS": 7200.11,
		"minimalFrequency": 3600.056,
		"averageFrequency": 3600.056,
		"maximalFrequency": 3600.056,
		"shares": 3000,
		"slots": 0.0,
		"mips": 7200.11,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/fog2/memory \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```json
{
	"uuid": "1a0845d0-0501-4770-9fbb-718b90d12abe",
	"nodeUUID": "22d5cc00-3264-4ad5-b85d-26c1bbb4cbf3",
	"nodeName": "fog2",
	"memoryCapacity": {
		"size": 3.827549,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 3.827549,
		"slots": 0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/fog2/memory/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "size",
	"value": 2.82
}'
```

Response:

```json
{
	"uuid": "1a0845d0-0501-4770-9fbb-718b90d12abe",
	"nodeUUID": "22d5cc00-3264-4ad5-b85d-26c1bbb4cbf3",
	"nodeName": "fog2",
	"memoryCapacity": {
		"size": 3.827549,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 2.82,
		"slots": 0
	}
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/applications \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"nodeId": "fog2",
	"name": "edge-iot-simulator",
	"applicationComponents": [
		{
			"name": "component-eis",
			"image": "ghcr.io/spboehm/edge-iot-simulator:v1.1.0",
			"port": 80,
			"protocol": "HTTPS",
			"applicationComponentType": "PUBLIC",
			"environmentVariables": {
				"MQTT_SERVER_NAME":"localhost:1883",
				"MQTT_PORT":"8883",
				"MQTT_TLS":"True",
				"MQTT_USERNAME": "aaaa",
				"MQTT_PASSWORD": "aaaaaaaa",
				"MQTT_CLIENT_ID":"fog2-edge-iot-simulator",
				"WEB_PORT": 80
			}
		}
	]
}'
```

Response:

```json
{
	"applicationUUID": "336a1f94-b877-46cb-9456-9d99e3fbeac9",
	"remoteApplicationUUID": "00000000-0000-0000-0000-000000000000",
	"nodeId": "22d5cc00-3264-4ad5-b85d-26c1bbb4cbf3",
	"endpoint": "https://null:80",
	"name": "fog2-edge-iot-simulator",
	"applicationComponents": [
		{
			"applicationComponentUUID": "341b7e91-6540-4617-bfe0-795c4ad5280f",
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

##### Fog 3

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/fog3/cpu \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```json
{
	"uuid": "68645cb8-d195-482f-bc03-2cd68efeddbe",
	"nodeUUID": "e6c27c8a-a337-49e1-8662-38c96bff3351",
	"nodeName": "fog3",
	"cpuCapacity": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 8,
		"threads": 8,
		"bogoMIPS": 7199.92,
		"minimalFrequency": 3599.962,
		"averageFrequency": 3599.962,
		"maximalFrequency": 3599.962,
		"shares": 8000,
		"slots": 0.0,
		"mips": 7199.92,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 8,
		"threads": 8,
		"bogoMIPS": 7199.92,
		"minimalFrequency": 3599.962,
		"averageFrequency": 3599.962,
		"maximalFrequency": 3599.962,
		"shares": 8000,
		"slots": 0.0,
		"mips": 7199.92,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/fog3/cpu/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "shares",
	"value": 7000
}'
```

Response:

```json
{
	"uuid": "68645cb8-d195-482f-bc03-2cd68efeddbe",
	"nodeUUID": "e6c27c8a-a337-49e1-8662-38c96bff3351",
	"nodeName": "fog3",
	"cpuCapacity": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 8,
		"threads": 8,
		"bogoMIPS": 7199.92,
		"minimalFrequency": 3599.962,
		"averageFrequency": 3599.962,
		"maximalFrequency": 3599.962,
		"shares": 8000,
		"slots": 0.0,
		"mips": 7199.92,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 8,
		"threads": 8,
		"bogoMIPS": 7199.92,
		"minimalFrequency": 3599.962,
		"averageFrequency": 3599.962,
		"maximalFrequency": 3599.962,
		"shares": 7000,
		"slots": 0.0,
		"mips": 7199.92,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/fog3/memory \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```json
{
	"uuid": "08722d74-eb78-45ed-b58d-c87fc724501c",
	"nodeUUID": "e6c27c8a-a337-49e1-8662-38c96bff3351",
	"nodeName": "fog3",
	"memoryCapacity": {
		"size": 9.715271,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 8.71,
		"slots": 0
	}
}
```

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/fog3/memory \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```json
{
	"uuid": "08722d74-eb78-45ed-b58d-c87fc724501c",
	"nodeUUID": "e6c27c8a-a337-49e1-8662-38c96bff3351",
	"nodeName": "fog3",
	"memoryCapacity": {
		"size": 9.715271,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 9.715271,
		"slots": 0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/fog3/cpu/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "shares",
	"value": 7000
}'
```

Response:

```json
{
	"uuid": "68645cb8-d195-482f-bc03-2cd68efeddbe",
	"nodeUUID": "e6c27c8a-a337-49e1-8662-38c96bff3351",
	"nodeName": "fog3",
	"cpuCapacity": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 8,
		"threads": 8,
		"bogoMIPS": 7199.92,
		"minimalFrequency": 3599.962,
		"averageFrequency": 3599.962,
		"maximalFrequency": 3599.962,
		"shares": 8000,
		"slots": 0.0,
		"mips": 7199.92,
		"gflop": 0.0
	},
	"cpuAllocatable": {
		"modelName": "Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz",
		"cores": 8,
		"threads": 8,
		"bogoMIPS": 7199.92,
		"minimalFrequency": 3599.962,
		"averageFrequency": 3599.962,
		"maximalFrequency": 3599.962,
		"shares": 7000,
		"slots": 0.0,
		"mips": 7199.92,
		"gflop": 0.0
	}
}
```

Request:

```bash
curl --request GET \
  --url http://localhost:8081/api/v1/nodes/fog3/memory \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'User-Agent: insomnia/2023.5.8'
```

Response:

```json
{
	"uuid": "08722d74-eb78-45ed-b58d-c87fc724501c",
	"nodeUUID": "e6c27c8a-a337-49e1-8662-38c96bff3351",
	"nodeName": "fog3",
	"memoryCapacity": {
		"size": 9.715271,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 9.715271,
		"slots": 0
	}
}
```

Request:

```bash
curl --request PATCH \
  --url http://localhost:8081/api/v1/nodes/fog3/memory/allocatable \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"key": "size",
	"value": 8.71
}'
```

Response:

```json
{
	"uuid": "08722d74-eb78-45ed-b58d-c87fc724501c",
	"nodeUUID": "e6c27c8a-a337-49e1-8662-38c96bff3351",
	"nodeName": "fog3",
	"memoryCapacity": {
		"size": 9.715271,
		"slots": 0
	},
	"memoryAllocatable": {
		"size": 8.71,
		"slots": 0
	}
}
```

Request:

```bash
curl --request POST \
  --url http://localhost:8081/api/v1/applications \
  --header 'Accept: application/json' \
  --header 'Authorization: Basic AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' \
  --header 'Content-Type: application/json' \
  --header 'User-Agent: insomnia/2023.5.8' \
  --data '{
	"nodeId": "fog3",
	"name": "edge-iot-simulator",
	"applicationComponents": [
		{
			"name": "component-eis",
			"image": "ghcr.io/spboehm/edge-iot-simulator:v1.1.0",
			"port": 80,
			"protocol": "HTTPS",
			"applicationComponentType": "PUBLIC",
			"environmentVariables": {
				"MQTT_SERVER_NAME":"localhost:1883",
				"MQTT_PORT":"8883",
				"MQTT_TLS":"True",
				"MQTT_USERNAME": "aaaa",
				"MQTT_PASSWORD": "aaaaaaaa",
				"MQTT_CLIENT_ID":"fog3-edge-iot-simulator",
				"WEB_PORT": 80
			}
		}
	]
}'
```

Response:

```json
{
	"applicationUUID": "d8a61189-350a-4982-8927-32facd8878a4",
	"remoteApplicationUUID": "00000000-0000-0000-0000-000000000000",
	"nodeId": "e6c27c8a-a337-49e1-8662-38c96bff3351",
	"endpoint": "https://null:80",
	"name": "fog3-edge-iot-simulator",
	"applicationComponents": [
		{
			"applicationComponentUUID": "0f1c8696-9df3-43bf-86fc-f18aa51552ac",
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