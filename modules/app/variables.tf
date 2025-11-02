variable "environment" {
  description = "Entorno de despliegue"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
}

variable "docker_images" {
  description = "Lista de imágenes Docker para cada instancia"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID de la VPC donde se desplegarán las instancias"
  type        = string
}

variable "private_subnets" {
  description = "Lista de subredes privadas para las instancias EC2"
  type        = list(string)
}

variable "public_subnets" {
  description = "Subredes públicas para el ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ID del Security Group del ALB para permitir tráfico hacia EC2"
  type        = string
}

variable "ec2_sg_id" {
  description = "ID del Security Group para las instancias EC2 (usado si no se crea)" 
  type        = string
  default     = ""
}

variable "my_ip" {
  description = "IP personal para acceso SSH a las instancias EC2"
  type        = string
}

variable "key_name" {
  description = "Nombre de la clave SSH creada en AWS"
  type        = string
}

variable "create_ec2_sg" {
  description = "Indica si se debe crear el Security Group de EC2 dentro del módulo"
  type        = bool
  default     = true
}
