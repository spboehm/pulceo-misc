# Task Offloading Example

- Create a virtual environment `python3 -m venv venv`
- Activate with `source venv/bin/activate`
- `python3 offloading.py`

## Configuration

Configure in ``offloading.py``

```python
batch_sizes = [10, 20, 50, 100]
layers = ["cloud-only", "edge-only", "joint"]
```
