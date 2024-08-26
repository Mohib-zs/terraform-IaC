#!/bin/bash
sudo -i
sudo apt update && sudo apt -y upgrade
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker devuser
docker run -p 8080:80 nginx 