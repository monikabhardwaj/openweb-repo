#! /bin/bash

# Fail if one command fails
set -e
export DEBIAN_FRONTEND=noninteractive

echo "Hello, World 1"

#setup Docker
# Add Docker's official GPG key:
#sudo apt-get update
#sudo apt-get install ca-certificates curl
#sudo install -m 0755 -d /etc/apt/keyrings
docker pull ubuntu
docker run -it ubuntu /bin/bash

echo "Hello, World! 2"
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "Hello, World! 3"