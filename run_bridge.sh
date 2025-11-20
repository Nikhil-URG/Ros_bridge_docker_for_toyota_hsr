#!/bin/bash

# --- Configuration ---
IMAGE_NAME="custom-hsr-bridge"
# The name/substring to look for in the running docker list for the simulation
SIM_CONTAINER_NAME_FILTER="tmc_wrs"

# --- 1. Find the Simulation Container ---
echo "Searching for running HSR simulation container..."
CONTAINER_ID=$(sudo docker ps -qf "name=${SIM_CONTAINER_NAME_FILTER}" | head -n 1)

if [ -z "$CONTAINER_ID" ]; then
    echo "Error: Could not find a running container matching '${SIM_CONTAINER_NAME_FILTER}'."
    echo "Please ensure the simulation is running first!"
    exit 1
fi

# --- 2. Extract Network Info ---
SIM_IP=$(sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CONTAINER_ID)
SIM_HOSTNAME=$(sudo docker inspect -f '{{ .Config.Hostname }}' $CONTAINER_ID)
# If needed, get the URI from the environment, or default to the IP
ROS_MASTER_URI="http://${SIM_IP}:11311"

echo "Found Simulation:"
echo "  Container ID: $CONTAINER_ID"
echo "  IP Address:   $SIM_IP"
echo "  Hostname:     $SIM_HOSTNAME"
echo "  Master URI:   $ROS_MASTER_URI"

# --- 3. Build the Bridge Image (if missing or requested) ---
if [[ "$(sudo docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "Bridge image not found. Building $IMAGE_NAME..."
    sudo docker build -t $IMAGE_NAME .
else
    echo "Bridge image exists. Skipping build (Run 'docker build -t $IMAGE_NAME .' manually to update)."
fi

# --- 4. Run the Bridge ---
echo "Starting Dynamic Bridge..."
echo "------------------------------------------------------"

sudo docker run -it --rm --net=host \
    --add-host ${SIM_HOSTNAME}:${SIM_IP} \
    --env ROS_MASTER_URI=${ROS_MASTER_URI} \
    --env ROS_DOMAIN_ID=0 \
    $IMAGE_NAME