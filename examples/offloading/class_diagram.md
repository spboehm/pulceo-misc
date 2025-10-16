# Class Diagram for Offloading System

```mermaid
classDiagram
    %% Abstract Base Classes
    class Scheduler {
        <<abstract>>
        -scheduling_properties: dict
        -mqtt_host: str
        -mqtt_port: int
        -mqtt_client: mqtt.Client
        -batch_size: int
        -total_number_of_tasks: int
        -pulceo_api: API
        -created_tasks_counter: itertools.count
        -new_tasks_counter: itertools.count
        -running_tasks_counter: itertools.count
        -completed_tasks_counter: itertools.count
        +__init__(scheduling_properties: dict)
        +init_mqtt(): mqtt.Client
        +on_connect(client, userdata, flags, reason_code, properties): void
        +on_message(client, userdata, msg): void
        +on_init()* void
        +handle_new_task(task: dict)* void
        +handle_completed_task(task: dict)* void
        +handle_health(): void
        +on_terminate()* void
        +start(): void
        +stop(): void
    }

    %% Concrete Scheduler Classes
    class EdgeOnlyScheduler {
        +name: str = "EdgeOnlyScheduler"
        +processedTasks: dict
        +pendingTasks: list
        +PENDING_TASKS_THRESHOLD: int = 0
        +on_terminate: bool = True
        +deferTasks(task: dict): void
        +maxAllocatableCPU(value: float): float
        +maxAllocatableMem(value: float): float
        +on_init(): void
        +schedule(task: dict, nodeType: str): void
        +handle_new_task(task: dict): void
        +handle_completed_task(task: dict): void
        +on_terminate(): void
    }

    class JointScheduler {
        +name: str = "JointScheduler"
        +handle_new_task(task: dict): void
    }

    class CloudOnlyScheduler {
        +name: str = "CloudOnlyScheduler"
        +handle_new_task(task: dict): void
    }

    %% Task Management Classes
    class TaskEmitter {
        -mqtt_host: str
        -mqtt_port: int
        -task_file: str
        -batch_size: int
        -history: dict
        -mqtt_client: mqtt.Client
        -scheduling_properties: dict
        -exit_event: threading.Event
        -pulceo_api: API
        -lock: threading.Lock
        -created_tasks_counter: itertools.count
        -scheduler_ready_event: threading.Event
        +__init__(scheduling_properties: dict)
        +init_mqtt(): mqtt.Client
        +get_timestamp(): int
        +on_connect(client, userdata, flags, reason_code, properties): void
        +on_message(client, userdata, msg): void
        +read_generated_tasks(): list
        +start(): void
        +stop(): void
    }

    class TaskMetric {
        +requestUUID: str
        +timestamp: int
        +requestType: str
        +sourceHost: str
        +destinationHost: str
        +resource: str
        +value: float
        +unit: str
        +__init__(task_uuid: str, resource: str, value: float, unit: str)
        +to_json(): str
        +to_string(): str
    }

    %% API Classes
    class API {
        -scheme: str
        -host: str
        -prm_port: int
        -psm_port: int
        -pms_port: int
        -monitoring: monitoring.API
        +__init__(scheme: str, host: str, prm_port: int, psm_port: int, pms_port: int)
        +check_for_env_file(): void
        +check_health(): void
        +check_heath_prm(): void
        +check_health_psm(): void
        +get_orchestration_context(scope: str): dict
        +reset_orchestration_context(): void
        +create_orchestration(name: str, description: str, properties: dict): dict
        +read_orchestration(orchestration_id: str): dict
        +start_orchestration(orchestration_id: str): void
        +stop_orchestration(orchestration_id: str): void
        +update_orchestration_status(orchestration_id: str, status: str): dict
        +read_nodes(): list
        +create_node(path_to_json: str): dict
        +read_links(): list
        +create_link(path_to_json: str): dict
        +read_json(path: str): dict
        +read_allocatable_cpu(): list
        +read_allocatable_cpu_by_node_id(node_id: str): dict
        +read_allocatable_cpu_by_node_type(node_type: str): list
        +read_allocatable_memory(): list
        +read_allocatable_memory_by_node_id(node_id: str): dict
        +read_allocatable_memory_by_node_type(node_type: str): list
        +update_allocatable_cpu(node_id: str, key: str, value: float): dict
        +update_allocatable_memory(node_id: str, key: str, value: float): dict
        +release_cpu_on_node(node_id: str, key: str, value: float): void
        +release_memory_on_node(node_id: str, key: str, value: float): void
        +create_application(node_id: str, application_name: str, path_to_json: str): dict
        +read_applications(): list
        +schedule_task(task_id: str, node_id: str, status: str, application_id: str, application_component_id: str, properties: dict): dict
        +create_task(task: str): str
        +create_orchestration_report(orchestration_id: str): void
    }

    class MonitoringAPI {
        -scheme: str
        -host: str
        -pms_port: int
        +__init__(scheme: str, host: str, pms_port: int)
        +check_health(): void
        +create_metric_request(path_to_json: str): dict
        +read_metric_requests(): list
        +read_json(path: str): dict
    }

    %% Enums
    class OrchestrationStatus {
        <<enumeration>>
        RUNNING
        COMPLETED
    }

    %% Utility Functions (not classes, but important for completeness)
    class TaskGenerator {
        <<utility>>
        +save_generated_tasks(num_tasks: int, tasks: list): void
        +generate_tasks(num_tasks: int): list
    }

    %% Relationships
    Scheduler <|-- EdgeOnlyScheduler : inherits
    EdgeOnlyScheduler <|-- JointScheduler : inherits
    EdgeOnlyScheduler <|-- CloudOnlyScheduler : inherits
    
    Scheduler --> API : uses
    TaskEmitter --> API : uses
    TaskEmitter --> TaskMetric : creates
    API --> MonitoringAPI : aggregates
    API --> OrchestrationStatus : uses
    
    %% MQTT Communication (conceptual)
    %%Scheduler -.-> TaskEmitter : MQTT Communication
    %%TaskEmitter -.-> Scheduler : MQTT Communication

    %% Notes
    note for Scheduler "Abstract base class that defines\nthe interface for all schedulers.\nHandles MQTT communication\nand task lifecycle management."
    
    note for EdgeOnlyScheduler "Concrete scheduler that schedules\ntasks only on edge nodes.\nImplements resource allocation\nand deferred task handling."
    
    note for TaskEmitter "Responsible for emitting tasks\nand tracking their execution.\nMeasures response times and\npublishes metrics via MQTT."
    
    note for API "Main SDK class providing\ninterface to PULCEO platform.\nHandles all REST API calls\nto PRM, PSM, and PMS services."
```

## Key Components Overview

### 1. **Scheduler Hierarchy**

- **Scheduler (Abstract)**: Base class defining the interface for all schedulers
- **EdgeOnlyScheduler**: Schedules tasks exclusively on edge nodes
- **JointScheduler**: Inherits from EdgeOnlyScheduler, can schedule on any node type
- **CloudOnlyScheduler**: Schedules tasks exclusively on cloud nodes

### 2. **Task Management**

- **TaskEmitter**: Manages task emission, tracks execution metrics, and handles MQTT communication
- **TaskMetric**: Data class for task performance metrics
- **TaskGenerator**: Utility functions for generating test tasks

### 3. **API Layer**

- **API**: Main SDK providing interface to PULCEO platform services
- **MonitoringAPI**: Specialized API for monitoring and metrics
- **OrchestrationStatus**: Enumeration for orchestration states

### 4. **Communication**

- MQTT-based asynchronous communication between TaskEmitter and Schedulers
- REST API communication with PULCEO platform services (PRM, PSM, PMS)

### 5. **Key Patterns**

- **Strategy Pattern**: Different scheduler implementations for different deployment strategies
- **Observer Pattern**: MQTT-based event-driven communication
- **Template Method**: Abstract methods in Scheduler base class