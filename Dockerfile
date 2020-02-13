ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION}

RUN pip install -U pip pip-tools

ENTRYPOINT ["python", "-m", "piptools"]
