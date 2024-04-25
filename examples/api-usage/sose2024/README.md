# SOSE2024 2024

## API Requests

### PROD

Assumptions:

- PULCEO is exposed on `localhost:8081`
- You have created a valid service principal for Microsoft Azure [Create an Azure service principal with Azure CLI](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1?tabs=bash)

## Create an On-prem provider for computational resources

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

## Create Provider "azure-provider" (Microsoft Azure)

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

## Further cloud providers

tbd.

## Create Node "cloud1" (Microsoft Azure)

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

## Create Node "cloud2" (Microsoft Azure)

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

## Create Node "fog1" (On-premises)

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

## Create Node "fog2" (On-premises)

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

## Create Node "fog3" (On-premises)

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
}
```

## Create a Link
