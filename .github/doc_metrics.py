import json
import sys

path = sys.argv[1]

with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

def walk(obj, prefix=""):
    if isinstance(obj, dict):
        for key, value in obj.items():
            name = f"{prefix}.{key}" if prefix else key
            if isinstance(value, (dict, list)):
                walk(value, name)
            else:
                print(f"{name}: {value}")
    elif isinstance(obj, list):
        for i, value in enumerate(obj):
            walk(value, f"{prefix}[{i}]")

walk(data)
