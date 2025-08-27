# Offloading

## Preparation

- Create a virtual environment `python3 -m venv venv`
- Activate with `source venv/bin/activate`
- TODO: Start jupyther or Select the right python3 virtual environment
- Create `.env`

## Configuration

Configure in ``offloading.py``

```python
batch_sizes = [10, 20, 50, 100]
layers = ["cloud-only", "edge-only", "joint"]
```

