# piptools-docker

Docker containers with pip-tools

Usage:

    docker run --mount type=bind,src=$(pwd),target=/src -w /src otkds/piptools:python3.7 [args ...]
