#!/bin/bash
sudo apt update 
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker devuser
sudo docker run -d -p 8080:80 nginx
sudo docker run -d postgres
