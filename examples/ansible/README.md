# README pulceo ansible

## pulceo-node-agent

Fresh install:
```bash
ansible-playbook install-pulceo-node-agent.yaml
```

Reset:
```bash
ansible-playbook reset-pulceo-node-agent.yaml
```

Check for availability:
```bash
ansible-playbook install-pulceo-node-agent.yaml --start-at-task="Wait for availability"
```

Reset pulceo-node-agent
```bash
ansible-playbook reset-pulceo-node-agent.yaml
```

## PULCEO control plane

Reset with reinstallation
```bash
ansible-playbook install-pulceo.yaml --tags reinstall
```

Check for availability
```bash
ansible-playbook install-pulceo.yaml --start-at-task="Wait for availability"
```

## Reset both (new experiment)

```bash
ansible-playbook reset-pulceo-node-agent.yaml
```

```bash
ansible-playbook install-pulceo.yaml --tags reinstall
```
