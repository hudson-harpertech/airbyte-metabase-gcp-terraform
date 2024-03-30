#!/bin/bash

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -a -G docker $USER
sudo apt-get -y install docker-compose-plugin

mkdir -p airbyte \u0026\u0026 cd airbyte
wget https://raw.githubusercontent.com/airbytehq/airbyte/master/run-ab-platform.sh
chmod +x run-ab-platform.sh
sudo ./run-ab-platform.sh -b
sed -i "s/^BASIC_AUTH_PASSWORD=.*/BASIC_AUTH_PASSWORD=SuperSecretPassword/" .env