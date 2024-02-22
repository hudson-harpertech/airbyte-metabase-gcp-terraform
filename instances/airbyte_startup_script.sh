#!/bin/bash

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add --
sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/debian buster stable\"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -a -G docker $USER
sudo apt-get -y install docker-compose-plugin

mkdir -p airbyte \u0026\u0026 cd airbyte
wget https://raw.githubusercontent.com/airbytehq/airbyte/master/run-ab-platform.sh
chmod +x run-ab-platform.sh\n\nsudo ./run-ab-platform.sh -b
sed -i \"s/^BASIC_AUTH_PASSWORD=.*/BASIC_AUTH_PASSWORD=SuperSecretPassword/\" .env