# piptools-docker

Docker containers with pip-tools

Usage:

```
docker run --mount type=bind,src=$(pwd),target=/src -w /src \
    otkds/piptools:python3.10 \
    [args ...]
```

An example of Makefile to utilize it:

```makefile
# Usage:
#
#   make -f path/to/piptools.mk -B PYTHON_VERSION=3.10
#
# Optional parameter:
# PYTHON_VERSION    version of Python to build requirements for in
#                   major.minor format (defaults to 3.10)

SHELL := /bin/bash

PYTHON_VERSION ?= 3.10


PIP_COMPILE = docker run --rm \
    --mount type=bind,src=$(shell pwd),target=/src \
    -w /src \
    --user $(shell id -u):$(shell id -g) \
    otkds/piptools:python$(PYTHON_VERSION) \
    compile --cache-dir=/src/.piptools-cache


.PHONY: requirements
requirements: requirements.txt requirements-dev.txt

requirements.txt: requirements.in
    $(PIP_COMPILE) requirements.in -o $@.new
    mv $@.new $@

requirements-dev.txt: requirements.txt requirements-dev.in
    $(PIP_COMPILE) requirements-dev.in -o $@.new
    mv $@.new $@
```
