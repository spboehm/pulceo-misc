# pulceo-misc

## Quick Access SummerSoc 2024

Publication: **API-driven Cloud-Edge Orchestration with PULCEO: A Proof of Concept**

The experiment had to phases, therefore the raw data and the orchestration reports each contain `idle` and `load`.
For `idle`, we did not apply workloads and load experiments to the platform and analyzed the `idle` behavior of all components.
For `load`, we deployed a few instances of the [edge-iot-simulator](https://github.com/spboehm/edge-iot-simulator).

- Semi-structured literature review for obtaining the data model: [PULCEO: Structured Literature Review Source Repository](https://spboehm.github.io/pulceo-misc/)
- Documentation of RESTful API requests: [examples/api-usage/summersoc2024](https://github.com/spboehm/pulceo-misc/tree/main/examples/api-usage/summersoc2024)
- Raw data:
    - Idle: [pulceo-data-analytics/raw/summersoc2024-prod-idle](https://github.com/spboehm/pulceo-misc/tree/main/pulceo-data-analytics/raw/summersoc2024-prod-idle)
    - Load: [pulceo-data-analytics/raw/summersoc2024-prod-load](https://github.com/spboehm/pulceo-misc/tree/main/pulceo-data-analytics/raw/summersoc2024-prod-load)
- [PULCEO orchestration reports](https://spboehm.github.io/pulceo-misc/reports/):
    - Idle: [Orchestration report Idle](https://spboehm.github.io/pulceo-misc/reports/summersoc2024-prod-idle/)
    - Prod: [Orchestration report Load](https://spboehm.github.io/pulceo-misc/reports/summersoc2024-prod-load/)

## PULCEO Component Overview

| # | Service  |  Repository  | OpenAPI Specification  | Image |
|---|---|---|---|---|
| 1 | pulceo-resource-manager | [GitHub](https://github.com/spboehm/pulceo-resource-manager) | [OpenAPI Spec](https://spboehm.github.io/pulceo-resource-manager) | [GHCR](https://github.com/spboehm/pulceo-resource-manager/pkgs/container/pulceo-resource-manager) |
| 2 | pulceo-monitoring-service | [GitHub](https://github.com/spboehm/pulceo-monitoring-service) | [OpenAPI Spec](https://spboehm.github.io/pulceo-monitoring-service) | [GHCR](https://github.com/spboehm/pulceo-monitoring-service/pkgs/container/pulceo-monitoring-service)  |
| 3 | pulceo-service-manager | [GitHub](https://github.com/spboehm/pulceo-service-manager) | [OpenAPI Spec](https://spboehm.github.io/pulceo-service-manager) | [GHCR](https://github.com/spboehm/pulceo-service-manager/tree/main) |
| 4 | pulceo-node-agent | [GitHub](https://github.com/spboehm/pulceo-node-agent) | [OpenAPI Spec](https://github.com/spboehm/pulceo-node-agent) | [GHCR](https://github.com/spboehm/pulceo-node-agent) |

## slr-tables

This folder contains R source code and R markdown files to generate complex latex tables out of simple csv files.
It is used for the structured literature review to specify the supported metrics and features of pulceo-api.