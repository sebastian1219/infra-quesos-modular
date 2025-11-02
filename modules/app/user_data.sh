#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
yum install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Esperar a que Docker esté listo
sleep 20

# Ejecutar el contenedor
docker pull "${docker_image}"
docker run -d -p 80:80 "${docker_image}"

# Validaciones
echo "Usando imagen: ${docker_image}" >> /var/log/user_data.log
docker ps >> /var/log/user_data.log
docker ps -a >> /var/log/user_data.log
curl -I localhost >> /var/log/user_data.log
