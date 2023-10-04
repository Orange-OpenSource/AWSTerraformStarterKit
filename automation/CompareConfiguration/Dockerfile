ARG PYTHON_VERSION=3.12.0

FROM python:${PYTHON_VERSION}-slim

# Create directory scripts and workdir
RUN mkdir /scripts /workdir

COPY . /scripts

WORKDIR /scripts

# Install dependencies
RUN pip install -r /scripts/requirements.txt --no-cache-dir

# Make the script executable
RUN chmod +x /scripts/compare_yaml_script.py

WORKDIR /workdir


CMD ["python", "/scripts/compare_yaml_script.py", "configure.yaml", "configure.yaml.dist"]
