#!/bin/bash

hostnamectl set-hostname docker_instance
dnf update -y
dnf install git -y
dnf install docker -y
systemctl start docker
systemctl enable docker
usermod -a -G docker ec2-user
# install docker-compose
curl -SL https://github.com/docker/compose/releases/download/v2.26.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
cd /home/ec2-user && git clone https://github.com/ahmettgg/Devops_My_Projects.git
cd Devops_My_Projects/01-a-Terraform-Docker-Python-Bookstore
docker-compose up
