#!/bin/bash

# Update the package index
apt-get update -y

# Install Docker
apt-get install docker.io -y

# Start Docker service
systemctl start docker
systemctl enable docker

# Create a Docker network
docker network create netflix-network

# Run the backend container
docker run -d -p 8080:8080 --name api --network netflix-network shacharavraham/netflix-images-api

# Run the frontend container
docker run -d -p 3000:3000 --name netflix-frontend --network netflix-network shacharavraham/netflix-images-frontend
