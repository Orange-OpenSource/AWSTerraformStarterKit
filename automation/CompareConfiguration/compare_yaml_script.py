#!/usr/bin/python3

import yaml
import sys


def load_yaml(file_path):
    try:
        with open(file_path, 'r') as file:
            data = yaml.safe_load(file)
        return data
    except FileNotFoundError:
        print(f"File not found: {file_path}")
        return None
    except Exception as e:
        print(f"An error occurred while loading the file: {e}")
        return None


def compare_yaml_keys(yaml1, yaml2):
    keys1 = set(yaml1.keys())
    keys2 = set(yaml2.keys())

    common_keys = keys1.intersection(keys2)
    unique_keys_yaml1 = keys1.difference(keys2)
    unique_keys_yaml2 = keys2.difference(keys1)

    return common_keys, unique_keys_yaml1, unique_keys_yaml2


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python script.py <file1> <file2>")
        sys.exit(1)
    file1_path = sys.argv[1]
    file2_path = sys.argv[2]

    yaml1 = load_yaml(file1_path)
    yaml2 = load_yaml(file2_path)

    common_keys, unique_keys_yaml1, unique_keys_yaml2 = compare_yaml_keys(yaml1, yaml2)

    print(f"Keys unique to YAML 1: {file1_path}", unique_keys_yaml1)
    print(f"Keys unique to YAML 2: {file2_path}", unique_keys_yaml2)
