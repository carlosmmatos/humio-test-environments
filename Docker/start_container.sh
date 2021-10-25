#!/bin/bash

# Set variables
HOST_DATA_DIR=$(pwd)/mounts/data
HOST_KAFKA_DATA_DIR=$(pwd)/mounts/kafka-data
PATH_TO_READONLY_FILES=$(pwd)//etc
PATH_TO_CONFIG_FILE=$(pwd)/humio.conf

echo "Stopping existing Humio instance..."
docker stop humio || true

echo "Cleaning Humio instance..."
docker rm humio || true

echo "Checking for newer version..."
docker pull humio/humio:latest

echo "Starting Humio instance in background..."
docker run -d --restart=always -v $HOST_DATA_DIR:/data  \
       -v $HOST_KAFKA_DATA_DIR:/data/kafka-data  \
       -v $PATH_TO_READONLY_FILES:/etc/humio:ro  \
       -p 8080:8080 --name=humio --ulimit="nofile=8192:8192"  \
       --env-file=$PATH_TO_CONFIG_FILE humio/humio
