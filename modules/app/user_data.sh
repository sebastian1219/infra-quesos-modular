#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

sleep 20

docker pull "${docker_image}"
docker run -d --name cheese -p 80:80 "${docker_image}"

echo "Usando imagen: ${docker_image}" >> /var/log/user_data.log
docker ps >> /var/log/user_data.log
docker inspect cheese >> /var/log/user_data.log
curl -I localhost >> /var/log/user_data.log