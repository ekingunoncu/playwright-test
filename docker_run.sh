#!/bin/sh

# Variables
CONTAINER_NAME="playwright_container"   # Name of the container to monitor
LOG_FILE="container_stats.log"          # Log file name
IMAGE_NAME="playwright-test:latest"     # Docker image name

# Check if the container exists, and if not, start it
if ! docker ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
  echo "Container '${CONTAINER_NAME}' does not exist."
  echo "Starting a new container from the image '${IMAGE_NAME}'..."
  docker run -d --name "$CONTAINER_NAME" "$IMAGE_NAME"
fi

# Check if the container is running, if not, start it
if ! docker ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
  echo "Starting the container '${CONTAINER_NAME}'..."
  docker start "$CONTAINER_NAME"
fi

# Start logging
echo "Logging stats for container '${CONTAINER_NAME}' to '${LOG_FILE}'..."
echo "Timestamp,Container,CPU%,Memory Usage,Net I/O,Block I/O,PIDs" > "$LOG_FILE"

# Continuously log stats until the container stops
while true
do
  # Check if the container is still running
  if ! docker ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container '${CONTAINER_NAME}' has stopped. Exiting logging."
    break
  fi

  # Log the stats
  docker stats --no-stream --format "{{.Container}},{{.CPUPerc}},{{.MemUsage}},{{.NetIO}},{{.BlockIO}},{{.PIDs}}" "$CONTAINER_NAME" \
  | awk -v timestamp="$(date +"%Y-%m-%d %H:%M:%S")" '{print timestamp","$0}' >> "$LOG_FILE"

  sleep 2  # Adjust the interval as needed (e.g., every 2 seconds)
done
