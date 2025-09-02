#!/bin/bash

# Stop and remove existing container if running
docker stop react-app || true
docker rm react-app || true

# Run the new container
docker run -d -p 80:80 --name react-app devops-app:latest
echo "React app deployed successfully on port 80"
