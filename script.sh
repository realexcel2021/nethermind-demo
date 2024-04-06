#!/bin/bash

# Update the system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker & Docker Compose
# Install Docker
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Run Nethermind Docker image
cat << EOF > docker-compose.yml
version: '3.8'
services:
  nethermind:
    image: nethermind/nethermind:latest
    ports:
      - "8545:8545"
    command:
      - --JsonRpc.Enabled=true
      - --JsonRpc.EnabledModules=[admin]
    environment:
      NETHERMIND_JSONRPCCONFIG_ENABLED: "true"
      NETHERMIND_JSONRPCCONFIG_HOST: "0.0.0.0"
      NETHERMIND_JSONRPCCONFIG_ENABLEDMODULES: "[Eth, Mev, Web3]"
EOF

sudo docker-compose up -d