ARG PYTHON_VERSION=3.10
FROM python:${PYTHON_VERSION}

RUN pip install -U pip pip-tools

ENTRYPOINT ["python", "-m", "piptools"]
