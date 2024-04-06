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

sudo docker pull nethermind/nethermind:latest

sudo docker run -d --name nethermind -p 8545:8545 -e NETHERMIND_JSONRPCCONFIG_ENABLED="true" \
-e NETHERMIND_JSONRPCCONFIG_HOST="0.0.0.0" \
-e NETHERMIND_JSONRPCCONFIG_ENABLEDMODULES="[Eth, Mev, Web3]" nethermind/nethermind:latest --JsonRpc.Enabled=true  --JsonRpc.EnabledModules=[admin]
